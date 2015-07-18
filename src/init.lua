print("Aeprox ESP8266 datalogger V1.1-dev (Compatible with NodeMCU 0.9.6 build 20150627) ")
tmr.delay(2000) -- never remove this during dev

-- variables
h,t,lx0,lx1,Vdd=0,0,0,0,0
dofile("usersettings.lua")

local function dologger()
    if wifi.sta.status() < 5 then
        print("Wifi connection failed.")
        tmr.alarm(1,3000,0,dologger)
    else
        dofile("readsensors.lc")
        dofile("thingspeakPOST.lc")
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
    
    tmr.alarm(0,3000,0,dologger)
end
initlogger()

function gotosleep()
    if(serialOut) then print("Taking a "..APIdelay.." second nap") end
    wifi.sta.disconnect()
    node.dsleep(APIdelay*1000000)
    --tmr.alarm(0,APIdelay*1000,0,donetwork)
end
