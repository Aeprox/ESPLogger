-- **** User settings
serialOutput = true

SSID = ""
password = ""

APIkey = "" -- thingspeak API write key for channel
APIdelay = 120 -- thingspeak update internval in seconds (min: 15s)

DHTPIN = 7 --  DHT22 data pin, GPIO13

-- Light sensor, 2 types supported:
--  0 : BH1750
--  1 : TSL2561
luxSensor = 1 
SDA_PIN = 5 -- lux sda pin, GPIO12
SCL_PIN = 6 -- lux scl pin, GPIO14
-- **** end of user settings
