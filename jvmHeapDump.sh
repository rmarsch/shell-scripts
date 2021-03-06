#!/usr/bin/env bash

set -e

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

JAVAUSER=$(ps -p $(pgrep java) -o %u | tail -n 1)
PID=$(pgrep java)
UNIQID=$(date +%s)
FILE_NAME="/tmp/heapdump-$UNIQID.hprof"

sudo -u $JAVAUSER jcmd $PID GC.run

sudo -u $JAVAUSER jmap -histo:live $PID > dump-$UNIQID.out

sort -k 4 dump-$UNIQID.out | awk '{ print $2,$3,$4 }' > sorted-dump-$UNIQID.out

sudo -u $JAVAUSER jmap -dump:format=b,file=$FILE_NAME $PID