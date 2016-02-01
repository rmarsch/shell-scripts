#!/bin/sh

JAVAUSER=$(ps -p $(pgrep java) -o %u | tail -n 1)
PID=$(pgrep java)
UNIQID=$(date +%s)

sudo -u $JAVAUSER jstack $PID > threaddump-$UNIQID.log

# Adjust the substr operation as useful to group similar threads/pools
cat threaddump-$UNIQID.log | awk '{ print $1 }' | grep '"' | sort | awk '{print substr($0,0,13)}' | uniq -c | sort -nr > sort-threadump-$UNIQID.log