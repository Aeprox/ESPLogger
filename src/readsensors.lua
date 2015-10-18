-- read lux sensor
if lxSensor == 1 then
    local bh1750 = require("bh1750")
    bh1750.init(SDA_PIN, SCL_PIN)
    bh1750.read()bh1750.read() 
    lx0 = bh1750.getlux()
    bh1750 = nil
    package.loaded["bh1750"]=nil
elseif lxSensor == 2 then
    tsl2561.init(SDA_PIN, SCL_PIN)
    tsl2561.settiming(lxIntTime,lxGain)
    lx0,lx1 = tsl2561.getrawchannels()
    lux = tsl2561.getlux()
    tsl = nil
    package.loaded["tsl"]=nil
end

-- read data from temp/hum sensor
status,t,h = dht.readxx(DHTPIN)

-- output to serial
if(serialOut) then
    print("Temp.: "..(t).."degC")
    print("Humidity: "..(h).."%")
    if lxSensor == 1 then    
        print("Illuminance: ".. lx0)
    elseif lxSensor == 2 then
        print(string.format("Illuminance: %i lx(ch0: %i, ch1: %i)",lux,lx0,lx1))
    end
    if Vdd ~= nil then print("Vdd: "..Vdd) end
end

--output to thingspeak
sensorValues["field1"] = t
sensorValues["field2"] = h
if lxSensor == 1 then
    sensorValues["field3"] = lx0
elseif lxSensor == 2 then
    sensorValues["field3"] = lx0
    sensorValues["field4"] = lx1
    sensorValues["field5"] = lux
end
if Vdd ~= nil then sensorValues["field6"] = Vdd end
