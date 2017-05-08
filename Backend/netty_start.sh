#!/bin/bash
if pgrep -f "netty" > /dev/null; then
    echo "Shutting down Netty"
    killall java
    sleep 2
fi

if [[ -f ./logs/nettygc.log ]]; then
    echo "GC Log exists. Moving to /tmp"
    mv ./logs/nettygc.log ./tmp/
fi

echo "Starting Netty"
nohup java -Xms2g -Xmx2g -XX:+PrintGC -XX:+PrintGCDetails -XX:+PrintGCDateStamps -Xloggc:./logs/nettygc.log -jar netty-echo-service-0.1.0-SNAPSHOT.jar --port 8080 --worker-threads 3000 --sleep-time $1 </dev/null >./logs/netty.out 2>&1 & 
sleep 2