-- datalogger code startpoint
dofile("usersettings.lua")
print("Aeprox ESP8266 datalogger v0.5 (Compatible with NodeMCU 0.9.6 build 20150406) ")
function startDatalogger()
    if wifi.sta.status() < 5 then
	    print("Wifi connection failed. Reconnecting..")
	    wifi.setmode(wifi.STATION)
        wifi.sleeptype(wifi.NONE_SLEEP)
	    wifi.sta.config(SSID,password)
        tmr.alarm(1,5000,0,startDatalogger)
	else
        if(outputToSerial) then
        	print("Connected with ip "..wifi.sta.getip())
        	dofile("readsensors.lc")
        	dofile("thingspeak.lc")
        end
    end
end
tmr.alarm(0,APIdelay*1000,1,startDatalogger)

-- utility functions
function goToSleep()
    print("Sleeping for "..APIdelay.."s")
    node.dsleep(APIdelay*1000000,1)
end
