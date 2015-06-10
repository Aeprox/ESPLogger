print("Aeprox ESP8266 datalogger v0.6 (Compatible with NodeMCU 0.9.6 build 20150406) ")

-- variables
h,t,lx0,lx1 = 0
dofile("usersettings.lua")

function initlogger()
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

local function startupmagic()
    r,u,t=file.fsinfo() print("Total : "..t.." bytes\r\nUsed  : "..u.." bytes\r\nRemain: "..r.." bytes\r\n") r=nil u=nil t=nil
    _dir=function() local k,v,l print("~~~File ".."list START~~~") for k,v in pairs(file.list()) do l = string.format("%-15s",k) print(l.." : "..v.." bytes") end print("~~~File ".."list END~~~") end _dir() _dir=nil
end
startupmagic()
tmr.alarm(0,APIdelay*1000,1,initlogger)
