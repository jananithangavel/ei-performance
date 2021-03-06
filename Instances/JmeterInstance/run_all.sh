#!/bin/bash
if [[ -d results ]]; then
    echo "Results directory already exists"
fi

concurrent_users=(10 50 100 500 1000 1500 2000 2500)
proxy_type=(DirectProxy CBRProxy CBRSOAPHeaderProxy CBRTransportHeaderProxy SecureProxy XSLTEnhancedProxy XSLTProxy)
request_payloads=(1K_buyStocks.xml 5K_buyStocks.xml 10K_buyStocks.xml 100K_buyStocks.xml 500K_buyStocks.xml 500B_buyStocks.xml)
secure_payloads=(1K_buyStocks_secure.xml 5K_buyStocks_secure.xml 10K_buyStocks_secure.xml 100K_buyStocks_secure.xml 500K_buyStocks_secure.xml 500B_buyStocks_secure.xml)

ei_host=192.168.48.203
test_duration=1800

ei_ssh_host=esbperfesb
backend_ssh_host=esbperfbackend

mkdir -p results/gclogs

run_tests() {

 for c in ${concurrent_users[@]} ; do
        for h in ${proxy_type[@]} ; do
                      mkdir -p ~/results/$c
                      if [ h == "SecureProxy" ] ; then
                           for i in ${secure_payloads[@]} ; do
                               ./esb-perf-execution.sh $ei_host $c $test_duration $h $i
                           done
                      else
                           for j in ${request_payloads[@]} ; do
                               ./esb-perf-execution.sh $ei_host $c $test_duration $h $j
                           done
                      fi
        scp $ei_ssh_host:~/ei/wso2ei-6.1.0/repository/logs/gc.log $PWD/results/gclogs/ei_gc_$c.log
        scp $backend_ssh_host:~/netty/netty_backend/tmp/nettygc.log $PWD/results/gclogs/netty_gc_$c.log
        sar -q > results/$c/jmeter_loadavg.txt
        ssh $ei_ssh_host "sar -q" > results/$c/ei_loadavg.txt
        ssh $ei_ssh_host "top -bn 1" > results/$c/ei_top.txt
        ssh $ei_ssh_host "ps u -p \`pgrep -f carbon\`" > results/$c/ei_ps.txt
        ssh $backend_ssh_host "sar -q" > results/$c/ei_loadavg.txt
        ssh $backend_ssh_host "top -bn 1" > results/$c/ei_top.txt
        ssh $backend_ssh_host "ps u -p \`pgrep -f netty\`" > results/$c/ei_ps.txt
        # Increased due to errors
        sleep 240
        done
  done
}

run_tests

echo "Completed"

