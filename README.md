# ESPLogger
An IoT project using an ESP8266 with nodeMCU firmware, to read sensor values and send them to Thingspeak.


Tested and compatible with NodeMCU 0.9.6 build 20150406 https://github.com/nodemcu/nodemcu-firmware

#Hardware
 Any ESP8266 module with GPIO12,13 and 14 pinned out (eg ESP-07,ESP-12)
 DHT22 temperature and humidty sensor
 BH1750fvi Illuminance sensor
 A 3.3V Voltage regulator
#Software
 nodeMCU firmware
 nodeMCU flasher
 esplorer IDE for nodeMCU
#Installing
 Flash NodeMCU firmware on to the module
 Reboot in user mode
 Upload all files using esplorer
 Configure wireless SSID+password in init.lua
 Configure Thingspeak write channel


Thanks to:

https://github.com/nodemcu/nodemcu-firmware 
https://github.com/hamishcunningham/fishy-wifi
