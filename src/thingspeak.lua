-- sends temp, hum and lux to thinkspeak channel
local sent = false
local conn=net.createConnection(net.TCP, 0)
conn:on("connection", function(conn)
    if(serialOutput) then 
        print("Connection succeeded")
        print("Sending data...")
    end

    conn:send("GET http://api.thingspeak.com/update?key="..APIkey.."&field1="..(temp/10).."&field2="..(hum/10))
    if luxSensor == 0 then
        conn:send("&field3="..(lux0).." HTTP/1.1\r\n")
    end
    if luxSensor == 1 then
        conn:send("&field3="..(lux0).."&field4="..(lux1).." HTTP/1.1\r\n")
    end
    
    conn:send("Host: api.thingspeak.com\r\n")
    conn:send("Accept: */*\r\n")
    --conn:send("User-Agent: Mozilla/4.0 (compatible; esp8266 Lua;)\r\n")
    conn:send("\r\n")
end)
conn:on("receive", function(conn, payload)
    conn:close()
end)
conn:on("sent",function(conn)
    if(serialOutput) then print("Data sent successfulfy!") end
    sent = true
end)
conn:on("disconnection", function(conn)
    if sent == false then
        if(serialOutput) then print("Failed to send data.") end
    end
    conn = nil
    sent = nil
    pwrDown()
end)

conn:connect(80,'api.thingspeak.com')
