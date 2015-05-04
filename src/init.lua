print("Aeprox ESP8266 datalogger v0.3.1 (Compatible with NodeMCU 0.9.6 build 20150406) ")


-- user settings
SSID = ""
password = ""
APIkey = "" -- thingspeak API write key for channel
APIdelay = 120 -- thingspeak update internval in seconds (Default: 120s, min: 15s)

SDA_PIN = 5 -- BH1750 sda pin, GPIO12
SCL_PIN = 6 -- BH1750 scl pin, GPIO14
DHTPIN = 7 --  DHT22 data pin, GPIO13

-- datalogger code startpoint
function startDatalogger()
    dofile("datalogger.lua")
end
tmr.alarm(0,2000,0, startDatalogger)


-- utility functions
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

function goToSleep()
    print("Sleeping for "..APIdelay.."s")
    node.dsleep(APIdelay*1000000,1)
end