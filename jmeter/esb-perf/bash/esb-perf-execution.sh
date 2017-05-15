#!/bin/bash

#echo "Starting remote Tomcat"
#ssh -i chamaraa.pem ubuntu@$1 'export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/home/ubuntu/java/jdk1.8.0_121/bin;./tomcat/apache-tomcat-7.0.29/bin/catalina.sh start' &
#ssh esbperfbackend "./start_tomcat.sh"
#sleep 10

echo "Starting remote Netty backend"
ssh esbperfbackend "./netty/netty_backend/netty_start.sh 0"
sleep 10

echo "Starting remote ESB Server!"
#ssh -i chamaraa.pem ubuntu@$2 'export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/home/ubuntu/java/jdk1.8.0_121/bin;./esb/wso2esb-5.0.0/bin/wso2server.sh start' & 
ssh esbperfesb "./start_ei.sh"
sleep 40

echo "Checking ESB Server Health"
while true 
do
  RSP="$(curl -sL -w "%{http_code}\\n"  "http://$1:8280/services/Version" -o /dev/null)"
  if [ "$RSP" == 200 ]
  then
      break
  fi
  echo "Server Up"
  sleep 10 
done
sleep 10

echo "Jmeter script execution goes here!!!"
JVM_ARGS="-Xms2g -Xmx2g -XX:+PrintGC -XX:+PrintGCDetails -XX:+PrintGCDateStamps -Xloggc:$PWD/../results/gclogs/jmeter_gc_$1_$2.log"
/home/ubuntu/apache-jmeter-3.2/bin/jmeter.sh -JConcurrency=$2 -JDuration=$3 -JHost=$1 -JService=$4 -JPayload=$5 -n -t ../jmeter/ESB_Perf.jmx -l ../jtl_results/$4_C_$2_T_$3_P_$5.jtl -e -o ../reports/$4_C_$2_T_$3_P_$5 
ss -s > ../results/jmeter_ss_$4_C_$2_T_$3_P_$5.txt

echo "Done"

ssh esbperfesb "killall java"

sleep 30
