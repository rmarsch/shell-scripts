#!/bin/bash

JAVAUSER=$(ps -p $(pgrep java) -o %u | tail -n 1)
PID=$(pgrep java)
UNIQID=$(date +%s)

sudo -u $JAVAUSER jstack $PID > threaddump-$UNIQID.log

for i in {1..100}; do
  sudo -u $JAVAUSER jstack $PID >> flame-graph-stacks-$UNIQID.jstk
  sleep 0.25
done