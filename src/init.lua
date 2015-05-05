print("Aeprox ESP8266 datalogger v0.3.1 (Compatible with NodeMCU 0.9.6 build 20150406) ")

-- **** User settings
SSID = ""
password = ""
APIkey = "" -- thingspeak API write key for channel
APIdelay = 120 -- thingspeak update internval in seconds (Default: 120s, min: 15s)

SDA_PIN = 5 -- BH1750 sda pin, GPIO12
SCL_PIN = 6 -- BH1750 scl pin, GPIO14
DHTPIN = 7 --  DHT22 data pin, GPIO13

-- correct values: "bh1750" or "tsl2561"
luxSensor = "tsl2561"

-- **** end of user settings

-- datalogger code startpoint
function startDatalogger()
    dofile("datalogger.lc")
end
tmr.alarm(0,2000,0, startDatalogger)

function goToSleep()
    print("Sleeping for "..APIdelay.."s")
    node.dsleep(APIdelay*1000000,1)
end
