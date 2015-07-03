This directory contains the nodeMCU firmware files that need to be flashed to the module.

The selfbuilt subdirectory contains a fork of the supplied nodeMCU firmware with certain modules disabled, for lowered power consumption
```
#define LUA_USE_MODULES

#ifdef LUA_USE_MODULES
#define LUA_USE_MODULES_NODE
#define LUA_USE_MODULES_FILE
#define LUA_USE_MODULES_GPIO
#define LUA_USE_MODULES_WIFI
#define LUA_USE_MODULES_NET
#define LUA_USE_MODULES_PWM
#define LUA_USE_MODULES_I2C
#define LUA_USE_MODULES_SPI
#define LUA_USE_MODULES_TMR
#define LUA_USE_MODULES_ADC
#define LUA_USE_MODULES_UART
#define LUA_USE_MODULES_OW
#define LUA_USE_MODULES_BIT
//#define LUA_USE_MODULES_MQTT
//#define LUA_USE_MODULES_COAP
//#define LUA_USE_MODULES_U8G
//#define LUA_USE_MODULES_WS2812
//#define LUA_USE_MODULES_CJSON
//#define LUA_USE_MODULES_CRYPTO
//#define LUA_USE_MODULES_RC
#define LUA_USE_MODULES_DHT

```
