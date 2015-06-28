-- sends temp, hum and lux to thinkspeak channel
local sent = false
local con=net.createConnection(net.TCP, 0)
con:on("connection", function(con)
    if(serialOut) then 
        print("Connection succeeded\r\nSending data...")
    end
    local temp = {}  -- table to hold strings
    table.insert(temp,"headers=false&field1="..(t).."&field2="..(h))
    if lxSensor == 1 then
        table.insert(temp,"&field3="..(lx0))
    elseif lxSensor == 2 then
        table.insert(temp,"&field3="..(lx0).."&field4="..(lx1))
    end
    if readV then
        table.insert(temp,"&field5="..(Vdd))
    end
    local fields = table.concat(temp)
    length = string.len(fields)

    local temp = {}
    table.insert(temp, "POST /update HTTP/1.1\r\n")
    table.insert(temp, "Host: api.thingspeak.com\r\n")
    table.insert(temp, "X-THINGSPEAKAPIKEY: "..APIkey.."\r\n")
    table.insert(temp, "Content-Type: application/x-www-form-urlencoded\r\n")
    table.insert(temp, "Content-Length: "..length.."\r\n\r\n")
    table.insert(temp, fields)
    table.insert(temp, "\r\n\r\n")
    local post = table.concat(temp)
    if(debug and serialOut) then print(post) end
    con:send(post)
end)
con:on("receive", function(con, payload)
    if(debug and serialOut) then print("payload:") print(payload) end
    con:close()
    sent = true
end)
con:on("disconnection", function(con)
    if serialOut then
        if sent then
            print("Data sent")
        else 
            print("Failed to send data.")
        end
    end
    gotosleep()
end)
con:connect(80,'api.thingspeak.com')
