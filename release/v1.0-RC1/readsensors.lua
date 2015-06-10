-- read lux sensor
if lxSensor == 0 then
    local bh1750 = require("bh1750")
    bh1750.init(SDA_PIN, SCL_PIN)
    bh1750.read()bh1750.read() 
    lx0 = bh1750.getlux()
    bh1750 = nil
    package.loaded["bh1750"]=nil
end
if lxSensor == 1 then
    local tsl = require("tsl2561lib")
    lx0,lx1 = tsl.getchannels()
    tsl = nil
    package.loaded["tsl"]=nil
end

-- read data from temp/hum sensor
local DHT = require("dht_lib")
DHT.read(DHTPIN)
t = DHT.getTemperature()
h = DHT.getHumidity()
DHT = nil
package.loaded["dht_lib"]=nil

-- output to serial
if(serialOut) then
    print("Temp.: "..(t / 10).."°C")
    print("Humidity: "..(h / 10).."%")
    print("Illuminance: ch0: ".. lx0 ..", ch1: "..lx1)
end
