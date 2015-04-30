DHT = require("dht_lib")
bh1750 = require("bh1750")


-- start wifi after 2s
tmr.alarm(1,2000,0,startWifi)
-- display wifi info after 6s
tmr.alarm(2,6000,0,printWifiInfo)
-- update thingspeak every 2 minutes
tmr.alarm(3, 120000, 1, updateThingSpeak)


-- Setup wifi connection & sensors
function startWifi()
    print("Starting wifi..")
    wifi.setmode(wifi.STATION)
    wifi.sta.config(SSID,password)
    bh1750.init(SDA_PIN, SCL_PIN)
end

-- Print wifi info (or reconnect)
function printWifiInfo()
    
    if wifi.sta.status() < 5 then
        print("Network connection lost, trying to reconnect to "..SSID.." in 5 seconds")
        tmr.alarm(1,5000,0,startWifi)
        tmr.alarm(2,9000,0,printWifiInfo)
    else
        print("Connected with ip "..wifi.sta.getip())
    end
end

-- read sensors and update thingspeak (or reconnect)
function updateThingSpeak()
    if wifi.sta.status() < 5 then
        print("Network connection lost, trying to reconnect")
        tmr.alarm(1,2000,0,startWifi)
        tmr.alarm(2,6000,0,printWifiInfo)
    else
        print("Updating thingspeak channel!")
        dofile("readsensors.lua")
        dofile("thingspeak.lc")
    end
end 


function comma_value(n) -- credit http://richard.warburton.it
    local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
    return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end

function round(x)
    local decimal = (x%1);
    if decimal>0.5 then
        return x-decimal+1
    else
        return x-decimal
    end 
end

