local retries = 0

-- Setup wifi connection & sensors
function startWifi()
    print("Starting wifi..")
    wifi.setmode(wifi.STATION)
    wifi.sta.config(SSID,password)

    tmr.alarm(2,4000,0,checkConnection)
end

-- Print wifi info (or reconnect)
function checkConnection()
    if wifi.sta.status() < 5 then
        print("Connection failed, reconnecting in 5s")
        tmr.alarm(1,5000,0,startWifi)
    else
        print("Connected with ip "..wifi.sta.getip())
        updateThingSpeak()
    end
end

-- read sensors and update thingspeak (or reconnect)
function updateThingSpeak()
    if wifi.sta.status() < 5 then
        retries = retries + 1
        if (retries < 5) then
            print("Network connection lost, trying to reconnect. (Attempt "..retries..")")
            tmr.alarm(1,5000,0,startWifi)
        else
            print("Failed to connect to wifi")
            goToSleep()
        end
    else
        print("Reading sensors")
        dofile("readsensors.lc")
        print("Updating thingspeak channel")
        dofile("thingspeak.lc")
    end
end

-- start wifi with a 1s delay to let things settle after boot
tmr.alarm(1,1000,0,startWifi)



