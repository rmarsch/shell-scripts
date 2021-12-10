#!/bin/bash

if [[ -z $1 || -z $2 ]]
then
	echo "Need to enter the type and the seconds as arguments like 'asyncprofilerlauncher.sh alloc 60'. Types are whatever is supported by async profiler like 'cpu' and 'alloc'"
	exit 1
fi	

type=$1
seconds=$2
format=${3:-html}
timestamp=$(date +%Y%m%d%H%M%S)
pid=$(pgrep java)

sudo -u hbase /opt/async-profiler/profiler.sh -e $type -d $seconds -o $format -f /tmp/async-profiler-$type-out-$timestamp\.$format $pid
