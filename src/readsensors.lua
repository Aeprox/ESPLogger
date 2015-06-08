-- variables
hum = 0
temp = 0
lux0 = 0
lux1 = 0

-- read lux sensor
if luxSensor == "bh1750" then
    local bh1750 = require("bh1750")
    bh1750.init(SDA_PIN, SCL_PIN)
    bh1750.read()
    bh1750.read() 
    lux0 = round(bh1750.getlux())
    bh1750 = nil
    package.loaded["bh1750"]=nil
end
if luxSensor == "tsl2561" then
    local tsl = require("tsl2561lib")
    lux0, lux1 = tsl.getchannels()
    tsl = nil
    package.loaded["tsl"]=nil
end

-- read data from temp/hum sensor
local DHT = require("dht_lib")
DHT.read(DHTPIN)
temp = DHT.getTemperature()
hum = DHT.getHumidity()
DHT = nil
package.loaded["dht_lib"]=nil

-- output to serial
if(outputToSerial) then
    print("Temperature: "..(temp / 10).." deg C")
    if hum == nil then
            print("Error reading from DHT11/22")
    else
        print("Humidity: "..(hum / 10).."%")
    end
    print("Illuminance::: ch0:".. ch0 ..", ch1:"..ch1.." lx")
end
