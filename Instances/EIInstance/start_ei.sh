#!/bin/bash
export JAVA_HOME=/usr/lib/jvm/jdk1.8.0_131

if pgrep -f "carbon" > /dev/null; then
    echo "Shutting down EI"
    ~/ei/wso2ei-6.1.0/bin/integrator.sh stop
    sleep 30
fi

if [[ -f ~/ei/wso2ei-6.1.0/repository/logs/gc.log ]]; then
    echo "GC Log exists. Moving to /tmp"
    mv ~/ei/wso2ei-6.1.0/repository/logs/gc.log /tmp/
fi

echo "Starting EI"
~/ei/wso2ei-6.1.0/bin/integrator.sh start
sleep 60
