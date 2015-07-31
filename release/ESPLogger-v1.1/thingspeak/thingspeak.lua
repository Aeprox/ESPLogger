-- ************************************************
-- Thingspeak module for ESP8266 with nodeMCU
-- tested 2015-07-20 with build 20150627
--
-- Written by Aeprox @ github
--
-- MIT license, http://opensource.org/licenses/MIT
-- *************************************************

local moduleName = "thingspeak"
local M = {
    DEBUG = true
}
_G[moduleName] = M

local writeKey = "" -- the channels API write key, eg. 8T9YUBFQEPSPZF5
local sent = false
local replied = false
local onFinished = nil
con = nil
local packet = "" -- string representing the http packet
local dataFields = {} -- contains the actual data to be sent in (key,value) pairs where key = "field1" etc like defined in your thingspeak channel settings

local function buildPacket()
    -- construct url-encoded string containing values to send to thingspeak
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
    table.insert(temp, "X-THINGSPEAKAPIKEY: "..writeKey.."\r\n")
    table.insert(temp, "Connection: close\r\n")
    table.insert(temp, "Content-Type: application/x-www-form-urlencoded\r\n")
    table.insert(temp, "Content-Length: "..length.."\r\n\r\n")
    table.insert(temp, fieldString)
    table.insert(temp, "\r\n\r\n")
   
    packet = table.concat(temp)
end

local function init(key,callback)
    writeKey = key
    -- register callback function to be called when done sending
    onFinished = callback
    
    -- initialise TCP connection and register event handlers
    con = net.createConnection(net.TCP, 0)
    con:on("receive", function(connection, payload)
        if M.DEBUG then
            print("Received reply:")
            print(payload)
        end
        if (payload ~= nil) then
            replied = true
        end
    end)
    con:on("reconnection", function(connection)
        if M.DEBUG then print("Reconnecting") end
    end)
    con:on("disconnection", function(connection)
        if not replied then
            if M.DEBUG then print("Didn't receive a reply.") end
            if onFinished ~= nil then onFinished(false) end
        else
            if M.DEBUG then print("Received a reply")end
            if onFinished ~= nil then onFinished(true) end
            -- todo, check reply for http status 200 and body not 0
        end
        con:close()
    end)
    con:on("connection", function(connection)
        if M.DEBUG then print("Sending data:") print(packet) end
        con:send(packet)   
    end)
end

local function update(newValues)
    sent, replied = false, false
    dataFields = newValues
    buildPacket() -- create updated data packet
    con:connect(80,'api.thingspeak.com')
end

function M.send(key,newValues,callback)
    init(key,callback)
    update(newValues)
end
return M
