-- sends temp, hum and lux to thinkspeak channel
local sent = false
local conn=net.createConnection(net.TCP, 0)

if(outputToSerial) then print("Connection created") end
conn:connect(80,'api.thingspeak.com')
if(outputToSerial) then print("Opening connection...") end

conn:on("connection", function(conn)
    if(outputToSerial) then 
        print("Connection succeeded")
        print("Sending data...")
    end
    if luxSensor == "bh1750" then
        conn:send("GET http://api.thingspeak.com/update?key="..APIkey.."&field1="..(temp/10).."&field2="..(hum/10).."&field3="..(lux0).." HTTP/1.1\r\n")
    end
    if luxSensor == "tsl2561" then
        conn:send("GET http://api.thingspeak.com/update?key="..APIkey.."&field1="..(temp/10).."&field2="..(hum/10).."&field3="..(lux0).."&field4="..(lux1).." HTTP/1.1\r\n")
    end
    conn:send("Host: api.thingspeak.com\r\n") 
    conn:send("Accept: */*\r\n") 
    conn:send("\r\n")
end)
conn:on("receive", function(conn, payload)
    if(outputToSerial) then print("Closing connection...") end
    conn:close()
end)
conn:on("sent",function(conn)
    if(outputToSerial) then print("Data sent") end
    sent = true
end)
conn:on("disconnection", function(conn)
    if(outputToSerial) then 
        print("Disconnected") 
        if sent == false then
            print("Failed to send data.");
        end
    end
    goToSleep()    
end)
