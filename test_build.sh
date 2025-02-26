#!/bin/bash
source .env set
echo "building mcrit ${MCRIT_BRANCH} / mcritweb ${MCRITWEB_BRANCH} (mcrit tag: ${MCRIT_TAG})"
docker build -t mcrit docker/mcrit --no-cache --build-arg MCRIT_BRANCH=${MCRIT_BRANCH}
docker build -t mcritweb docker/mcritweb --no-cache --build-arg MCRITWEB_BRANCH=${MCRITWEB_BRANCH} --build-arg MCRIT_TAG=${MCRIT_TAG}
