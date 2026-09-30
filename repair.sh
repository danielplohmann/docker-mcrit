#!/bin/bash
# Run the repair jobs an upgrade to MCRIT 1.13 asks for, in order, and verify them on /status.
#
#   1. recalculatePicHashes      - recomputes function PicHashes and block hashes of every sample whose
#                                  report predates smda's escaper compatibility version (4.4.5), and
#                                  the non-Intel block hashes picblocks < 2.1.0 escaped as Intel code
#   2. rebuildPicBlockHashIndex  - the recalculation invalidates the inverted block hash index
#   3. repairMinHashes           - rehashes samples whose minhashes are stale, e.g. AArch64 (#245)
#
# Rehearsed on an 8,699-sample / 11.7M-function corpus whose reports go back to smda 1.9: 1 h 46 min,
# 5 min and 6 s. The first step is a full pass on such a corpus. It is not cheap to repeat: MCRIT 1.13
# still selects most samples again on a second run, so run it once per upgrade, not as a routine.
#
# Serve matching after this has finished: cached match jobs do not key on corpus data, so a match
# computed before the repairs would keep the old PicHashes.
# shellcheck disable=SC1091
source .env

if docker compose version >/dev/null 2>&1; then COMPOSE="docker compose"; else COMPOSE="docker-compose"; fi

echo "MCRIT ${MCRIT_TAG}: recalculating PicHashes, rebuilding the block hash index, repairing MinHashes."
echo
echo "Before you continue:"
echo "  * on a corpus with reports older than smda 4.4.5 the first step revisits every such sample -"
echo "    budget about 1 h 45 min per 12M functions; the worker is busy for that long"
echo "  * it rewrites stored PicHashes in place; take a dump first if you want to compare (README, Maintenance)"
echo "  * it only needs to run once per upgrade (see the note at the top of this script)"
echo
printf 'Proceed (y/n)? '
read -r key_result
if [ "$key_result" = "${key_result#[Yy]}" ] ; then
    echo "Aborting..."
    exit 0
fi

${COMPOSE} exec -T mcrit-server python - <<'PY'
import os, sys, time
from mcrit.client.McritClient import McritClient

client = McritClient("http://127.0.0.1:8000", apitoken=os.environ.get("MCRIT_AUTH_TOKEN") or None, raise_client_errors=True, raise_server_errors=True)
steps = [
    ("recalculatePicHashes", client.recalculatePicHashes),
    ("rebuildPicBlockHashIndex", client.rebuildPicBlockHashIndex),
    ("repairMinHashes", client.repairMinHashes),
]
for name, schedule in steps:
    started = time.time()
    job_id = schedule()
    print(f"{name}: job {job_id} scheduled", flush=True)
    result = client.awaitResult(job_id, sleep_time=10)
    job = client.getJobData(job_id)
    if result is None or not job or job.is_failed:
        print(f"{name}: FAILED after {time.time() - started:.0f} s - see the worker log (docker compose logs mcrit-worker)")
        sys.exit(1)
    print(f"{name}: done in {time.time() - started:.0f} s: {result}", flush=True)

status = client.getStatus(with_pichash=False)["status"]
stale = {key: status.get(key) for key in ("num_samples_with_stale_minhashes", "num_samples_with_stale_picblockhashes")}
print(f"/status: {stale}")
if any(value for value in stale.values()):
    print("Some samples are still stale: a sample whose disassembly is gone cannot be rehashed completely and stays counted until it is submitted again.")
    sys.exit(2)
print("All repairs verified.")
PY
