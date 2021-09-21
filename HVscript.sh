#!/bin/bash

#positions of modules in HV crate (0-9)
module1=2
module2=3
module3=5
module4=6
module5=8
module6=9
#Turn on HV system on 
snmpset -v 2c -m +WIENER-CRATE-MIB -c private 192.168.1.102 sysMainSwitch.0 i 1
sleep 20s  #Wait 20s before turning all channels on (delay must be >10s)
#loop through all modules
for j in {0..9}
do
    if [[ ($j -eq $module1) || ($j -eq $module2) || ($j -eq $module3) || ($j -eq $module4) || ($j -eq $module5) || ($j -eq $module6) ]]
    then
	#Loop through all channel per module
	for i in {0..15}
	do
	    multfactor=100
	    index=$(( $j * $multfactor + $i ))
	    #Turn channel of each module at the index on 
	    snmpset -Oqv -v 2c -m +WIENER-CRATE-MIB -c guru 192.168.1.102 outputSwitch.u$index i 1
	done
    fi 
done

sleep 20s
#loop through all modules to turn each channel off
for j in {0..9}
do
    if [[ ($j -eq $module1) || ($j -eq $module2) || ($j -eq $module3) || ($j -eq $module4) || ($j -eq $module5) || ($j -eq $module6) ]]
    then
	#Loop through all channel per module
	for i in {0..15}
	do
	    multfactor=100
	    index=$(( $j * $multfactor + $i ))
	    #Turn channel of each module at the index off 
	    snmpset -Oqv -v 2c -m +WIENER-CRATE-MIB -c guru 192.168.1.102 outputSwitch.u$index i 0
	done
    fi 
done
#turn system off
snmpset -v 2c -m +WIENER-CRATE-MIB -c private 192.168.1.102 sysMainSwitch.0 i 0





