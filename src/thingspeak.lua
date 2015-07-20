-- ***************************************************************************
-- Thingspeak module for ESP8266 with nodeMCU
-- tested 2015-07-20 with build 20150627
--
-- Written by Aeprox @ github
--
-- MIT license, http://opensource.org/licenses/MIT
-- ***************************************************************************

local moduleName = "thingspeak"
local M = {}
_G[moduleName] = M

local APIkey -- the channels API write key, eg. 8T9YUBFQEPSPZF5
local initialised = false
local sent = false
local replied = false
local onFinished
local con
local packet -- string representing the http packet
local dataFields = {} -- contains the actual data to be sent in (key,value) pairs where key = "field1" etc like defined in your thingspeak channel settings

local function buildPacket()
    -- construct url-encoded string containing sensor values
    local temp = {}  
    table.insert(temp,"headers=false") -- reduce number of headers in reply 
    for i, v in pairs(dataFields) do
        table.insert(temp, "&"..i.."="..v)
    end
    
    local fieldString = table.concat(temp)
    local length = string.len(fieldString)

    -- construct http header and body
    temp = {}
    table.insert(temp, "POST /update HTTP/1.1\r\n")
    table.insert(temp, "Host: api.thingspeak.com\r\n")
    table.insert(temp, "X-THINGSPEAKAPIKEY: "..APIkey.."\r\n")
    table.insert(temp, "Connection: close\r\n")
    table.insert(temp, "Content-Type: application/x-www-form-urlencoded\r\n")
    table.insert(temp, "Content-Length: "..length.."\r\n\r\n")
    table.insert(temp, fieldString)
    table.insert(temp, "\r\n\r\n")
   
    packet = table.concat(temp)
end

function M.init(key,callback)
    APIkey = key
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
            replied = true
            con:close()
        end
    end)
    con:on("reconnection", function(connection)
        if serialOut then print("Reconnecting") end
    end)
    con:on("disconnection", function(connection)
        if not replied then
            if debug then print("Didn't receive a reply.") end
            if onFinished ~= nil then onFinished(false) end
        else
            if debug then print("Received a reply")end
            if onFinished ~= nil then onFinished(true) end
            -- todo, check reply for hhtp status 200 and body not 0
        end
        con:close()
    end)
    con:on("connection", function(connection)
        if(debug and serialOut) then print("Sending data:") print(packet) end
        connection:send(packet, function(connection)
            if serialOut then print("Sent data") sent = true end
        end)   
    end)

    initialised = true
end

function M.update(newValues)
    if not initialised then
        error("You must call init() before calling update()")
    else
        dataFields = newValues
        buildPacket() -- create updated data packet
        con:connect(80,'api.thingspeak.com')
    end
end
return M
