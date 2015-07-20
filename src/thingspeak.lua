
-- sends temp, hum and lux to thinkspeak channel
local moduleName = "thingspeak"
local M = {}
_G[moduleName] = M

local initialised = false
local sent = false
local receivedReply = false
local con
local packet
local onFinished
local sensorValues = {}

local function buildPacket()
    -- construct url-encoded string containing sensor values
    local temp = {}  
    table.insert(temp,"headers=false") -- reduce number of headers in reply 
    for i, v in pairs(sensorValues) do
        table.insert(temp, "&"..i.."="..v)
    end
    
    local fields = table.concat(temp)
    local length = string.len(fields)

    -- construct http header and body
    temp = {}
    table.insert(temp, "POST /update HTTP/1.1\r\n")
    table.insert(temp, "Host: api.thingspeak.com\r\n")
    table.insert(temp, "X-THINGSPEAKAPIKEY: "..APIkey.."\r\n")
    table.insert(temp, "Connection: close\r\n")
    table.insert(temp, "Content-Type: application/x-www-form-urlencoded\r\n")
    table.insert(temp, "Content-Length: "..length.."\r\n\r\n")
    table.insert(temp, fields)
    table.insert(temp, "\r\n\r\n")
   
    packet = table.concat(temp)
end

function M.init(callback)
    -- register callback function to be called when done sending
    onFinished = callback
    
    -- initialise TCP connection and register event handlers
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
        if serialOut then print("Reconnecting") end
    end)
    con:on("disconnection", function(connection)
        if (serialOut and (not receivedReply)) then
                print("Didn't receive a reply.")
        end
        onFinished()
    end)
    con:on("connection", function(connection)
        if serialOut then 
            print("Connection succeeded")
        end
        
        if(debug and serialOut) then print("Sending data:") print(packet) end
        connection:send(packet, function(connection)
            if serialOut then print("Sent data") sent = true end
        end)   
    end)

    initialised = true
end

function M.update(newValues)
    if not initialised then
        error("You must call init() before updating")
    else
        sensorValues = newValues
        -- create updated data packet
        buildPacket()
        con:connect(80,'api.thingspeak.com')
    end
end
return M
