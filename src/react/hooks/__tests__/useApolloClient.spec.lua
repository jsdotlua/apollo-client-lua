-- ROBLOX upstream: https://github.com/apollographql/apollo-client/blob/v3.4.2/src/react/hooks/__tests__/useApolloClient.test.tsx

local srcWorkspace = script.Parent.Parent.Parent.Parent
local rootWorkspace = srcWorkspace.Parent
local React = require(rootWorkspace.React)

local JestGlobals = require(rootWorkspace.Dev.JestGlobals)
local jestExpect = JestGlobals.expect

local bootstrap = require(srcWorkspace.utilities.common.bootstrap)

local ApolloLink = require(script.Parent.Parent.Parent.Parent.link.core).ApolloLink
local InMemoryCache = require(script.Parent.Parent.Parent.Parent.cache).InMemoryCache

-- ROBLOX deviation:
-- local InvariantError = require(Packages.ts - invariant).InvariantError

local ApolloClient = require(srcWorkspace.core).ApolloClient
local contextModule = require(srcWorkspace.react.context)
local ApolloProvider = contextModule.ApolloProvider
local resetApolloContext = contextModule.resetApolloContext
local useApolloClient = require(srcWorkspace.react.hooks).useApolloClient

return function()
	describe("useApolloClient Hook", function()
		local rootInstance
		local stop: (() -> ())?

		beforeEach(function()
			rootInstance = Instance.new("Folder")
			rootInstance.Name = "GuiRoot"
		end)

		afterEach(function()
			resetApolloContext()
			if typeof(stop) == "function" then
				(stop :: () -> ())()
			end
		end)

		it("should return a client instance from the context if available", function()
			local client = ApolloClient.new({ cache = InMemoryCache.new(), link = ApolloLink.empty() })
			local App = function()
				jestExpect(useApolloClient()).toEqual(client)
				return nil
			end
			stop = bootstrap(rootInstance, function()
				return React.createElement(ApolloProvider, { client = client }, React.createElement(App))
			end)
		end)

		it("should error if a client instance can't be found in the context", function()
			local App = function()
				jestExpect(function()
					useApolloClient()
				end).toThrow(
					"No Apollo Client instance can be found. Please ensure that you "
						.. "have called `ApolloProvider` higher up in your tree."
				)
				return nil
			end
			stop = bootstrap(rootInstance, function()
				return React.createElement(App, nil, nil)
			end)
		end)
	end)
end
