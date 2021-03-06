print("Aeprox ESP8266 datalogger V1.0-RC1 (Compatible with NodeMCU 0.9.6 build 20150406) ")

-- variables
h,t,lx0,lx1 = 0
dofile("usersettings.lua")

function dologger()
    if wifi.sta.status() < 5 then
	    print("Wifi connection failed. Reconnecting..")
	    wifi.setmode(wifi.STATION)
	    wifi.sta.config(SSID,password)
	else
        if(serialOut) then
        	print("Connected with ip "..wifi.sta.getip())
        end
        dofile("readsensors.lc")
        dofile("thingspeakPOST.lc")
    end
end

local function initlogger()
    local k,v,l 
    for k,v in pairs(file.list()) do
        -- nothing at all. This solves the memory issues with the thingspeak module somehow? MAGIC! 
    end
    k=nil v=nil l=nil
    tmr.alarm(0,APIdelay*1000,1,dologger)
end
initlogger()
