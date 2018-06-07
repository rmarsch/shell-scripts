#!/usr/bin/env bash

set -e

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

JAVAUSER=$(ps -p $(pgrep java) -o %u | tail -n 1)
PID=$(pgrep java)
UNIQID=$(date +%s)
FILENAME="/tmp/flame-graph-stacks-$UNIQID.jstk"

echo "Attempting to build a flame graph dump for $JAVAUSER with pid $PID and writing to $FILENAME"

for i in {1..100}; do
  sudo -u $JAVAUSER jstack $PID >> $FILENAME
  printf "."
  sleep 0.25
done