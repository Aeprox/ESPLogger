# ESPLogger
An IoT project using an ESP8266 with nodeMCU firmware, to read sensor values and send them to Thingspeak.

Tested and compatible with NodeMCU 0.9.6 build 20150406 https://github.com/nodemcu/nodemcu-firmware

This project is licensed under the terms of the MIT license. See full license in LICENSE.md

##Hardware
* Any ESP8266 module with GPIO12,13 and 14 pinned out (eg ESP-07,ESP-12)
* DHT22 temperature and humidty sensor
* BH1750fvi Illuminance sensor
* (Optional) TSL2561 Illuminance sensor

TODO: hardware connections

##Software
* [nodeMCU firmware](https://github.com/nodemcu/nodemcu-firmware)
* [TSL2561 library](https://github.com/hamishcunningham/fishy-wifi)


#Installing & configuring
1. Flash the module with nodeMCU firmware
2. Reboot in user mode
3. Configure wireless SSID+password in init.lua
4. Configure Thingspeak write channel and update interval in init.lua
5. (Optional: In case you don't use the default hardware wiring as shown above, change the pin values in init.lua)
6. Upload all files to the module
7. Compile all files except datalogger.lua and init.lua to .lc files and delete the original lua files. 
8. Reboot and watch the serial interface to see the magic happen.

If all went well you should now start seeing text on the serial interface (baudrate 9600). If the modules managed to connect to your network, it will display it's IP. If it keeps reconnecting, you might have network issues. Try using some of the nodeMCU API commands to figure it out and send me an Issue on github.


Thanks to:

https://github.com/nodemcu/nodemcu-firmware 
https://github.com/hamishcunningham/fishy-wifi
