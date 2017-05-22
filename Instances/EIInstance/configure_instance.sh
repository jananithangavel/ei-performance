#!/bin/bash
if [ -f ~/software/java/jdk-8u131-linux-x64.tar.gz ]; then
  echo "Installing Java..."
  yes | sudo ./install-java.sh -f ~/software/java/jdk-8u131-linux-x64.tar.gz
else
  echo "JDK not available !!!"
fi

if [ -f ~/software/wso2ei-6.1.0.zip ]; then
if [ -d ~/ei/wso2ei-6.1.0/ ]; then
    echo "WSO2 EI pack available!!"
else
    mkdir ~/ei
    unzip ~/software/wso2ei-6.1.0.zip -d ~/ei
fi
else
   echo "WSO2 EI pack is not available!!"
fi

if [ -f ~/software/ESBPerformanceTestArtifacts_1.0.0.car ]; then
    echo "Deploying CAPP!!"
    mv ~/software/ESBPerformanceTestArtifacts_1.0.0.car ~/ei/wso2ei-6.1.0/repository/deployment/server/carbonapps
else
   echo "CAPP is not available!!"
fi

sleep 1
