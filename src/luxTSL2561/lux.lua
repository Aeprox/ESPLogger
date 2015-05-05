-- Code to read TSL2561 I2C Luminosity sensor
-- As used on breakout board by Adafruit
-- Special hat-tip to lady ada - hacker hero - amongst many others
local moduleName = "lux"
local M = {}
_G[moduleName] = M
i2cutils = require("i2cutils") -- get our helper functions loaded
local tl = require("tsl2561lib")


local busid = 0 -- i2c bus id

function M.getlux()
  dev_addr = tl.TSL2561_ADDR_FLOAT -- I2C address of device with ADDR pin floating
  i2c.setup(busid, SDA_PIN , SCL_PIN, i2c.SLOW)
  result = i2cutils.read_reg(
    dev_addr,
    bit.bor(tl.TSL2561_COMMAND_BIT, tl.TSL2561_REGISTER_ID)
  )
  --if string.byte(result) == 0x50 then print("Initialised TSL2561T/FN/CL") end
  tl.enable(dev_addr)
  tl.settimegain(dev_addr, tl.TSL2561_INTEGRATIONTIME_13MS, tl.TSL2561_GAIN_16X)
  tl.disable(dev_addr)
  tmr.delay(1000) -- give 1ms for sensor to settle
  tl.enable(dev_addr)
  tmr.delay(14000) -- gives 14ms for integration time
  chan0,chan1 = tl.getFullLuminosity(dev_addr)
  tl.disable(dev_addr)
  return chan0, chan1
end

function M.releaseResources()
    tl = nil
    i2cutils = nil

    package.loaded["tsl2561lib"]=nil
    package.loaded["i2cutils"]=nil
    collectgarbage("collect")
end

return M
