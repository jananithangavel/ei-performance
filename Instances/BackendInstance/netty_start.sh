#!/bin/bash
if pgrep -f "netty" > /dev/null; then
    echo "Shutting down Netty"
    sudo killall java
    sleep 2
fi

if [ -d ~/netty/netty_backend/logs ]; then
   echo "logs folder exsists"
else
   echo "logs folder not found!"
   mkdir ~/netty/netty_backend/logs
   echo "logs folder created!"
fi

if [ -d ~/netty/netty_backend/tmp ]; then
   echo "tmp folder exsists"
else
   echo "tmp folder not found!"
   mkdir ~/netty/netty_backend/tmp
   echo "tmp folder created!"
fi


if [[ -f ~/netty/netty_backend/logs/nettygc.log ]]; then
    echo "GC Log exists. Moving to /tmp"
    mv ~/netty/netty_backend/logs/nettygc.log ~/netty/netty_backend/tmp/
fi

echo "Starting Netty"
nohup java -Xms2g -Xmx2g -XX:+PrintGC -XX:+PrintGCDetails -XX:+PrintGCDateStamps -Xloggc:/home/ubuntu/netty/netty_backend/logs/nettygc.log -jar ~/netty/netty_backend/netty-echo-service-0.1.0-SNAPSHOT.jar --port 9000 --worker-threads 3000 --sleep-time $1 </dev/null >~/netty/netty_backend/logs/netty.out 2>&1 &
sleep 2
