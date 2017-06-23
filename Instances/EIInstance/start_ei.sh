
#!/bin/bash
export JAVA_HOME=/usr/lib/jvm/jdk1.8.0_131

if pgrep -f "carbon" > /dev/null; then
echo "Shutting down EI"
if [[ $1 == *"wso2ei"* ]] ; then
    ~/product/$1/bin/integrator.sh stop
else
    ~/product/$1/bin/wso2server.sh stop
fi
    sleep 30
fi

if [[ -f ~/product/$1/repository/logs/gc.log ]]; then
    echo "GC Log exists. Moving to /tmp"
    mv ~/product/$1/repository/logs/gc.log ~/tmp/
fi

echo "Starting EI"
if [[ $1 == *"wso2ei"* ]] ; then
    ~/product/$1/bin/integrator.sh start
else
    ~/product/$1/bin/wso2server.sh start
fi

sleep 60
