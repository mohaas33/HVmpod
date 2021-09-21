High Voltage System

Location: Products directory

Commands:
To turn system on(1) and off(0) 
snmpset -v 2c -m +WIENER-CRATE-MIB -c private $IP sysMainSwitch.0 i 1  

To turn individual channels on(1) and off(0), index = channel
snmpset -Oqv -v 2c -m +WIENER-CRATE-MIB -c guru $IP outputSwitch.index i 1 



   
