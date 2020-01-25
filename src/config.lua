local config = {}

-- Reads the config.json file and returns a parsed config object
-- If the config file doesn't contain a valid JSON it'll return false
function config.read()
	local parsedJson

	if file.open("config.json", "r") then
		local status
		status, parsedJson = pcall(sjson.decode, file.read())

		if not status then
			return false
		end

		file.close()
	end

	print(parsedJson)

	if type(parsedJson) ~= "table" then
		parsedJson = {}
	end

	parsedJson.id = node.chipid()

	return parsedJson
end

-- Writes the given string to the config.json file
function config.write(configString)
	if file.open("config.json", "w+") then
		file.write(configString)
		file.close()
	end

	return true
end

return config
