-- read lux sensor
if lxSensor == 1 then
    local bh1750 = require("bh1750")
    bh1750.init(SDA_PIN, SCL_PIN)
    bh1750.read()bh1750.read() 
    lx0 = bh1750.getlux()
    bh1750 = nil
    package.loaded["bh1750"]=nil
elseif lxSensor == 2 then
    local tsl = require("tsl2561lib")
    lx0,lx1 = tsl.getchannels()
    tsl = nil
    package.loaded["tsl"]=nil
end

-- read data from temp/hum sensor
status,t,h = dht.readxx(DHTPIN)

-- output to serial
if(serialOut) then
    print("Temp.: "..(t).."°C")
    print("Humidity: "..(h).."%")
    print("Illuminance: ch0: ".. lx0 ..", ch1: "..lx1)
    print("Vdd: "..Vdd)
end
