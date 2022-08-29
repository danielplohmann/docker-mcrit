#!/bin/sh 
cd /opt/mcritweb
export FLASK_APP=mcritweb
export FLASK_ENV=mcritweb
export FLASK_DEBUG=1
export MCRIT_DEFAULT_SERVER="http://mcrit-server:8000/"

if [ ! -f /opt/mcritweb/instance/mcritweb.sqlite ]; then
    flask init-db
fi
flask run --host 0.0.0.0