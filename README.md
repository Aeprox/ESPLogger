# ESPLogger
An IoT project using an ESP8266 wifi-module to read temperature/humidity/illuminance sensor values and send them to Thingspeak. This project is written in [Lua](http://www.lua.org/) and uses the [nodeMCU firmware](https://github.com/nodemcu/nodemcu-firmware) to run lua on the ESP8266.

This project is licensed under the terms of the MIT license. See full license in LICENSE.md

##Hardware
* Any ESP8266 module with GPIO12,13 and 14 pinned out (eg ESP-07,ESP-12)
* DHT22 temperature and humidty sensor
* Supports BH1750fvi and TSL2561 Illuminance sensor
* A USB-to-TTL or arduino to flash the ESP module


![ESPLogger schematic](/hardware/ESPLogger_schema.png "ESPLogger schematic")

##Software
* [nodeMCU firmware](https://github.com/nodemcu/nodemcu-firmware)
* [TSL2561 library](https://github.com/hamishcunningham/fishy-wifi)


#Installing & configuring
1. Flash the module with the [0.9.6-dev_20150627](https://github.com/nodemcu/nodemcu-firmware/releases/tag/0.9.6-dev_20150627) build (only tested with floating point builds)
2. Reboot in user mode
3. Configure the following settings in usersettings.lua
  * Configure Thingspeak write channel and update interval in usersettings.lua
  * Configure wireless SSID and password
  * Select illuminance sensor (default: none)
    * For tsl2561 sensor: select gain and integration time (default: no gain, 402ms)
  * (Optional: In case you don't use the default hardware wiring as mentioned in the settings above, change the pin values in usersettings.lua)
6. Upload the following lua files to the module.
  1. usersettings.lua
  2. either bh1750.lua or tsl2561.lua and i2cutils.lua
  3. init.lua
  4. readsensors.lua
  5. thingspeak.lua
7. Compile all files except usersettings.lua and init.lua to .lc files and delete the original .lua files. You may have to reboot sometimes to clear some heap when the module won't compile the files
8. Reboot and watch the serial interface to see the magic happen.

If all went well you should now start seeing text on the serial interface (baudrate 9600). If it keeps reconnecting, you might have network issues. Try using some of the nodeMCU API commands to figure it out and/or send me an Issue on github.

# Changelog
ESPLogger v1.1 (2015-08-XX)
* Updated to nodeMCU 0.9.6-dev_20150627
* Support for node.dsleep()! Greatly decreases power consumption. See usersettings.lua to enable
* 

ESPLogger v1.0 (2015-06-15)
* Supports DHT22, BH1750 and TSL2561
* Sends data to thingspeak
* No power savings included (yet!)

# Known issues
1. Some cheap chinese modules come with incorrect silkscreen and wrong pin-numbering. Double-check
2. The esp8266 can't connect to AES-protected networks (afaik? user input is welcome!)
3. Weird crashes? Memory issues? Send us a an issue report on github please.







Thanks to:

[nodeMCU firmware](https://github.com/nodemcu/nodemcu-firmware) & [TSL2561 library](https://github.com/hamishcunningham/fishy-wifi)
