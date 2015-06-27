-- sends temp, hum and lux to thinkspeak channel
local sent = false
local con=net.createConnection(net.TCP, 0)
con:on("connection", function(con)
    if(serialOut) then 
        print("Connection succeeded")
        print("Sending data...")
    end
    
    con:send("POST /update HTTP/1.1\r\nHost: api.thingspeak.com\r\n")
    con:send("X-THINGSPEAKAPIKEY: "..APIkey.."\r\n")
    con:send("Content-Type: application/x-www-form-urlencoded\r\n")
    fields = "headers=false&field1="..(t).."&field2="..(h)
    if lxSensor == 0 or lxSensor == 1 then
        fields = fields.."&field3="..(lx0)
    elseif lxSensor == 2 then
        fields = fields.."&field3="..(lx0).."&field4="..(lx1)
    end
    if readV then
        fields = fields.."&field5="..(Vdd)
    end
    length = string.len(fields)
    con:send("Content-Length: "..length.."\r\n\r\n")
    con:send(fields.."\r\n\r\n")
end)
con:on("receive", function(con, payload)
    if(debug and serialOut) then print("payload:"..payload) end
    con:close()
    sent = true
end)
con:on("disconnection", function(con)
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
