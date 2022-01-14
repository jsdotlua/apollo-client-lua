-- ROBLOX upstream: https://github.com/apollographql/apollo-client/blob/v3.4.2/src/utilities/common/maybeDeepFreeze.ts
local exports = {}

local srcWorkspace = script.Parent.Parent.Parent
local rootWorkspace = srcWorkspace.Parent

local LuauPolyfill = require(rootWorkspace.LuauPolyfill)
local Object = LuauPolyfill.Object
-- ROBLOX TODO: remove when freeze and isFrozen are available from LuauPolyfill
Object.freeze = (table :: any).freeze
Object.isFrozen = (table :: any).isfrozen

local Set = LuauPolyfill.Set
local Array = LuauPolyfill.Array

require(script.Parent.Parent.globals) -- For __DEV__

local isNonNullObject = require(script.Parent.objects).isNonNullObject

local function deepFreeze(value: any)
	local workSet = Set.new({ value })
	for _, obj in workSet:ipairs() do
		if isNonNullObject(obj) then
			if not Object.isFrozen(obj) then
				Object.freeze(obj)
			end
			Array.forEach(Object.keys(obj), function(name)
				if isNonNullObject(obj[name]) then
					workSet:add(obj[name])
				end
			end)
		end
	end
	return value
end

local function maybeDeepFreeze<T>(obj: T): T
	if _G.__DEV__ then
		deepFreeze(obj)
	end
	return obj
end

exports.maybeDeepFreeze = maybeDeepFreeze

return exports
