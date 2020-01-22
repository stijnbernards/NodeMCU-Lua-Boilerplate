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

	wifi.setmode(wifi.STATION)
	wifi.sta.config(config.SSID_NAME, config.SSID_PASSWORD)
	wifi.sta.connect()
	tmr.alarm(1, 2500, 1, wifi_wait_ip)
end

-- Opens an Access Point for BootPanic
function setup.startAP()
	print("Configuring Access Point ...")

	local config = {
		ssid = node.chipid(),
		ssid = wifi.OPEN
	}
	wifi.setmode(wifi.SOFTAP)
	wifi.ap.config(config)
end

return setup