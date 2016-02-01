#!/bin/sh

JAVAUSER=$(ps -p $(pgrep java) -o %u | tail -n 1)
PID=$(pgrep java)
UNIQID=$(date +%s)

sudo -u $JAVAUSER jcmd $PID GC.run

sudo -u $JAVAUSER jmap -histo:live $PID > dump-$UNIQID.out

sort -k 4 dump-$UNIQID.out | awk '{ print $2,$3,$4 }' > sorted-dump-$UNIQID.out

sudo -u $JAVAUSER jmap -dump:format=b,file=/tmp/heapdump-$UNIQID.hprof $PID

sudo mv /tmp/heapdump-$UNIQID.hprof ~/

sudo chown $(whoami) ~/heapdump-$UNIQID.hprof