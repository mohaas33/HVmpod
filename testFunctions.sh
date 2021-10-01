#Test with first channel
index=201

#Check status of channel
snmpget -Oqv -v 2c -m +WIENER-CRATE-MIB -c guru 192.168.1.102 outputStatus.u$index
#Check rise rate setting
snmpget -Oqv -v 2c -m +WIENER-CRATE-MIB -c guru 192.168.1.102 outputVoltageRiseRate.u$index 
#Set voltage of channel at the index
snmpset -Oqv -v 2c -m +WIENER-CRATE-MIB -c guru 192.168.1.102 outputVoltage.u$index F 0.0
#Set rate of voltage increase
#snmpset -Oqv -v 2c -m +WIENER-CRATE-MIB -c guru 192.168.1.102 outputVoltageRiseRate.u$index F 50.0

#ON
tmult=1000
start=0
#Turn channel of each module at the index on 
snmpset -Oqv -v 2c -m +WIENER-CRATE-MIB -c guru 192.168.1.102 outputSwitch.u$index i 1
#Set rate of voltage increase
snmpset -Oqv -v 2c -m +WIENER-CRATE-MIB -c guru 192.168.1.102 outputVoltageRiseRate.u$index F 50.0
#Set voltage of channel at the index
snmpset -Oqv -v 2c -m +WIENER-CRATE-MIB -c guru 192.168.1.102 outputVoltage.u$index F 100.0
elapsed=$(( SECONDS - start ))
echo "time to turn on= $(( $tmult * $elapsed )) ms"
#Check status of channel
snmpget -Oqv -v 2c -m +WIENER-CRATE-MIB -c guru 192.168.1.102 outputStatus.u$index

sleep 20s
#OFF
#Set rate of voltage decrease
snmpset -Oqv -v 2c -m +WIENER-CRATE-MIB -c guru 192.168.1.102 outputVoltageFallRate.u$index F 50.0
#Set voltage of channel at the index
snmpset -Oqv -v 2c -m +WIENER-CRATE-MIB -c guru 192.168.1.102 outputVoltage.u$index F 0
#Turn channel of each module at the index off 
snmpset -Oqv -v 2c -m +WIENER-CRATE-MIB -c guru 192.168.1.102 outputSwitch.u$index i 0
