#!/bin/bash
if [ -f ~/software/java/jdk-8u131-linux-x64.tar.gz ]; then
  echo "Installing Java..."
  yes | sudo ./install-java.sh -f ~/software/java/jdk-8u131-linux-x64.tar.gz
else
  echo "JDK not available !!!"
fi

if [ -f ~/config ]; then
   echo "Moving config file..."
   mv ~/config ~/.ssh
else
   echo "Config file not available!!"
fi

if [ -f ~/software/apache-jmeter-3.2.tgz ]; then
if [ -d ~/apache-jmeter-3.2/ ]; then
    echo "jmeter is available!!"
else
    echo "Installing jmeter.."
    tar -xvzf ~/software/apache-jmeter-3.2.tgz -C ~/
fi
else
   echo "jmeter is not available!!"
fi

echo "Installing sar" 
yes | sudo apt-get install sysstat
sudo sed -i 's|ENABLED=.*|ENABLED="true"|' /etc/default/sysstat
sudo service sysstat restart

sleep 1
