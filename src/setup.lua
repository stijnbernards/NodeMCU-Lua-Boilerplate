local setup = {}

local function wifi_wait_ip()
	if wifi.sta.getip() == nil then
		print("IP unavailable, Waiting...")
	else
		tmr.stop(1)
		print("\n====================================")
		print("ESP8266 mode is: " .. wifi.getmode())
		print("MAC address is: " .. wifi.ap.getmac())
		print("IP is " .. wifi.sta.getip())
		print("====================================")
		app.start()
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
	tmr.alarm(1, 2500, 1, wifi_wait_ip)
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