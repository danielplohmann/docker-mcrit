#!/bin/sh 
# wait for mongodb
#until $(curl --noproxy '*' --output /dev/null --head --fail http://mongodb:27017/); do
#    echo "Waiting for mongodb..."
#    sleep 1
#done
sleep 1
cd /opt/mcrit
python -m mcrit server