local a=false;local b=net.createConnection(net.TCP,0)b:on("connection",function(b)if serialOut then print("Connection succeeded")print("Sending data...")end;b:send("POST /update HTTP/1.1\r\nHost: api.thingspeak.com\r\n")b:send("X-THINGSPEAKAPIKEY: "..APIkey.."\r\n")b:send("Content-Type: application/x-www-form-urlencoded\r\n")fields="headers=false&field1="..t/10 .."&field2="..h/10;if lxSensor==0 then fields=fields.."&field3="..lx0 end;if lxSensor==1 then fields=fields.."&field3="..lx0 .."&field4="..lx1 end;length=string.len(fields)b:send("Content-Length: "..length.."\r\n\r\n")b:send(fields.."\r\n\r\n")end)b:on("receive",function(b,c)if serialOut then print("payload:"..c)end;b:close()a=true end)b:on("disconnection",function(b)if serialOut then if a==false then print("Failed to send data.")else print("Data sent successfully!")end end;b=nil;a=nil end)b:connect(80,'api.thingspeak.com')