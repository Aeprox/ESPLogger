-- sends temp, hum and lux to thinkspeak channel
local sent = false
local con=net.createConnection(net.TCP, 0)
con:on("connection", function(conn)
    if(serialOut) then print("Sending data...") end

    conn:send("GET http://api.thingspeak.com/update?key="..APIkey.."&headers=false&field1="..(t/10).."&field2="..(h/10))
    if lxSensor == 0 then
        con:send("&field3="..(lx0).." HTTP/1.1\r\n")
    end
    if lxSensor == 1 then
        con:send("&field3="..(lx0).."&field4="..(lx1).." HTTP/1.1\r\n")
    end
    
    con:send("Host: api.thingspeak.com\r\n")
    con:send("Accept: text/plain\r\n")
    con:send("\r\n\r\n")
end)
con:on("receive", function(conn, payload)
   if(debug and serialOut) then print("payload:"..payload) end
    con:close()
end)
con:on("sent",function(conn)
    sent = true
end)
con:on("disconnection", function(conn)
    if sent == false then
        print("Failed to send data.")
    else
        if(serialOut) then
            print("Data sent successfully!")
        end
    end
    con = nil
    sent = nil
end)

con:connect(80,'api.thingspeak.com')
