#!/bin/bash
if [ -f ~/software/java/jdk-8u131-linux-x64.tar.gz ]; then
  echo "Installing Java..."
  yes | sudo ./install-java.sh -f ~/software/java/jdk-8u131-linux-x64.tar.gz
else
  echo "JDK not available !!!"
fi

if [ -f ~/software/netty/netty_backend.zip ]; then
if [ -d ~/netty/netty_backend/ ]; then
    echo "netty backend is available!!"
else
    unzip ~/software/netty/netty_backend.zip -d ~/netty/
fi
else
   echo "netty backend is not available!!"
fi

echo "Installing sar" 
yes | sudo apt-get install sysstat
sudo sed -i 's|ENABLED=.*|ENABLED="true"|' /etc/default/sysstat
sudo service sysstat restart


sleep 1
