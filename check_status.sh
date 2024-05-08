#!/bin/bash


var1=$(docker exec -i nso1_primary ncs_cli -C -u admin <<< "exit" &> /dev/null ; echo $?)
Data1=$(($var1))
var2=$(docker exec -i nso2_secondary ncs_cli -C -u admin <<< "exit" &> /dev/null ; echo $?)
Data2=$(($var2))
Result=$(($Data1+$Data2))

echo "NSO Status: "
echo -ne "NOT READY: NSO1 Status: $var1 / NSO2 Status: $var2\033[0K\r"

while [ $Result -ne 0 ]
do
var1=$(docker exec -i nso1_primary ncs_cli -C -u admin <<< "exit" &> /dev/null ; echo $?)
Data1=$(($var1))
var2=$(docker exec -i nso2_secondary ncs_cli -C -u admin <<< "exit" &> /dev/null ; echo $?)
Data2=$(($var2))
Result=$(($Data1+$Data2))

echo -ne "NOT READY: NSO1 Status: $var1 / NSO2 Status: $var2\033[0K\r"
sleep 5
done

#sleep 2
echo -e "READY: NSO1 and NSO2 Up\033[0K\r"
