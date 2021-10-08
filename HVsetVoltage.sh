#!/bin/bash

#file with voltage values (currently just using an example file)
voltagetxt="./config/voltage_set.txt"

voltageList=()

#read voltage values line by line and append to voltage list
while IFS= read -r line || [ -n "$line" ]
do
    voltageList+=("$line")
done < "$voltagetxt"

#number of voltages in the list
nVoltages=${#voltageList[@]}

#positions of modules in HV crate (0-9)
module1=2
module2=3
module3=5
module4=6
module5=8
module6=9
#Turn on HV system on 
snmpset -v 2c -m +WIENER-CRATE-MIB -c private 192.168.1.102 sysMainSwitch.0 i 1
#Wait 20s before turning all channels on (delay must be >10s)
sleep 20s  
#loop through all modules
for j in {0..9}
do
    #if [[ ($j -eq $module1) || ($j -eq $module2) || ($j -eq $module3) || ($j -eq $module4) || ($j -eq $module5) || ($j -eq $module6) ]]
    if [ $j -eq $module1 ]
    then
	#Loop through all channels per module
	for (( i=0; i<$nVoltages; i++ ))
	do
	    multfactor=100
	    index=$(( $j * $multfactor + $i ))
	    #Set voltage of channel at the index
	    snmpset -Oqv -v 2c -m +WIENER-CRATE-MIB -c guru 192.168.1.102 outputVoltage.u$index F ${voltageList[$i]}
	    #Set rate of voltage increase
	    snmpset -Oqv -v 2c -m +WIENER-CRATE-MIB -c guru 192.168.1.102 outputVoltageRiseRate.u$index F 5.0
	    #Turn channel of each module at the index on 
	    snmpset -Oqv -v 2c -m +WIENER-CRATE-MIB -c guru 192.168.1.102 outputSwitch.u$index i 1
	    #Check status of channel
	    snmpset -Oqv -v 2c -m +WIENER-CRATE-MIB -c guru 192.168.1.102 outputStatus.u$index i 1
	done
    fi 
done

sleep 20s
#loop through all modules to turn each channel off
for j in {0..9}
do
    if [ $j -eq $module1 ]
    then
	#Loop through all channel per module
	for (( i=0; i<${nVoltages}; i++ ))
	do
	    multfactor=100
	    index=$(( $j * $multfactor + $i ))
	     #Set voltage of channel at the index
	    snmpset -Oqv -v 2c -m +WIENER-CRATE-MIB -c guru 192.168.1.102 outputVoltage.u$index F 0
	    #Set rate of voltage decrease
	    snmpset -Oqv -v 2c -m +WIENER-CRATE-MIB -c guru 192.168.1.102 outputVoltageFallRate.u$index F 5.0
	    #Turn channel of each module at the index off 
	    snmpset -Oqv -v 2c -m +WIENER-CRATE-MIB -c guru 192.168.1.102 outputSwitch.u$index i 0
	done
    fi 
done
#turn system off
snmpset -v 2c -m +WIENER-CRATE-MIB -c private 192.168.1.102 sysMainSwitch.0 i 0





