
-- sends temp, hum and lux to thinkspeak channel
local moduleName = "thingspeak"
local M = {}
_G[moduleName] = M

local sent = false
local receivedReply = false
local con

function M.init()
    con = net.createConnection(net.TCP, 0)
    con:on("receive", function(connection, payload)
        if (debug and serialOut) then
            print("Received reply:")
            print(payload)
        end
        if (payload ~= nil) then
            receivedReply = true
            con:close()
        end
    end)
    con:on("reconnection", function(connection)
        if (debug and serialOut) then print("Reconnecting") end
    end)
    con:on("disconnection", function(connection)
        
        if (serialOut and (not receivedReply)) then
                print("Didn't receive a reply")
        end
        con = nil
        gotosleep()
    end)
    con:on("connection", function(connection)
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
        local length = string.len(fields)
        
        local temp = {}
        table.insert(temp, "POST /update HTTP/1.1\r\n")
        table.insert(temp, "Host: api.thingspeak.com\r\n")
        table.insert(temp, "X-THINGSPEAKAPIKEY: "..APIkey.."\r\n")
        --table.insert(temp, "Connection: close\r\n")
        table.insert(temp, "Content-Type: application/x-www-form-urlencoded\r\n")
        table.insert(temp, "Content-Length: "..length.."\r\n\r\n")
        table.insert(temp, fields)
        table.insert(temp, "\r\n\r\n")
        local post = table.concat(temp)
        if(debug and serialOut) then print("Post:") print(post) end
        connection:send(post, function(connection)
            if (debug and serialOut) then print("Sent data") sent = true end
        end)   
    end)
end

function M.update()
    con:connect(80,'api.thingspeak.com')
end
return M
