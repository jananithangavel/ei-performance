#!/bin/bash
mkdir tmp

product="wso2ei-6.1.1" #"wso2esb-5.0.0"
if [ -f ~/software/java/jdk-8u131-linux-x64.tar.gz ]; then
  echo "Installing Java..."
  yes | sudo ./install-java.sh -f ~/software/java/jdk-8u131-linux-x64.tar.gz
else
  echo "JDK not available !!!"
fi

if [ -f ~/software/$product.zip ]; then
if [ -d ~/product/$product/ ]; then
    echo "WSO2 EI pack available!!"
else
    mkdir ~/product
    unzip ~/software/$product.zip -d ~/product
fi
else
   echo "WSO2 EI pack is not available!!"
fi

if [ -f ~/software/ESBPerformanceTestArtifacts_1.0.0.car ]; then
    echo "Deploying CAPP!!"
    mv ~/software/ESBPerformanceTestArtifacts_1.0.0.car ~/product/$product/repository/deployment/server/carbonapps
else
   echo "CAPP is not available!!"
fi

mkdir ~/product/$product/repository/deployment/server/resources

if [ -f ~/software/store.jks ]; then
    echo "Moving store.jks file"
    mv ~/software/store.jks ~/product/$product/repository/deployment/server/resources
else
   echo "store.jks is not available!!"
fi

echo "Installing sar" 
yes | sudo apt-get install sysstat
sudo sed -i 's|ENABLED=.*|ENABLED="true"|' /etc/default/sysstat
sudo service sysstat restart



sleep 1
