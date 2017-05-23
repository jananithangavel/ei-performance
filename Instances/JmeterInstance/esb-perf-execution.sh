#!/bin/bash

echo "Starting remote Netty backend"
ssh esbperfbackend "~/netty_start.sh 0"
sleep 10

echo "Starting remote ESB Server!"
ssh esbperfesb "./start_ei.sh"
sleep 10

echo "Checking ESB Server Health"
while true 
do
  RSP="$(curl -sL -w "%{http_code}\\n"  "http://$1:8280/services/Version" -o /dev/null)"
  if [ "$RSP" == 200 ]
  then
      break
  fi
  echo "Server Up"
done
sleep 10

echo "Jmeter script execution goes here!!!"
JVM_ARGS="-Xms2g -Xmx2g -XX:+PrintGC -XX:+PrintGCDetails -XX:+PrintGCDateStamps -Xloggc:$PWD/results/$2/gclogs/jmeter_gc_$1_$2.log"
echo "# Running JMeter. Concurrent Users: $2 Service: $4. Duration: $3 JVM Args: $JVM_ARGS"
~/apache-jmeter-3.2/bin/jmeter.sh -JConcurrency=$2 -JDuration=$3 -JHost=$1 -JService=$4 -JPayload=$5 -n -t jmeter/ESB_Perf.jmx -l jtl_results/$4_C_$2_T_$3_P_$5.jtl
ss -s > results/$2/jmeter_ss_$4_C_$2_T_$3_P_$5.txt
ssh esbperfesb "ss -s" > results/$2/ei_ss_$2.txt
ssh esbperfbackend "ss -s" > results/$2/netty_ss_$2.txt

echo "Warm up period removing..."
java -jar jtlprocessor/TrimJTL.jar jtl_results/$4_C_$2_T_$3_P_$5.jtl processed_results/$4_C_$2_T_$3_P_$5.jtl 10

echo "Generating reports!!!"
~/apache-jmeter-3.2/bin/jmeter -g processed_results/$4_C_$2_T_$3_P_$5.jtl -o reports/$4_C_$2_T_$3_P_$5

echo "Done"

ssh esbperfesb "killall java"

sleep 30

