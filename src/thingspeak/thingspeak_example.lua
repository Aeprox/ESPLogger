-- ***************************************************************************
-- Thingspeak example for ESP8266 with nodeMCU
-- tested 2015-07-20 with build 20150627
--
-- Written by Aeprox @ github
--
-- MIT license, http://opensource.org/licenses/MIT
-- ***************************************************************************
print("Aeprox ESP8266 thingspeak module v0.1 (Compatible with NodeMCU 0.9.6 build 20150627) ")
wkey = "8T9YLMBFQEPSPZ1S"
dataValues = {} 
wifi.sta.connect()
dofile("usersettings.lua")

function onSendComplete(success) 
    if success then 
        print("Done sending data")
    else
        print("Couldn't send data")
    end

    -- unload module
    thingspeak = nil
    package.loaded["thingspeak"]=nil
end

thingspeak = require("thingspeak")
thingspeak.init(wkey,onSendComplete)

-- fill table with values (max. 8 fields)
dataValues["field1"] = 123
dataValues["field5"] = 7.65
dataValues["field4"] = 8000
dataValues["field2"] = 9.5453
-- send to thingspeak
thingspeak.update(dataValues)
