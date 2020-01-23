local OTA = {}

local httpserver = OVL["httpserver"]()
local config = OVL["config"]()

local function updateLFSImage(request, response)
	file.open("flash.img", "w+")

	request.ondata = function(_, chunk)
		file.write(chunk)

		if not chunk then
			response:send(nil, 200)
			response:send_header("Connection", "close")
			response:send("OK")
			response:finish()

			file.close()
			wifi.setmode(wifi.NULLMODE, false)
			collectgarbage()
			collectgarbage()

			node.task.post(function()
				node.flashreload("flash.img")
			end)
		end
	end
end

local function updateConfig(request, response)
	local newConfig = ""

	request.ondata = function(_, chunk)
		newConfig = newConfig .. chunk

		if not chunk then
			if config.write(newConfig) then
				response:send(nil, 200)
				response:send_header("Connection", "close")
				response:send("OK")
				response:finish()
			else
				response:send(nil, 400)
				response:send_header("Connection", "close")
				response:send("JSON Decode error: " .. newConfig)
				response:finish()
			end
		end
	end
end

local function handleRequest(request, response)
	print(request.method)
	print(request.url)

	if request.method == "POST" and request.url == "/upload-config" then
		updateConfig(request, response)
	end

	if request.method == "POST" and request.url == "/upload-lfs" then
		updateLFSImage(request, response)
	end
end

function OTA.start()
	-- Starts an HTTP server on port 8080
	httpserver.createServer(8080, handleRequest)
	print("Started http server")
end

return OTA