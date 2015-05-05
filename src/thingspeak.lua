-- sends temp, hum and lux to thinkspeak channel
local sent = false
local conn=net.createConnection(net.TCP, 0)

print("Connection created")
conn:connect(80,'api.thingspeak.com')
print("Opening connection...")

conn:on("connection", function(conn)
    print("Connection succeeded")
    print("Sending data...")
    conn:send("GET http://api.thingspeak.com/update?key="..APIkey.."&field1="..(temp/10).."&field2="..(hum/10).."&field3="..(lux).." HTTP/1.1\r\n")
    conn:send("Host: api.thingspeak.com\r\n") 
    conn:send("Accept: */*\r\n") 
    conn:send("\r\n")
end)
conn:on("receive", function(conn, payload)
    print("Closing connection...")
    conn:close()
end)
conn:on("sent",function(conn)
    print("Data sent")
    sent = true
end)
conn:on("disconnection", function(conn)
    print("Disconnected")
    if sent == false then
        print("Failed to send data.");
    end
    goToSleep()    
end)
