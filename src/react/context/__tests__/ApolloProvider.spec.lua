-- ROBLOX upstream: https://github.com/apollographql/apollo-client/blob/v3.4.0-rc.6/src/react/context/__tests__/ApolloProvider.test.tsx

return function()
	local srcWorkspace = script.Parent.Parent.Parent.Parent
	local rootWorkspace = srcWorkspace.Parent

	local JestGlobals = require(rootWorkspace.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect

	local LuauPolyfill = require(rootWorkspace.LuauPolyfill)
	local Boolean = LuauPolyfill.Boolean
	local console = LuauPolyfill.console

	local React = require(rootWorkspace.React)
	local useContext = React.useContext

	local testingLibraryModule = require(srcWorkspace.testUtils.react)(afterEach)
	local render = testingLibraryModule.render
	local cleanup = testingLibraryModule.cleanup

	local ApolloLink = require(srcWorkspace.link.core).ApolloLink
	local apolloClientModule = require(srcWorkspace.core.ApolloClient)
	local ApolloClient = apolloClientModule.ApolloClient
	type ApolloClient<TCacheShape> = apolloClientModule.ApolloClient<TCacheShape>
	local Cache = require(srcWorkspace.cache.inmemory.inMemoryCache).InMemoryCache

	local ApolloContextModule = require(script.Parent.Parent)
	local ApolloProvider = ApolloContextModule.ApolloProvider
	local getApolloContext = ApolloContextModule.getApolloContext

	describe("<ApolloProvider /> Component", function()
		afterEach(cleanup)

		local client = ApolloClient.new({
			cache = Cache.new(),
			link = ApolloLink.new(function(_self, o, f)
				if Boolean.toJSBoolean(f) then
					return f(o)
				else
					return nil
				end
			end),
		})

		it("should render children components", function()
			local ref = render(
				React.createElement(
					ApolloProvider,
					{ client = client },
					React.createElement("TextLabel", { Text = "Test" })
				)
			)
			jestExpect(ref.getByText("Test")).toBeTruthy()
		end)

		it("should support the 2.0", function()
			local ref = render(
				React.createElement(
					ApolloProvider,
					{ client = {} :: ApolloClient<any> },
					React.createElement("TextLabel", { Text = "Test" })
				)
			)
			jestExpect(ref.getByText("Test")).toBeTruthy()
		end)

		it("should require a client", function()
			local originalConsoleError = console.error
			console.error = function()
				--[[ noop ]]
			end
			jestExpect(function()
				-- Before testing `ApolloProvider`, we first fully reset the
				-- existing context using `ApolloContext.Provider` directly.
				local ApolloContext = getApolloContext()
				render(
					React.createElement(
						ApolloContext.Provider,
						{ value = {} },
						React.createElement(
							ApolloProvider,
							{ client = nil :: any },
							React.createElement("TextLabel", { Text = "" })
						)
					)
				)
			end).toThrowError(
				"ApolloProvider was not passed a client instance. Make "
					.. 'sure you pass in your client via the "client" prop.'
			)
			console.error = originalConsoleError
		end)

		it("should not require a store", function()
			local ref = render(
				React.createElement(
					ApolloProvider,
					{ client = client },
					React.createElement("TextLabel", { Text = "Test" })
				)
			)
			jestExpect(ref.getByText("Test")).toBeTruthy()
		end)

		it("should add the client to the children context", function()
			local TestChild = function()
				local context = useContext(getApolloContext(), nil, nil)
				jestExpect(context.client).toEqual(client)
				return nil
			end
			render(React.createElement(
				ApolloProvider,
				{ client = client },
				-- ROBLOX FIXME Luau: this cast shouldn't be necessary
				{ React.createElement(TestChild), React.createElement(TestChild) :: any }
			))
		end)

		it("should update props when the client changes", function()
			local clientToCheck = client
			local TestChild = function()
				local context = useContext(getApolloContext(), nil, nil)
				jestExpect(context.client).toBe(clientToCheck)
				return nil
			end
			local ref =
				render(React.createElement(ApolloProvider, { client = clientToCheck }, React.createElement(TestChild)))
			local newClient = ApolloClient.new({
				cache = Cache.new(),
				link = ApolloLink.new(function(_self, o, f)
					if Boolean.toJSBoolean(f) then
						return f(o)
					else
						return nil
					end
				end),
			})
			clientToCheck = newClient
			ref.rerender(
				React.createElement(ApolloProvider, { client = clientToCheck }, React.createElement(TestChild))
			)
		end)
	end)
end
