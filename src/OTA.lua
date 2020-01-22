local OTA = {}

local httpserver = OVL["httpserver"]()
local config = OVL["config"]()

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

local function updateConfig(request, response)
	local config = ""

	request.ondata = function(self, chunk)
		config = config .. chunk

		if not chunk then
			if config.write(config) then
				res:send(nil, 200)
				res:send_header("Connection", "close")
				res:send("OK")
				res:finish()
			else
				res:send(nil, 400)
				res:send_header("Connection", "close")
				res:send("JSON Decode error: " .. config)
				res:finish()
			end
		end
	end
end

local function uploadLFSImage(request, response)
	file.open("flash.img", "w+")

	request.ondata = function(self, chunk)
		file.write(chunk)

		if not chunk then
			res:send(nil, 200)
			res:send_header("Connection", "close")
			res:send("OK")
			res:finish()

			file.close()
			wifi.setmode(wifi.NULLMODE, false)
			collectgarbage()
			collectgarbage()

			node.task.post(function()
				node.flashreload(image)
			end)
		end
	end
end

function OTA.start()
	-- Starts an HTTP server on port 8080
	httpserver.createServer(8080, handleRequest)
	print("Started http server")
end

return OTA