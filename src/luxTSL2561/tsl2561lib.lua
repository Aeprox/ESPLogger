-- Library for working with TSL2561 I2C Luminosity sensor
-- As used on breakout board by Adafruit
-- Special hat-tip to lady ada - hacker hero - amongst many others
-- This code is AGPL v3 by gareth@l0l.org.uk and Hamish Cunningham
-- blah blah blah standard licence conditions apply blah blah blah
-- Addapted by Aeprox for use in ESPlogger


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

-- add a few recursive definitions
function M.enable(dev_addr) -- enable the device
  i2cutils.write_reg(
    dev_addr,
    bit.bor(M.TSL2561_COMMAND_BIT, M.TSL2561_REGISTER_CONTROL),
    M.TSL2561_CONTROL_POWERON
  )
end

function M.disable(dev_addr) -- disable the device
  i2cutils.write_reg(
    dev_addr,
    bit.bor(M.TSL2561_COMMAND_BIT, M.TSL2561_REGISTER_CONTROL),
    M.TSL2561_CONTROL_POWEROFF
  )
end

function M.settimegain(dev_addr, time, gain) -- set the integration time and gain together
  i2cutils.write_reg(
    dev_addr,
    bit.bor(M.TSL2561_COMMAND_BIT, M.TSL2561_REGISTER_TIMING),
    bit.bor(time, gain)
  )
end

function M.getFullLuminosity(dev_addr) -- Do the actual reading from the sensor
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

return M
