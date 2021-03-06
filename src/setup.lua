local setup = {}

local function wifi_wait_ip(timer)
	if wifi.sta.getip() == nil then
		print("IP unavailable, Waiting...")
	else
		timer:unregister(1)
		print("\n====================================")
		print("ESP8266 mode is: " .. wifi.getmode())
		print("MAC address is: " .. wifi.ap.getmac())
		print("IP is " .. wifi.sta.getip())
		print("====================================")

		local mqClient = mqtt.Client("sensor", 120)

		mqClient:connect("192.168.178.234", 1884, 0, function(client)
			print("connected")

			local function prank()
				print("publishing " .. adc.read(0))
				client:publish(
					"sensors/moisture/data",
					'{"identifier":' .. node.chipid() .. ', "data":' .. adc.read(
						0
					) .. "}",
					0,
					0
				)
			end

			gpio.write(1, gpio.HIGH)
			local wifiTimer = tmr.create()
			wifiTimer:alarm(1000, tmr.ALARM_AUTO, prank)
		end)
	end
end

function setup.startWifi(config)
	print("Configuring Wifi ...")

	local sta_config = {
		ssid = config.SSID_NAME,
		pwd = config.SSID_PASSWORD
	}

	wifi.setmode(wifi.STATION)
	wifi.sta.config(sta_config)
	wifi.sta.connect()

	local wifiTimer = tmr.create()
	wifiTimer:alarm(2500, tmr.ALARM_AUTO, wifi_wait_ip)
end

-- Opens an Access Point for BootPanic
function setup.startAP()
	print("Configuring Access Point ...")

	local config = {
		ssid = node.chipid(),
		auth = wifi.OPEN
	}
	wifi.setmode(wifi.SOFTAP)
	wifi.ap.config(config)
end

return setup