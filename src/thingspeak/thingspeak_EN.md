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
<a id="thingspeak_init"></a>
##init()
####Description
Setting the thingspeak API write key and callback.<br />

####Syntax
init(key, callback)

####Parameters
key: Thingspeak API write key.<br />
callback: This function is called after the data has been sent. It has a boolean as parameter, indicating wether or not a reply was received. <br />

####Returns
nil

####Example
```lua
key = "YOUR_API_KEY"

thingspeak = require("thingspeak")
thingspeak.init(key,onSendComplete)

function onSendComplete(success)
	-- release module
    thingspeak = nil
    package.loaded["thingspeak"]=nil
)

```

####See also
**-**   []()

<a id="thingspeak_update"></a>
##update()
####Description
Update Thingspeak channel.<br />

####Syntax
update(newValues)

####Parameters
A lua table containing (key, value) pairs. The keys MUST match the field configured in the Thingspeak channel's settings. Not all fields have to be updated every time. <br />
```lua
dataValues["field1"] = 123
dataValues["field7"] = 234
dataValues["field5"] = 7.65
```
Maximum of fields allowed by thingspeak API is 8.
####Returns
nil.<br />

####Example
```lua
key = "YOUR_API_KEY"
dataValues = {}

thingspeak = require("thingspeak")
thingspeak.init(key,onSendComplete)

-- fill table with values (max. 8 fields)
dataValues["field1"] = 123
dataValues["field7"] = 234
dataValues["field5"] = 7.65
dataValues["field4"] = 8000
dataValues["field2"] = 9.5453
-- send to thingspeak
thingspeak.update(dataValues)

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

