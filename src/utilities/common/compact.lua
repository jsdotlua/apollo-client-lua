-- ROBLOX upstream: https://github.com/apollographql/apollo-client/blob/v3.4.0-rc.17/src/utilities/common/compact.ts
local exports = {}
local srcWorkspace = script.Parent.Parent.Parent
local Packages = srcWorkspace.Parent
local LuauPolyfill = require(Packages.Dev.LuauPolyfill)
local Object = LuauPolyfill.Object
local function compact(...): any
	local result = {}
	-- ROBLOX deviation: we don't need to remove "undefined" values from objects in Lua
	--[[
         objects.forEach(obj => {
            if (!obj) return;
            Object.keys(obj).forEach(key => {
                const value = (obj as any)[key];
                if (value !== void 0) {
                    result[key] = value;
                }
            });
        });
    ]]
	return Object.assign(result, ...)
end
exports.compact = compact
return exports