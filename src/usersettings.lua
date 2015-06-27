-- Wifi settings
SSID = "" 
password = ""

-- Thingspeak settings
APIkey = "" -- thingspeak API write key for channel
APIdelay = 30 -- thingspeak update internval in seconds (min: 15s)

-- Sensor settings
    DHTPIN = 7 --  DHT22 data pin, GPIO13
    
    SDA_PIN = 5 -- lux sda pin, GPIO12
    SCL_PIN = 6 -- lux scl pin, GPIO14
    
    -- Light sensor, 2 types supported:
    --  0   : no lux sensor
    --  1   : BH1750
    --  2   : TSL2561
    lxSensor = 0
    
    -- TSL2561 integration time settings
    --TSL2561_INTEGRATIONTIME_13MS  = 0x00
    --TSL2561_INTEGRATIONTIME_101MS = 0x01
    --TSL2561_INTEGRATIONTIME_402MS = 0x02
    --  0   :   13.7ms
    --  1   :   101ms
    --  2   :   402ms
    lxIntTime = 2
    
    -- TSL2561 gain setting
    --TSL2561_GAIN_1X               = 0x00,   -- No gain
    --TSL2561_GAIN_16X              = 0x10,   -- 16x gain
    --  0   :   no gain (1x)
    --  16   :   16x
    lxGain = 0

    -- Read Vdd or not
    readV = true

serialOut = true
