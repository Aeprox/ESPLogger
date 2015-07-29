# thingspeak Module

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
*key: Thingspeak API write key.<br />
*newValues: A lua table containing (key, value) pairs. The keys MUST match the field configured in the Thingspeak channel's settings. Not all fields have to be updated every time. <br />
```lua
dataValues["field1"] = 123
dataValues["field7"] = 234
dataValues["field5"] = 7.65
```
Maximum of fields allowed by thingspeak API is 8.<br />
*callback: This function is called after the data has been sent. It has a boolean as parameter, indicating wether or not a reply was received. <br />


####Returns
nil.<br />

####Example
```lua
key = "YOUR_API_KEY"
dataValues = {}

thingspeak = require("thingspeak")

-- fill table with values (max. 8 fields)
dataValues["field1"] = 123
dataValues["field7"] = 234
dataValues["field5"] = 7.65
dataValues["field4"] = 8000
dataValues["field2"] = 9.5453
-- send to thingspeak
thingspeak.update(key, dataValues,onSendComplete)

function onSendComplete(success) 
    if success then 
        print("Done sending data")
    else
        print("Couldn't send data")
    end

    -- release module
    thingspeak = nil
    package.loaded["thingspeak"]=nil
end
```

####See also
**-**   []()

