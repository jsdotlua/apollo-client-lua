-- ROBLOX upstream: https://github.com/apollographql/apollo-client/blob/v3.4.0-rc.17/src/react/hooks/useReactiveVar.ts
local exports = {}
local srcWorkspace = script.Parent.Parent.Parent
local rootWorkspace = srcWorkspace.Parent

type Function = (...any) -> ...any

local reactModule = require(rootWorkspace.React)
local useEffect = reactModule.useEffect
local useState = reactModule.useState

-- ROBLOX deviation: import from cache module instead of core that reexports it upstream
local cacheModule = require(srcWorkspace.cache)
type ReactiveVar<T> = cacheModule.ReactiveVar<T>

local function useReactiveVar<T>(rv: ReactiveVar<T>): T
	local value = rv()
	-- We don't actually care what useState thinks the value of the variable
	-- is, so we take only the update function from the returned array.
	local _, setValue = useState(value)

	-- ROBLOX deviation: error is triggered because array with nil values has a different count
	local NIL = { __value = "nil placeholder" }

	-- We subscribe to variable updates on initial mount and when the value has
	-- changed. This avoids a subtle bug in React.StrictMode where multiple
	-- listeners are added, leading to inconsistent updates.
	useEffect(function()
		local probablySameValue = rv()
		if value ~= probablySameValue then
			-- If the value of rv has already changed, we don't need to listen for the
			-- next change, because we can report this change immediately.
			setValue(probablySameValue)
		else
			return rv:onNextChange(setValue :: any)
		end
	end :: Function, { value or NIL })

	return value
end

exports.useReactiveVar = useReactiveVar

return exports