hum = 0
temp = 0
lux = 0

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

