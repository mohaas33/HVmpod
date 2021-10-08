#!/bin/bash
# script turns on HV system and sets voltages, rampup/rampdown rates, and trip currents

# read in voltage values
#file with voltage values (currently for 1st configuration)
voltagetxt="./config/voltage_set1.txt"

voltageList=()

#read voltage values line by line and append to voltage list
while IFS= read -r line || [ -n "$line" ]
do
    voltageList+=("$line")
done < "$voltagetxt"

#number of voltages in the list
nVoltages=${#voltageList[@]}

# read in rampup rates
#file with rampup rates (currently for 1st configuration)
rampuptxt="./config/rampup_set1.txt"

rampupList=()

#read rampup rates line by line and append to rampup list
while IFS= read -r line || [ -n "$line" ]
do
    rampupList+=("$line")
done < "$rampuptxt"

# read in rampdown rates
#file with rampdown rates (currently for 1st configuration)
rampdowntxt="./config/rampdown_set1.txt"

rampdownList=()

#read rampdown rates line by line and append to rampdown list
while IFS= read -r line || [ -n "$line" ]
do
    rampdownList+=("$line")
done < "$rampdowntxt"

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
	    #Set voltage rampup rate
	    snmpset -Oqv -v 2c -m +WIENER-CRATE-MIB -c guru 192.168.1.102 outputVoltageRiseRate.u$index F ${rampupList[$i]}
	    #Set voltage rampdown rate
	    snmpset -Oqv -v 2c -m +WIENER-CRATE-MIB -c guru 192.168.1.102 outputVoltageFallRate.u$index F ${rampdownList[$i]}
	    #Turn channel of each module at the index on 
	    snmpset -Oqv -v 2c -m +WIENER-CRATE-MIB -c guru 192.168.1.102 outputSwitch.u$index i 1
	done
    fi 
done
