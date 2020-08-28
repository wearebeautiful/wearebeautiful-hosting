#!/bin/bash

LOGFILE=/var/log/nginx/wab-comp.access.`date +%Y-%m-%d`.log
echo $LOGFILE

if [ ! -f "/goaccess/IGSL_BROWSERS_MTRC_AGENTS.db" ]
then
    echo "Initialize a new goacess set at /goaccess"
    head -1 $LOGFILE | goaccess - --log-format=COMBINED --persist --db-path /goaccess --process-and-exit
fi

python3 mini_server.py /html &
disown

goaccess -c $LOGFILE \
         --log-format=COMBINED \
         --real-time-html \
         -o /html/index.html \
         --restore \
         --db-path /goaccess \
         --addr=0.0.0.0 \
         --port=8001 \
         --ws-url=localhost
