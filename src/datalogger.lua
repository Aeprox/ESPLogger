if wifi.sta.status() < 5 then
    print("Wifi connection failed ("..retries..")")
    wifi.setmode(wifi.STATION)
    wifi.sta.config(SSID,password)
end
print("Connected with ip "..wifi.sta.getip())
dofile("readsensors.lc")
dofile("thingspeak.lc")


