DHT = require("dht_lib")
bh1750 = require("bh1750")

hum = 0
temp = 0
lux = 0

-- init sensors
bh1750.init(SDA_PIN, SCL_PIN)


-- read data from temp/hum sensor
DHT.read(DHTPIN)
temp = DHT.getTemperature()
hum = DHT.getHumidity()

-- read lux sensor
bh1750.read()
bh1750.read() 
lux = round(bh1750.getlux())

-- output to user
print("Temperature: "..comma_value(temp / 10).." deg C")
if hum == nil then
        print("Error reading from DHT11/22")
else
    
    print("Humidity: "..comma_value(hum / 10).."%")
end
print("Illuminance: "..(lux).." lx")

-- unload sensor modules
bh1750 = nil
package.loaded["bh1750"]=nil

DHT = nil
package.loaded["dht_lib"]=nil