-- User settings
SSID = "" 
password = ""
APIkey = "" -- thingspeak API write key for channel
APIdelay = 120 -- thingspeak update internval in seconds (min: 15s)
DHTPIN = 7 --  DHT22 data pin, GPIO13
SDA_PIN = 5 -- lux sda pin, GPIO12
SCL_PIN = 6 -- lux scl pin, GPIO14
-- Light sensor, 2 types supported:
--  0 : BH1750
--  1 : TSL2561
lxSensor = 1
-- TSL2561 integration time settings
--  0   :   13.7ms
--  1   :   101ms
--  2   :   402ms
lxIntTime = 1

serialOut = true
