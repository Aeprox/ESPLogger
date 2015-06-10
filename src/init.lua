-- datalogger code startpoint
dofile("usersettings.lua")
print("Aeprox ESP8266 datalogger v0.6 (Compatible with NodeMCU 0.9.6 build 20150406) ")
function startlogger()
    if wifi.sta.status() < 5 then
	    print("Wifi connection failed. Reconnecting..")
	    wifi.setmode(wifi.STATION)
	    wifi.sta.config(SSID,password)
        tmr.alarm(2,5000,0,startlogger)
	else
        if(serialOutput) then
        	print("Connected with ip "..wifi.sta.getip())
        end
        dofile("readsensors.lc")
        dofile("thingspeakPOST.lc")
    end
end
function send()
    dofile("thingspeak.lc")
end

tmr.alarm(0,APIdelay*1000,1,startlogger)

-- activate power savings
function pwrDown() 
    print("'Sleeping' for "..APIdelay.."s")
    --node.dsleep(APIdelay*1000000,1)
end
