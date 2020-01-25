-- An "overlay" table: load files or flash components in a way
-- that, unlike require, doesn't cause them to "stick" in RAM.
--
-- Based on lua_examples/lfs/_init.lua
local G = getfenv()
local flashindex = node.flashindex

-- Override for LUA dofile
-- Tries to search for .lua and .lc files.
-- If it does not exists it'll try to open from the LFS image
local ovl_t = {
	__index = function(_, name)
		local f = loadfile(name .. ".lua")
		if f then
			return f
		end

		f = loadfile(name .. ".lc")
		if f then
			return f
		end

		if flashindex then
			local fn_ut, ba = flashindex(name)
			if not ba then
				return fn_ut
			end
		end

		return nil
	end,
	__newindex = function(_, name)
		error("Overlay is a synthetic view! " .. name, 2)
	end
}
G.OVL = setmetatable(ovl_t, ovl_t)

-- Install LFS as a package loader, as suggested by lua_examples/lfs/_init.lua
if flashindex then
	table.insert(package.loaders, function(module)
		local fn, ba = flashindex(module)
		return ba and "Module not in LFS" or fn
	end)
end

-- Save some bytes, as suggested by lua_examples/lfs/_init.lua
G.module = nil
package.seeall = nil

if rtctime then
	rtctime.set(0) -- set time to 0 until someone corrects us
end

local function bootPanic()
	-- TODO:: Start backup OTA
	OVL["setup"]().startAP()
	OVL["OTA"]().start()
end

local function continueBoot()
	local config = OVL["config"]().read()

	-- Config could not be loaded fallback into bootPanic
	if not config then
		bootPanic()
	end

	OVL["setup"]().startWifi(config)
	OVL["OTA"]().start()

	gpio.write(PIN_MOI, gpio.HIGH)
	print(adc.read(0))
	gpio.write(PIN_MOI, gpio.LOW)

end

local function waitFlash()
	local flashTimer = tmr.create()
	flashTimer:alarm(6000, tmr.ALARM_SINGLE, continueBoot)
end

-- Maps boot reason results to their respective functions
-- See: https://nodemcu.readthedocs.io/en/master/modules/node/#nodebootreason
local bootReasonTable = {
	[0] = waitFlash,
	[1] = bootPanic,
	[2] = bootPanic,
	[3] = bootPanic,
	[4] = waitFlash,
	[5] = continueBoot,
	[6] = waitFlash
}

local _, bootReason = node.bootreason()

if bootReasonTable[bootReason] then
	bootReasonTable[bootReason]()
else
	waitFlash()
end
