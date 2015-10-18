# Thingspeak Module

##Require
```lua
thingspeak = require("thingspeak")
```
## Release
```lua
thingspeak = nil
package.loaded["thingspeak"]=nil
```

<a id="thingspeak_send"></a>
##send()
####Description
Update Thingspeak channel.<br />

####Syntax
send(key,newValues,onSendComplete)

####Parameters
* key: Thingspeak API write key.<br />
* newValues: A lua table containing (key, value) pairs. The keys MUST match the field configured in the Thingspeak channel's settings. Not all fields have to be updated every time. <br />

Valid parameters:
    * field1 (string) - Field 1 data (optional)
    * field2 (string) - Field 2 data (optional)
    * field3 (string) - Field 3 data (optional)
    * field4 (string) - Field 4 data (optional)
    * field5 (string) - Field 5 data (optional)
    * field6 (string) - Field 6 data (optional)
    * field7 (string) - Field 7 data (optional)
    * field8 (string) - Field 8 data (optional)
    * lat (decimal) - Latitude in degrees (optional)
    * long (decimal) - Longitude in degrees (optional)
    * elevation (integer) - Elevation in meters (optional)
    * status (string) - Status update message (optional)
    * twitter (string) - Twitter username linked to ThingTweet (optional)
    * tweet (string) - Twitter status update; see updating ThingTweet for more info (optional)
    * created_at (datetime) - Date when this feed entry was created, in ISO 8601 format, for example: 2014-12-31 23:59:59 . Time zones can be specified via the timezone parameter (optional)
<br />

* callback: This function is called after the data has been sent. It has 2 parameters: a  boolean indicating wether or not a reply was received, and a string containing the http status code received. <br />


####Returns
nil.<br />

####Example
```lua
key = "YOUR_API_KEY"
dataValues = {}

thingspeak = require("thingspeak")

-- fill table with values
dataValues["field1"] = 123
dataValues["field7"] = 234
dataValues["field5"] = 7.65
dataValues["field4"] = 8000
dataValues["field2"] = 9.5453
dataValues["status"] = "success!"
-- send to thingspeak
thingspeak.update(key, dataValues,onSendComplete)

function onSendComplete(success,status) 
    if success then 
        print("Done sending data. Reply status:"..status)
    else
        print("Couldn't send data")
    end

    -- release module
    thingspeak = nil
    package.loaded["thingspeak"]=nil
end
```
