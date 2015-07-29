print("Aeprox ESP8266 datalogger V1.1-dev (Compatible with NodeMCU 0.9.6 build 20150627) ")

-- variables
sensorValues = {} 
dofile("usersettings.lua")
local thingspeak = require("thingspeak")

local function dologger()
    if wifi.sta.status() < 5 then
        print("Wifi connection failed.")
        tmr.alarm(2,3000,0,dologger)
    else
        dofile("readsensors.lc")
        thingspeak.send(APIkey, sensorValues, gotosleep)
    end
end

local function initlogger()
    -- always make sure we're in station mode
    if(wifi.getmode() ~= wifi.STATION) then wifi.setmode(wifi.STATION) end
    
    -- check if current config != config in usersettings
    conf_ssid, conf_password = wifi.sta.getconfig()
    if((conf_ssid~=SSID) or (conf_password~=password)) then
        wifi.sta.config(SSID,password,0)
    end
    
    --  read Vdd before wifi starts
    if readV then
        Vdd = adc.readvdd33()
    end
    -- enable wifi 
    wifi.sta.connect()
    
    tmr.alarm(1,3000,0,dologger)
end

tmr.alarm(0,2000,0,initlogger) -- never remove this during dev

function gotosleep()
    if(serialOut and sleepEnabled) then print("Taking a "..APIdelay.." second nap") end
    if(serialOut and not sleepEnabled) then print("Waiting "..APIdelay.." second before updating") end
    wifi.sta.disconnect()
    if sleepEnabled then
        node.dsleep(APIdelay*1000000)
    else
        tmr.alarm(0,APIdelay*1000,0,initlogger)
    end
end
