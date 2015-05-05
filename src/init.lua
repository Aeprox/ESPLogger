-- **** User settings
SSID = ""
password = ""

APIkey = "" -- thingspeak API write key for channel
APIdelay = 120 -- thingspeak update internval in seconds (min: 15s)

DHTPIN = 7 --  DHT22 data pin, GPIO13

luxSensor = "tsl2561" -- correct values: "bh1750" or "tsl2561"
SDA_PIN = 5 -- lux sda pin, GPIO12
SCL_PIN = 6 -- lux scl pin, GPIO14
-- **** end of user settings


-- datalogger code startpoint
print("Aeprox ESP8266 datalogger v0.4.0 (Compatible with NodeMCU 0.9.6 build 20150406) ")
function startDatalogger()
    if wifi.sta.status() < 5 then
	    print("Wifi connection failed. Reconnecting..")
	    wifi.setmode(wifi.STATION)
	    wifi.sta.config(SSID,password)
	end
	print("Connected with ip "..wifi.sta.getip())
	dofile("readsensors.lc")
	dofile("thingspeak.lc")
end
tmr.alarm(0,2000,0, startDatalogger)

function goToSleep()
    print("Sleeping for "..APIdelay.."s")
    node.dsleep(APIdelay*1000000,1)
end
