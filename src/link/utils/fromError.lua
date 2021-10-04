-- ROBLOX upstream: https://github.com/apollographql/apollo-client/blob/v3.4.0-rc.17/src/link/utils/fromError.ts

local exports = {}
local utilitiesModule = require(script.Parent.Parent.Parent.utilities)
local Observable = utilitiesModule.Observable
type Observable<T> = utilitiesModule.Observable<T>

-- ROBLOX TODO:replace when generic in functions are possible
type T_ = any

local function fromError(errorValue: any): Observable<T_>
	return Observable.new(function(observer)
		observer:error(errorValue)
	end)
end
exports.fromError = fromError
return exports
