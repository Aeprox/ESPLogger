-- Library for working with TSL2561 I2C Luminosity sensor
-- As used on breakout board by Adafruit
-- Special hat-tip to lady ada - hacker hero - amongst many others
-- This code is AGPL v3 by gareth@l0l.org.uk and Hamish Cunningham
-- blah blah blah standard licence conditions apply blah blah blah
-- Adapted by Aeprox@github for use in ESPlogger

local i2cutils = require("i2cutils") -- get our helper functions loaded

local moduleName = "tsl2561lib"
-- the package table, and lots of constants
local M = {
    TSL2561_ADDR_FLOAT            = 0x39,
    TSL2561_COMMAND_BIT           = 0x80,   -- Must be 1
    TSL2561_CONTROL_POWERON       = 0x03,
    TSL2561_CONTROL_POWEROFF      = 0x00,
    TSL2561_REGISTER_CONTROL      = 0x00,
    TSL2561_REGISTER_TIMING       = 0x01,
    TSL2561_REGISTER_ID           = 0x0A,
    TSL2561_REGISTER_CHAN0_LOW    = 0x0C,
    TSL2561_REGISTER_CHAN0_HIGH   = 0x0D,
    TSL2561_REGISTER_CHAN1_LOW    = 0x0E,
    TSL2561_REGISTER_CHAN1_HIGH   = 0x0F,
    
    TSL2561_INTEGRATIONTIME_13MS  = 0x00,   -- 13.7ms
    TSL2561_INTEGRATIONTIME_101MS = 0x01,   -- 101ms
    TSL2561_INTEGRATIONTIME_402MS = 0x02,   -- 402ms
    
    TSL2561_GAIN_0X               = 0x00,   -- No gain
    TSL2561_GAIN_16X              = 0x10,   -- 16x gain
    
    TSL2561_LUX_CHSCALE           = 10,     -- Scale channel values by 2^10
    TSL2561_LUX_CHSCALE_TINT0     = 0x7517, -- 322/11 * 2^TSL2561_LUX_CHSCALE
    TSL2561_LUX_LUXSCALE          = 14,     -- Scale by 2^14
    TSL2561_LUX_RATIOSCALE        = 9,      -- Scale ratio by 2^9
    
}
_G[moduleName] = M

local busid = 0 -- i2c bus id

-- add a few recursive definitions
local function enable(dev_addr) -- enable the device
  i2cutils.write_reg(
    dev_addr,
    bit.bor(M.TSL2561_COMMAND_BIT, M.TSL2561_REGISTER_CONTROL),
    M.TSL2561_CONTROL_POWERON
  )
end

local function disable(dev_addr) -- disable the device
  i2cutils.write_reg(
    dev_addr,
    bit.bor(M.TSL2561_COMMAND_BIT, M.TSL2561_REGISTER_CONTROL),
    M.TSL2561_CONTROL_POWEROFF
  )
end

local function settimegain(dev_addr, time, gain) -- set the integration time and gain together
  i2cutils.write_reg(
    dev_addr,
    bit.bor(M.TSL2561_COMMAND_BIT, M.TSL2561_REGISTER_TIMING),
    bit.bor(time, gain)
  )
end

local function getFullLuminosity(dev_addr) -- Do the actual reading from the sensor
  local ch0low = i2cutils.read_reg(
    dev_addr,
    bit.bor(M.TSL2561_COMMAND_BIT, M.TSL2561_REGISTER_CHAN0_LOW)
  )
  local ch0high = i2cutils.read_reg(
    dev_addr,
    bit.bor(M.TSL2561_COMMAND_BIT, M.TSL2561_REGISTER_CHAN0_HIGH)
  )
  ch0=string.byte(ch0low)+(string.byte(ch0high)*256)

  local ch1low = i2cutils.read_reg(
    dev_addr,
    bit.bor(M.TSL2561_COMMAND_BIT, M.TSL2561_REGISTER_CHAN1_LOW)
  )
  local ch1high = i2cutils.read_reg(
    dev_addr,
    bit.bor(M.TSL2561_COMMAND_BIT, M.TSL2561_REGISTER_CHAN1_HIGH)
  )
  ch1=string.byte(ch1low)+(string.byte(ch1high)*256)
  return ch0, ch1
end

function M.getchannels()
  dev_addr = M.TSL2561_ADDR_FLOAT 
  i2c.setup(busid, SDA_PIN , SCL_PIN, i2c.SLOW)
  result = i2cutils.read_reg(
    dev_addr,
    bit.bor(M.TSL2561_COMMAND_BIT, M.TSL2561_REGISTER_ID)
  )
  enable(dev_addr)
  settimegain(dev_addr, M.TSL2561_INTEGRATIONTIME_402MS, M.TSL2561_GAIN_16X)
  disable(dev_addr)
  tmr.delay(1000) -- give 1ms for sensor to settle
  enable(dev_addr)
  tmr.delay(500000) -- gives 500ms for integration time
  chan0,chan1 = getFullLuminosity(dev_addr)
  disable(dev_addr)
  return chan0, chan1
end

function M.getlux()
    -- get channel values and scale them
    ch0,ch1 = M.getchannels()
    ch0 = bit.rshift((ch0 * bit.lshift(1,M.TSL2561_LUX_CHSCALE)), M.TSL2561_LUX_CHSCALE)
    ch1 = bit.rshift((ch1 * bit.lshift(1,M.TSL2561_LUX_CHSCALE)), M.TSL2561_LUX_CHSCALE)
    
    -- get ratio
    ratio = 0
    if (ch0 ~= 0) then
        ratio = (bit.lshift(ch1,M.TSL2561_LUX_RATIOSCALE+1))/ch0
    end
    ratio = bit.rshift((ratio + 1), 1)

    -- get coefficients m and b according to ratio
    m,b=0
    if ((ratio >= 0) and (ratio <= 0x0040)) then
        b=0x01f2
        m=0x01be
    elseif (ratio <= 0x0080) then
        b=0x0214
        m=0x02d1
    elseif (ratio <= 0x00c0) then
        b=0x023f
        m=0x037b
    elseif (ratio <= 0x0100) then
        b=0x0270
        m=0x03fe
    elseif (ratio <= 0x0138) then
        b=0x016f
        m=0x01fc
    elseif (ratio <= 0x019a) then
        b=0x00d2
        m=0x00fb
    elseif (ratio <= 0x029a) then
        b=0x0018
        m=0x0012
    elseif (ratio > 0x029a) then
        b=0x0000
        m=0x0000
    end
    
    lux = ((ch0 * b) - (ch1 * m))
    -- do not allow negative lux value
    if (lux < 0) then lux = 0 end
    -- round lsb (2^(LUX_SCALE-1))
    lux = lux + bit.lshift(1,(M.TSL2561_LUX_LUXSCALE-1))
    -- strip off fractional portion
    lux = bit.rshift(lux,M.TSL2561_LUX_LUXSCALE)
    
    return(lux);
end

return M
