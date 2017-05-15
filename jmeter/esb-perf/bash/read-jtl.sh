#!/bin/bash
i=0
threshold=$(($2 * 60000))
#echo $threshold
{
read
while IFS='' read -r line || [[ -n "$line" ]]; do
    set -f # avoid globbing /expansion of *.
    array=(${line//,/ })
    tsarray[$i]=${array[0]}
    tsdiff=$((${tsarray[($i)]}-${tsarray[0]}))
    echo "${tsdiff}"
    if [ $tsdiff -lt $threshold ] 
    then 
       echo "timestamp difference less than threshold"
       LINE=$(($i+2))
       sed -i $LINE'd' $1
    fi 
    ((i++))
done
} < "$1"

echo ${#tsarray[@]}

echo "Done"
