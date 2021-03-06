## **High Voltage System**

### **HTML monitoring page** 

[192.168.1.102](http://192.168.1.102/)

### Scripts to setup voltages

[Voltage scheme.](https://github.com/mohaas33/HVmpod/blob/main/config/NikolaiSettings-HalfGap4.xlsx)

- To setup voltages rampup/ramdown speed and trip currents and turn each channel ON:

`HVsetVoltage.sh`

It reads the values from files:

[voltage_set1.txt](https://github.com/mohaas33/HVmpod/blob/main/config/voltage_set1.txt)

[rampup_set1.txt](https://github.com/mohaas33/HVmpod/blob/main/config/rampup_set1.txt)

- To rampdown:

`HVturnoff.sh`

It reads the values from files:

[rampdown_set1.txt](https://github.com/mohaas33/HVmpod/blob/main/config/rampdown_set1.txt)


### **Main commands**

To turn system on(1) and off(0) 
snmpset -v 2c -m +WIENER-CRATE-MIB -c private $IP sysMainSwitch.0 i 1  

To turn individual channels on(1) and off(0), index = channel
snmpset -Oqv -v 2c -m +WIENER-CRATE-MIB -c guru $IP outputSwitch.index i 1 


### **Script should do:**
- [ ] Read voltage settings from the txt file ([example](https://github.com/mohaas33/HVmpod/blob/main/config/voltage_set.txt) );
- [ ] Set the rampup speed and the voltage for each channel with respect to the txt file;
- [ ] Read the voltages on the channels that it have turned on and print on the screen;

