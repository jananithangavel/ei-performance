# WSO2 EI Perf Testing Tool using Jmeter #
An automated script framework for performance testing WSO2 EI using Jmeter

Execution command: 

Edit the iterations.sh file for the scenarios and the number of iterations 
the test needs to run. 

Then run the iterations.sh
$nohup ./iterations.sh &

Each entry in the iterations.sh will have the perf test execution command as following.
./esb-perf-execution.sh remote-wso2ei-ip concurrency timelimit service payload

Ex:- 
./esb-perf-execution.sh 192.168.48.168 80 300 DirectProxy 5K_buyStocks.xml
