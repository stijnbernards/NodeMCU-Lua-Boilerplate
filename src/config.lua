local config = {}

function config.read()
	if file.open("config.json", "r") then
		local status
		status, config = pcall(json.decode, file.read())

		if not status then
			return false
		end

		file.close()
	end

	if type(config) ~= "table" then
		config = {}
	end

	config.id = node.chipid()

	return config
end

function config.write(config)
	local status
	status, config = pcall(json.decode, config)

	if not status then
		return false
	end

	if file.open("config.json", "w+") then
		file.write(config)
		file.close()
	end

	return true
end

return config