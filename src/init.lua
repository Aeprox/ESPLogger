print("Aeprox ESP8266 datalogger. V0.2 (Compatible with NodeMCU 0.9.6 build 20150406) ")


-- user settings
SSID = ""
password = ""
APIkey = "" -- thingspeak API write key for channel
APIdelay = 120 -- thingspeak update internval in seconds (Default: 120s, min: 15s)

SDA_PIN = 5 -- BH1750 sda pin, GPIO12
SCL_PIN = 6 -- BH1750 scl pin, GPIO14
DHTPIN = 7 --  DHT22 data pin, GPIO13


function startDatalogger()
    dofile("datalogger.lua")
end

tmr.alarm(0,6000,0, startDatalogger)
