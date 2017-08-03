#!/bin/bash

JAVAUSER=$(ps -p $(pgrep java) -o %u | tail -n 1)
PID=$(pgrep java)
UNIQID=$(date +%s)

sudo -u $JAVAUSER jstack $PID > threaddump-$UNIQID.log

# Adjust the substr operation as useful to group similar threads/pools
awk '{ print $1 }' threaddump-$UNIQID.log | grep '"' | sort | awk '{print substr($0,0,13)}' | uniq -c | sort -nr > sort-threadnames-$UNIQID.log

# Groups and counts duplicate stack traces to make it easier to count how many threads are at the same call
awk '/(at )|^$|(Thread\.State)/ { print $0 }' threaddump-$UNIQID.log | awk -v RS=""  '{gsub(/\n/," "); print}' | uniq -c | sort -nr | awk '{ print $0 "\n" }' | awk 1 RS="\tat" > sorted-thread-traces-$UNIQID.log