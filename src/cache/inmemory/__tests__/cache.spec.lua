-- ROBLOX upstream: https://github.com/apollographql/apollo-client/blob/v3.4.0-rc.17/src/cache/inmemory/__tests__/cache.ts

return function()
	local srcWorkspace = script.Parent.Parent.Parent.Parent
	local rootWorkspace = srcWorkspace.Parent

	local HttpService = game:GetService("HttpService")

	local JestGlobals = require(rootWorkspace.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect
	local jest = JestGlobals.jest

	local NULL = require(srcWorkspace.utilities).NULL
	type JestMock = any

	local LuauPolyfill = require(rootWorkspace.LuauPolyfill)
	local Array = LuauPolyfill.Array
	local Boolean = LuauPolyfill.Boolean
	local Error = LuauPolyfill.Error
	local Map = LuauPolyfill.Map
	local Object = LuauPolyfill.Object
	-- ROBLOX TODO: replace when available in LuauPolyfill
	Object.isFrozen = (table :: any).isfrozen

	local String = LuauPolyfill.String
	type Array<T> = LuauPolyfill.Array<T>
	type Record<T, U> = { [T]: U }

	local isCallable = require(srcWorkspace.luaUtils.isCallable)

	type Watcher_ = any
	type E_ = any

	local graphqlTagModule = require(rootWorkspace.GraphQLTag)
	local gql = graphqlTagModule.default
	local disableFragmentWarnings = graphqlTagModule.disableFragmentWarnings

	local stripSymbols = require(script.Parent.Parent.Parent.Parent.utilities.testing.stripSymbols).stripSymbols
	local cloneDeep = require(script.Parent.Parent.Parent.Parent.utilities.common.cloneDeep).cloneDeep
	local coreModule = require(script.Parent.Parent.Parent.Parent.core)
	local makeReference = coreModule.makeReference
	type Reference = coreModule.Reference
	local reactiveVarsModule = require(script.Parent.Parent.reactiveVars)
	-- ROBLOX deviation: pulling directly from reactiveVars to avoid circular deps
	local makeVar = reactiveVarsModule.makeVar
	type ReactiveVar<T> = reactiveVarsModule.ReactiveVar<T>
	type TypedDocumentNode<Result, Variables> = coreModule.TypedDocumentNode<Result, Variables>
	-- ROBLOX TODO: remove underscore when used
	local _isReference = coreModule.isReference
	local graphQLModule = require(rootWorkspace.GraphQL)
	type DocumentNode = graphQLModule.DocumentNode
	local cacheModule = require(script.Parent.Parent.Parent.Parent.cache)
	type Cache_WatchOptions<Watcher> = cacheModule.Cache_WatchOptions<Watcher>
	type Cache_DiffResult<T> = cacheModule.Cache_DiffResult<T>
	local inMemoryCacheModule = require(script.Parent.Parent.inMemoryCache)
	local InMemoryCache = inMemoryCacheModule.InMemoryCache
	type InMemoryCache = inMemoryCacheModule.InMemoryCache
	type InMemoryCacheConfig = inMemoryCacheModule.InMemoryCacheConfig

	local cacheCoreTypesCommonModule = require(script.Parent.Parent.Parent.Parent.cache.core.types.common)
	type ReadFieldFunction = cacheCoreTypesCommonModule.ReadFieldFunction
	local policiesTypesModule = require(script.Parent.Parent.policies_types)
	type FieldFunctionOptions<TArgs, TVars> = policiesTypesModule.FieldFunctionOptions<TArgs, TVars>

	-- jest:mock("optimism")
	local wrap = require(srcWorkspace.optimism).wrap
	local StoreReader = require(script.Parent.Parent.readFromStore).StoreReader
	local StoreWriter = require(script.Parent.Parent.writeToStore).StoreWriter
	local ObjectCanon = require(script.Parent.Parent["object-canon"]).ObjectCanon

	disableFragmentWarnings()

	describe("Cache", function()
		local function itWithInitialData(
			it_,
			message: string,
			initialDataForCaches: Array<{ [string]: any }>,
			callback: (...InMemoryCache) -> ...any
		)
			local cachesList: Array<Array<InMemoryCache>> = {
				Array.map(initialDataForCaches, function(data)
					return InMemoryCache.new({ addTypename = false }):restore(cloneDeep(data))
				end),
				Array.map(initialDataForCaches, function(data)
					return InMemoryCache.new({ addTypename = false, resultCaching = false }):restore(cloneDeep(data))
				end),
			}
			Array.forEach(cachesList, function(caches, i)
				it_(("%s (%s/%s)"):format(message, tostring(i), tostring(#cachesList)), function()
					return callback(table.unpack(caches))
				end)
			end)
		end

		local function itWithCacheConfig(
			it_,
			message: string,
			config: InMemoryCacheConfig,
			callback: (cache: InMemoryCache) -> ...any
		)
			local caches = {
				InMemoryCache.new(Object.assign({}, { addTypename = false }, config, { resultCaching = true })),
				InMemoryCache.new(Object.assign({}, { addTypename = false }, config, { resultCaching = false })),
			}
			Array.forEach(caches, function(cache: InMemoryCache, i: number)
				it_(message .. (" (%s/%s)"):format(tostring(i + 1), tostring(#caches)), function()
					return callback(cache)
				end)
			end)
		end

		describe("readQuery", function()
			itWithInitialData(it, "will read some data from the store", {
				{
					ROOT_QUERY = {
						a = 1,
						b = 2,
						c = 3,
					},
				},
			}, function(proxy)
				jestExpect(stripSymbols(proxy:readQuery({
					query = gql([[

                {
                  a
                }
              ]]),
				}))).toEqual({ a = 1 })
				jestExpect(stripSymbols(proxy:readQuery({
					query = gql([[

                {
				  b
                  c
                }
              ]]),
				}))).toEqual({ b = 2, c = 3 })
				jestExpect(stripSymbols(proxy:readQuery({
					query = gql([[

                {
                  a
                  b
                  c
                }
              ]]),
				}))).toEqual({ a = 1, b = 2, c = 3 })
			end)

			itWithInitialData(it, "will read some deeply nested data from the store", {
				{
					ROOT_QUERY = {
						a = 1,
						b = 2,
						c = 3,
						d = makeReference("foo"),
					},
					foo = {
						e = 4,
						f = 5,
						g = 6,
						h = makeReference("bar"),
					},
					bar = {
						i = 7,
						j = 8,
						k = 9,
					},
				},
			}, function(proxy)
				jestExpect(stripSymbols(proxy:readQuery({
					query = gql([[

                {
                  a
                  d {
                    e
                  }
                }
              ]]),
				}))).toEqual({ a = 1, d = { e = 4 } })
				jestExpect(stripSymbols(proxy:readQuery({
					query = gql([[

                {
                  a
                  d {
                    e
                    h {
                      i
                    }
                  }
                }
              ]]),
				}))).toEqual({ a = 1, d = { e = 4, h = { i = 7 } } })
				jestExpect(stripSymbols(proxy:readQuery({
					query = gql([[

                {
                  a
                  b
                  c
                  d {
                    e
                    f
                    g
                    h {
                      i
                      j
                      k
                    }
                  }
                }
              ]]),
				}))).toEqual({
					a = 1,
					b = 2,
					c = 3,
					d = { e = 4, f = 5, g = 6, h = { i = 7, j = 8, k = 9 } },
				})
			end)

			itWithInitialData(it, "will read some data from the store with variables", {
				{
					ROOT_QUERY = {
						['field({"literal":true,"value":42})'] = 1,
						['field({"literal":false,"value":42})'] = 2,
					},
				},
			}, function(proxy)
				jestExpect(stripSymbols(proxy:readQuery({
					query = gql([[

                query($literal: Boolean, $value: Int) {
                  a: field(literal: true, value: 42)
                  b: field(literal: $literal, value: $value)
                }
              ]]),
					variables = { literal = false, value = 42 },
				}))).toEqual({ a = 1, b = 2 })
			end)

			itWithInitialData(it, "will read some data from the store with null variables", {
				{
					ROOT_QUERY = {
						[('field({"literal":false,"value":%s})'):format(HttpService:JSONEncode(NULL))] = 1,
					},
				},
			}, function(proxy)
				jestExpect(stripSymbols(proxy:readQuery({
					query = gql([[

                query($literal: Boolean, $value: Int) {
                  a: field(literal: $literal, value: $value)
                }
              ]]),
					variables = {
						literal = false,
						value = NULL,
					},
				}))).toEqual({ a = 1 })
			end)

			itWithInitialData(it, "should not mutate arguments passed in", {
				{
					ROOT_QUERY = {
						['field({"literal":true,"value":42})'] = 1,
						['field({"literal":false,"value":42})'] = 2,
					},
				},
			}, function(proxy)
				local options = {
					query = gql([[

            query($literal: Boolean, $value: Int) {
              a: field(literal: true, value: 42)
              b: field(literal: $literal, value: $value)
            }
          ]]),
					variables = {
						literal = false,
						value = 42,
					},
				}
				local preQueryCopy = cloneDeep(options)
				jestExpect(stripSymbols(proxy:readQuery(options))).toEqual({ a = 1, b = 2 })
				jestExpect(preQueryCopy).toEqual(options)
			end)
		end)

		-- ROBLOX NOTE: fragments are not supported yet
		xdescribe("readFragment", function()
			itWithInitialData(it, "will throw an error when there is no fragment_", { {} }, function(proxy)
				jestExpect(function()
					proxy:readFragment({
						id = "x",
						fragment = gql([[

              query {
                a
                b
                c
              }
            ]]),
					})
				end).toThrowError(
					"Found a query operation. No operations are allowed when using a fragment as a query. Only fragments are allowed."
				)
				jestExpect(function()
					proxy:readFragment({
						id = "x",
						fragment = gql([[

              schema {
                query: Query
              }
            ]]),
					})
				end).toThrowError(
					"Found 0 fragments. `fragmentName` must be provided when there is not exactly 1 fragment."
				)
			end)

			itWithInitialData(
				it,
				"will throw an error when there is more than one fragment but no fragment name",
				{ {} },
				function(proxy)
					jestExpect(function()
						proxy:readFragment({
							id = "x",
							fragment = gql([[

              fragment a on A {
                a
              }

              fragment b on B {
                b
              }
            ]]),
						})
					end).toThrowError(
						"Found 2 fragments. `fragmentName` must be provided when there is not exactly 1 fragment."
					)
					jestExpect(function()
						proxy:readFragment({
							id = "x",
							fragment = gql([[

              fragment a on A {
                a
              }

              fragment b on B {
                b
              }

              fragment c on C {
                c
              }
            ]]),
						})
					end).toThrowError(
						"Found 3 fragments. `fragmentName` must be provided when there is not exactly 1 fragment."
					)
				end
			)

			itWithInitialData(it, "will read some deeply nested data from the store at any id", {
				{
					ROOT_QUERY = { __typename = "Type1", a = 1, b = 2, c = 3, d = makeReference("foo") },
					foo = { __typename = "Foo", e = 4, f = 5, g = 6, h = makeReference("bar") },
					bar = { __typename = "Bar", i = 7, j = 8, k = 9 },
				},
			}, function(proxy)
				jestExpect(stripSymbols(proxy:readFragment({
					id = "foo",
					fragment = gql([[

                fragment fragmentFoo on Foo {
                  e
                  h {
                    i
                  }
                }
              ]]),
				}))).toEqual({ e = 4, h = { i = 7 } })
				jestExpect(stripSymbols(proxy:readFragment({
					id = "foo",
					fragment = gql([[

                fragment fragmentFoo on Foo {
                  e
                  f
                  g
                  h {
                    i
                    j
                    k
                  }
                }
              ]]),
				}))).toEqual({ e = 4, f = 5, g = 6, h = { i = 7, j = 8, k = 9 } })
				jestExpect(stripSymbols(proxy:readFragment({
					id = "bar",
					fragment = gql([[

                fragment fragmentBar on Bar {
                  i
                }
              ]]),
				}))).toEqual({ i = 7 })
				jestExpect(stripSymbols(proxy:readFragment({
					id = "bar",
					fragment = gql([[

                fragment fragmentBar on Bar {
                  i
                  j
                  k
                }
              ]]),
				}))).toEqual({ i = 7, j = 8, k = 9 })
				jestExpect(stripSymbols(proxy:readFragment({
					id = "foo",
					fragment = gql([[

                fragment fragmentFoo on Foo {
                  e
                  f
                  g
                  h {
                    i
                    j
                    k
                  }
                }

                fragment fragmentBar on Bar {
                  i
                  j
                  k
                }
              ]]),
					fragmentName = "fragmentFoo",
				}))).toEqual({ e = 4, f = 5, g = 6, h = { i = 7, j = 8, k = 9 } })
				jestExpect(stripSymbols(proxy:readFragment({
					id = "bar",
					fragment = gql([[

                fragment fragmentFoo on Foo {
                  e
                  f
                  g
                  h {
                    i
                    j
                    k
                  }
                }

                fragment fragmentBar on Bar {
                  i
                  j
                  k
                }
              ]]),
					fragmentName = "fragmentBar",
				}))).toEqual({ i = 7, j = 8, k = 9 })
			end)

			itWithInitialData(it, "will read some data from the store with variables_", {
				{
					foo = {
						__typename = "Foo",
						['field({"literal":true,"value":42})'] = 1,
						['field({"literal":false,"value":42})'] = 2,
					},
				},
			}, function(proxy)
				jestExpect(stripSymbols(proxy:readFragment({
					id = "foo",
					fragment = gql([[

                fragment foo on Foo {
                  a: field(literal: true, value: 42)
                  b: field(literal: $literal, value: $value)
                }
              ]]),
					variables = { literal = false, value = 42 },
				}))).toEqual({ a = 1, b = 2 })
			end)

			itWithInitialData(it, "will return null when an id that can\u{2019}t be found is provided", {
				{},
				{ bar = { __typename = "Bar", a = 1, b = 2, c = 3 } },
				{ foo = { __typename = "Foo", a = 1, b = 2, c = 3 } },
			}, function(client1, client2, client3)
				jestExpect(stripSymbols(client1:readFragment({
					id = "foo",
					fragment = gql([[

                fragment fooFragment on Foo {
                  a
                  b
                  c
                }
              ]]),
				}))).toEqual(nil)
				jestExpect(stripSymbols(client2:readFragment({
					id = "foo",
					fragment = gql([[

                fragment fooFragment on Foo {
                  a
                  b
                  c
                }
              ]]),
				}))).toEqual(nil)
				jestExpect(stripSymbols(client3:readFragment({
					id = "foo",
					fragment = gql([[

                fragment fooFragment on Foo {
                  a
                  b
                  c
                }
              ]]),
				}))).toEqual({ a = 1, b = 2, c = 3 })
			end)

			it("should not accidentally depend on unrelated entity fields", function()
				local cache = InMemoryCache.new({ resultCaching = true })
				local bothNamesData = {
					__typename = "Person",
					id = 123,
					firstName = "Ben",
					lastName = "Newman",
				}
				local firstNameQuery = gql("{ firstName }")
				local lastNameQuery = gql("{ lastName }")
				local id = cache:identify(bothNamesData)
				cache:writeQuery({ id = id, query = firstNameQuery, data = bothNamesData })
				local meta123 = { extraRootIds = { "Person:123" } }
				jestExpect(cache:extract()).toEqual({
					__META = meta123,
					["Person:123"] = { __typename = "Person", id = 123, firstName = "Ben" },
				})
				local firstNameResult = cache:readQuery({ id = id, query = firstNameQuery })
				jestExpect(firstNameResult).toEqual({ __typename = "Person", firstName = "Ben" })
				cache:writeQuery({ id = id, query = lastNameQuery, data = bothNamesData })
				jestExpect(cache:extract()).toEqual({
					__META = meta123,
					["Person:123"] = {
						__typename = "Person",
						id = 123,
						firstName = "Ben",
						lastName = "Newman",
					},
				})
				jestExpect(cache:readQuery({ id = id, query = firstNameQuery })).toBe(firstNameResult)
				local lastNameResult = cache:readQuery({ id = id, query = lastNameQuery })
				jestExpect(lastNameResult).toEqual({ __typename = "Person", lastName = "Newman" })
				cache:writeQuery({
					id = id,
					query = firstNameQuery,
					data = Object.assign({}, bothNamesData, { firstName = "Benjamin" }),
				})
				jestExpect(cache:extract()).toEqual({
					__META = meta123,
					["Person:123"] = {
						__typename = "Person",
						id = 123,
						firstName = "Benjamin",
						lastName = "Newman",
					},
				})
				local benjaminResult = cache:readQuery({ id = id, query = firstNameQuery })
				jestExpect(benjaminResult).toEqual({ __typename = "Person", firstName = "Benjamin" })
				jestExpect(firstNameResult).toEqual({ __typename = "Person", firstName = "Ben" })
				jestExpect(cache:readQuery({ id = id, query = lastNameQuery })).toBe(lastNameResult)
			end)

			it("should not return null when ID found in optimistic layer", function()
				local cache = InMemoryCache.new()
				local fragment = gql([[

        fragment NameFragment on Person {
          firstName
          lastName
        }
      ]])
				local data = {
					__typename = "Person",
					id = 321,
					firstName = "Hugh",
					lastName = "Willson",
				}
				local id = cache:identify(data) :: any
				cache:recordOptimisticTransaction(function(proxy)
					proxy:writeFragment({ id = id, fragment = fragment, data = data })
				end, "optimistic Hugh")
				jestExpect(cache:extract(false)).toEqual({})
				jestExpect(cache:extract(true)).toEqual({
					__META = { extraRootIds = { "Person:321" } },
					["Person:321"] = {
						__typename = "Person",
						id = 321,
						firstName = "Hugh",
						lastName = "Willson",
					},
				})
				jestExpect(cache:readFragment({ id = id, fragment = fragment }, false)).toBe(nil)
				jestExpect(cache:readFragment({ id = id, fragment = fragment }, true)).toEqual({
					__typename = "Person",
					firstName = "Hugh",
					lastName = "Willson",
				})
				cache:writeFragment({
					id = id,
					fragment = fragment,
					data = Object.assign({}, data, { firstName = "HUGH", lastName = "WILLSON" }),
				})
				jestExpect(cache:readFragment({ id = id, fragment = fragment }, false)).toEqual({
					__typename = "Person",
					firstName = "HUGH",
					lastName = "WILLSON",
				})
				jestExpect(cache:readFragment({ id = id, fragment = fragment }, true)).toEqual({
					__typename = "Person",
					firstName = "Hugh",
					lastName = "Willson",
				})
				cache:removeOptimistic("optimistic Hugh")
				jestExpect(cache:readFragment({ id = id, fragment = fragment }, true)).toEqual({
					__typename = "Person",
					firstName = "HUGH",
					lastName = "WILLSON",
				})
			end)
		end)

		describe("writeQuery", function()
			itWithInitialData(it, "will write some data to the store", { {} }, function(proxy)
				proxy:writeQuery({
					data = { a = 1 },
					query = gql([[

          {
            a
          }
        ]]),
				})

				jestExpect((proxy :: InMemoryCache):extract()).toEqual({
					ROOT_QUERY = {
						__typename = "Query",
						a = 1,
					},
				})

				proxy:writeQuery({
					data = { b = 2, c = 3 },
					query = gql([[

          {
            b
            c
          }
        ]]),
				})

				jestExpect((proxy :: InMemoryCache):extract()).toEqual({
					ROOT_QUERY = {
						__typename = "Query",
						a = 1,
						b = 2,
						c = 3,
					},
				})

				proxy:writeQuery({
					data = { a = 4, b = 5, c = 6 },
					query = gql([[

          {
            a
            b
            c
          }
        ]]),
				})

				jestExpect((proxy :: InMemoryCache):extract()).toEqual({
					ROOT_QUERY = {
						__typename = "Query",
						a = 4,
						b = 5,
						c = 6,
					},
				})
			end)

			it("will write some deeply nested data to the store", function()
				local cache = InMemoryCache.new({
					typePolicies = {
						Query = {
							fields = {
								d = {
									-- Deliberately silence "Cache data may be lost..."
									-- warnings by unconditionally favoring the incoming data.
									merge = false,
								},
							},
						},
					},
				})

				cache:writeQuery({
					data = { a = 1, d = { e = 4 } },
					query = gql([[

          {
            a
            d {
              e
            }
          }
        ]]),
				})

				jestExpect((cache :: InMemoryCache):extract()).toEqual({
					ROOT_QUERY = {
						__typename = "Query",
						a = 1,
						d = { e = 4 },
					},
				})

				cache:writeQuery({
					data = { a = 1, d = { h = { i = 7 } } },
					query = gql([[

          {
            a
            d {
              h {
                i
              }
            }
          }
        ]]),
				})

				jestExpect((cache :: InMemoryCache):extract()).toEqual({
					ROOT_QUERY = {
						__typename = "Query",
						a = 1,
						-- The new value for d overwrites the old value, since there
						-- is no custom merge function defined for Query.d.
						d = {
							h = {
								i = 7,
							},
						},
					},
				})

				cache:writeQuery({
					data = {
						a = 1,
						b = 2,
						c = 3,
						d = { e = 4, f = 5, g = 6, h = { i = 7, j = 8, k = 9 } },
					},
					query = gql([[

          {
            a
            b
            c
            d {
              e
              f
              g
              h {
                i
                j
                k
              }
            }
          }
        ]]),
				})

				jestExpect((cache :: InMemoryCache):extract()).toEqual({
					ROOT_QUERY = {
						__typename = "Query",
						a = 1,
						b = 2,
						c = 3,
						d = {
							e = 4,
							f = 5,
							g = 6,
							h = {
								i = 7,
								j = 8,
								k = 9,
							},
						},
					},
				})
			end)

			itWithInitialData(it, "will write some data to the store with variables", { {} }, function(proxy)
				proxy:writeQuery({
					data = {
						a = 1,
						b = 2,
					},
					query = gql([[

            query($literal: Boolean, $value: Int) {
              a: field(literal: true, value: 42)
              b: field(literal: $literal, value: $value)
            }
          ]]),
					variables = {
						literal = false,
						value = 42,
					},
				})

				jestExpect((proxy :: InMemoryCache):extract()).toEqual({
					ROOT_QUERY = {
						__typename = "Query",
						['field({"literal":true,"value":42})'] = 1,
						['field({"literal":false,"value":42})'] = 2,
					},
				})
			end)

			itWithInitialData(
				it,
				"will write some data to the store with variables where some are null",
				{ {} },
				function(proxy)
					proxy:writeQuery({
						data = {
							a = 1,
							b = 2,
						},
						query = gql([[

            query($literal: Boolean, $value: Int) {
              a: field(literal: true, value: 42)
              b: field(literal: $literal, value: $value)
            }
          ]]),
						variables = {
							literal = false,
							value = NULL,
						},
					})

					jestExpect((proxy :: InMemoryCache):extract()).toEqual({
						ROOT_QUERY = {
							__typename = "Query",
							['field({"literal":true,"value":42})'] = 1,
							[('field({"literal":false,"value":%s})'):format(HttpService:JSONEncode(NULL))] = 2,
						},
					})
				end
			)
		end)

		-- ROBLOX NOTE: fragments are not supported yet
		xdescribe("writeFragment", function()
			itWithInitialData(it, "will throw an error when there is no fragment", { {} }, function(proxy)
				jestExpect(function()
					proxy:writeFragment({
						data = {},
						id = "x",
						fragment = gql([[

              query {
                a
                b
                c
              }
            ]]),
					})
				end).toThrowError(
					"Found a query operation. No operations are allowed when using a fragment as a query. Only fragments are allowed."
				)
				jestExpect(function()
					proxy:writeFragment({
						data = {},
						id = "x",
						fragment = gql([[

              schema {
                query: Query
              }
            ]]),
					})
				end).toThrowError(
					"Found 0 fragments. `fragmentName` must be provided when there is not exactly 1 fragment."
				)
			end)

			itWithInitialData(
				it,
				"will throw an error when there is more than one fragment but no fragment name_",
				{ {} },
				function(proxy)
					jestExpect(function()
						proxy:writeFragment({
							data = {},
							id = "x",
							fragment = gql([[

              fragment a on A {
                a
              }

              fragment b on B {
                b
              }
            ]]),
						})
					end).toThrowError(
						"Found 2 fragments. `fragmentName` must be provided when there is not exactly 1 fragment."
					)
					jestExpect(function()
						proxy:writeFragment({
							data = {},
							id = "x",
							fragment = gql([[

              fragment a on A {
                a
              }

              fragment b on B {
                b
              }

              fragment c on C {
                c
              }
            ]]),
						})
					end).toThrowError(
						"Found 3 fragments. `fragmentName` must be provided when there is not exactly 1 fragment."
					)
				end
			)
			itWithCacheConfig(it, "will write some deeply nested data into the store at any id", {
				dataIdFromObject = function(o: any)
					return o.id
				end,
				addTypename = false,
			}, function(proxy)
				proxy:writeFragment({
					data = { __typename = "Foo", e = 4, h = { id = "bar", i = 7 } },
					id = "foo",
					fragment = gql([[

            fragment fragmentFoo on Foo {
              e
              h {
                i
              }
            }
          ]]),
				})
				jestExpect((proxy :: InMemoryCache):extract()).toMatchSnapshot()
				proxy:writeFragment({
					data = { __typename = "Foo", f = 5, g = 6, h = { id = "bar", j = 8, k = 9 } },
					id = "foo",
					fragment = gql([[

            fragment fragmentFoo on Foo {
              f
              g
              h {
                j
                k
              }
            }
          ]]),
				})
				jestExpect((proxy :: InMemoryCache):extract()).toMatchSnapshot()
				proxy:writeFragment({
					data = { i = 10, __typename = "Bar" },
					id = "bar",
					fragment = gql([[

            fragment fragmentBar on Bar {
              i
            }
          ]]),
				})
				jestExpect((proxy :: InMemoryCache):extract()).toMatchSnapshot()
				proxy:writeFragment({
					data = { j = 11, k = 12, __typename = "Bar" },
					id = "bar",
					fragment = gql([[

            fragment fragmentBar on Bar {
              j
              k
            }
          ]]),
				})
				jestExpect((proxy :: InMemoryCache):extract()).toMatchSnapshot()
				proxy:writeFragment({
					data = {
						__typename = "Foo",
						e = 4,
						f = 5,
						g = 6,
						h = { __typename = "Bar", id = "bar", i = 7, j = 8, k = 9 },
					},
					id = "foo",
					fragment = gql([[

            fragment fooFragment on Foo {
              e
              f
              g
              h {
                i
                j
                k
              }
            }

            fragment barFragment on Bar {
              i
              j
              k
            }
          ]]),
					fragmentName = "fooFragment",
				})
				jestExpect((proxy :: InMemoryCache):extract()).toMatchSnapshot()
				proxy:writeFragment({
					data = { __typename = "Bar", i = 10, j = 11, k = 12 },
					id = "bar",
					fragment = gql([[

            fragment fooFragment on Foo {
              e
              f
              g
              h {
                i
                j
                k
              }
            }

            fragment barFragment on Bar {
              i
              j
              k
            }
          ]]),
					fragmentName = "barFragment",
				})
				jestExpect((proxy :: InMemoryCache):extract()).toMatchSnapshot()
			end)

			itWithCacheConfig(it, "writes data that can be read back", { addTypename = true }, function(proxy)
				local readWriteFragment = gql([[

          fragment aFragment on query {
            getSomething {
              id
            }
          }
        ]])
				local data = {
					__typename = "query",
					getSomething = { id = "123", __typename = "Something" },
				}
				proxy:writeFragment({ data = data, id = "query", fragment = readWriteFragment })
				local result = proxy:readFragment({ fragment = readWriteFragment, id = "query" })
				jestExpect(stripSymbols(result)).toEqual(data)
			end)

			itWithCacheConfig(
				it,
				"will write some data to the store with variables_",
				{ addTypename = true },
				function(proxy: InMemoryCache)
					proxy:writeFragment({
						data = { a = 1, b = 2, __typename = "Foo" },
						id = "foo",
						fragment = gql([[

            fragment foo on Foo {
              a: field(literal: true, value: 42)
              b: field(literal: $literal, value: $value)
            }
          ]]),
						variables = { literal = false, value = 42 },
					})
					jestExpect((proxy :: InMemoryCache):extract()).toEqual({
						__META = { extraRootIds = { "foo" } },
						foo = {
							__typename = "Foo",
							['field({"literal":true,"value":42})'] = 1,
							['field({"literal":false,"value":42})'] = 2,
						},
					})
				end
			)
		end)

		describe("cache.restore", function()
			it("replaces cache.{store{Reader,Writer},maybeBroadcastWatch}", function()
				local cache = InMemoryCache.new()
				local query = gql("query { a b c }")

				local originalReader = cache["storeReader"]
				jestExpect(originalReader).toBeInstanceOf(StoreReader)

				local originalWriter = cache["storeWriter"]
				jestExpect(originalWriter).toBeInstanceOf(StoreWriter)

				local originalMBW = cache["maybeBroadcastWatch"]
				-- ROBLOX deviation: we need to check if originalMBW is callable rather then check for function type
				-- jestExpect(typeof(originalMBW)).toBe("function")
				jestExpect(isCallable(originalMBW)).toBe(true)

				local originalCanon = originalReader.canon
				jestExpect(originalCanon).toBeInstanceOf(ObjectCanon)

				cache:writeQuery({
					query = query,
					data = {
						a = "ay",
						b = "bee",
						c = "see",
					},
				})

				local snapshot = cache:extract()
				jestExpect(snapshot).toMatchSnapshot()

				cache:restore({})
				jestExpect(cache:extract()).toEqual({})
				jestExpect(cache:readQuery({ query = query })).toBe(NULL)

				cache:restore(snapshot)
				jestExpect(cache:extract()).toEqual(snapshot)
				jestExpect(cache:readQuery({ query = query })).toEqual({ a = "ay", b = "bee", c = "see" })

				jestExpect(originalReader).never.toBe(cache["storeReader"])
				jestExpect(originalWriter).never.toBe(cache["storeWriter"])
				jestExpect(originalMBW).never.toBe(cache["maybeBroadcastWatch"])
				-- The cache.storeReader.canon is preserved by default, but can be dropped
				-- by passing resetResultIdentities:true to cache.gc.
				jestExpect(originalCanon).toBe(cache["storeReader"].canon)
			end)
		end)

		describe("cache.batch", function()
			local function last(array: Array<E_>)
				return array[#array]
			end
			local function watch(
				cache: InMemoryCache,
				query: DocumentNode
			): {
				diffs: Array<Cache_DiffResult<any>>,
				watch: Cache_WatchOptions<Record<string, any>>,
				cancel: () -> (),
			}
				-- ROBLOX deviation: predeclare variable
				local diffs: Array<Cache_DiffResult<any>>
				local options: Cache_WatchOptions<Watcher_> = {
					query = query,
					optimistic = true,
					immediate = true,
					callback = function(_self, diff)
						table.insert(diffs, diff)
					end,
				}
				diffs = {}
				local cancel = cache:watch(options)
				table.remove(diffs, 1) -- Discard the immediate diff
				return { diffs = diffs, watch = options, cancel = cancel }
			end

			it("calls onWatchUpdated for each invalidated watch", function()
				local cache = InMemoryCache.new()
				local aQuery = gql("query { a }")
				local abQuery = gql("query { a b }")
				local bQuery = gql("query { b }")
				local aInfo = watch(cache, aQuery)
				local abInfo = watch(cache, abQuery)
				local bInfo = watch(cache, bQuery)
				local dirtied = Map.new(nil)
				cache:batch({
					update = function(_self, cache)
						cache:writeQuery({ query = aQuery, data = { a = "ay" } })
					end,
					optimistic = true,
					onWatchUpdated = function(_self, w, diff)
						dirtied:set(w, diff)
					end,
				})
				jestExpect(dirtied.size).toBe(2)
				jestExpect(dirtied:has(aInfo.watch)).toBe(true)
				jestExpect(dirtied:has(abInfo.watch)).toBe(true)
				jestExpect(dirtied:has(bInfo.watch)).toBe(false)
				jestExpect(#aInfo.diffs).toBe(1)
				jestExpect(last(aInfo.diffs)).toEqual({ complete = true, result = { a = "ay" } })
				jestExpect(#abInfo.diffs).toBe(1)

				jestExpect(last(abInfo.diffs)).toEqual({
					complete = false,
					--ROBLOX deviation: can't check instanceOf Array with table, adding extra test below to check if isArray
					missing = jestExpect.anything(), -- jestExpect.any(Array)
					result = { a = "ay" },
				})
				jestExpect(Array.isArray(last(abInfo.diffs).missing)).toBe(true)

				jestExpect(#bInfo.diffs).toBe(0)
				dirtied:clear()
				cache:batch({
					update = function(_self, cache)
						cache:writeQuery({ query = bQuery, data = { b = "bee" } })
					end,
					optimistic = true,
					onWatchUpdated = function(_self, w, diff)
						dirtied:set(w, diff)
					end,
				})
				jestExpect(dirtied.size).toBe(2)
				jestExpect(dirtied:has(aInfo.watch)).toBe(false)
				jestExpect(dirtied:has(abInfo.watch)).toBe(true)
				jestExpect(dirtied:has(bInfo.watch)).toBe(true)
				jestExpect(#aInfo.diffs).toBe(1)
				jestExpect(last(aInfo.diffs)).toEqual({ complete = true, result = { a = "ay" } })
				jestExpect(#abInfo.diffs).toBe(2)
				jestExpect(last(abInfo.diffs)).toEqual({ complete = true, result = { a = "ay", b = "bee" } })
				jestExpect(#bInfo.diffs).toBe(1)
				jestExpect(last(bInfo.diffs)).toEqual({ complete = true, result = { b = "bee" } })
				aInfo.cancel()
				abInfo.cancel()
				bInfo.cancel()
			end)

			it("works with cache.modify and INVALIDATE", function()
				local cache = InMemoryCache.new()
				local aQuery = gql("query { a }")
				local abQuery = gql("query { a b }")
				local bQuery = gql("query { b }")
				cache:writeQuery({ query = abQuery, data = { a = "ay", b = "bee" } })
				local aInfo = watch(cache, aQuery)
				local abInfo = watch(cache, abQuery)
				local bInfo = watch(cache, bQuery)
				local dirtied = Map.new(nil)
				cache:batch({
					update = function(_self, cache)
						cache:modify({
							fields = {
								a = function(_self, value, ref)
									local INVALIDATE = ref.INVALIDATE
									jestExpect(value).toBe("ay")
									return INVALIDATE
								end,
							},
						})
					end,
					optimistic = true,
					onWatchUpdated = function(_self, w, diff)
						dirtied:set(w, diff)
					end,
				})
				jestExpect(dirtied.size).toBe(2)
				jestExpect(dirtied:has(aInfo.watch)).toBe(true)
				jestExpect(dirtied:has(abInfo.watch)).toBe(true)
				jestExpect(dirtied:has(bInfo.watch)).toBe(false)
				jestExpect(aInfo.diffs).toEqual({})
				jestExpect(abInfo.diffs).toEqual({})
				jestExpect(bInfo.diffs).toEqual({})
				aInfo.cancel()
				abInfo.cancel()
				bInfo.cancel()
			end)

			it("does not pass previously invalidated queries to onWatchUpdated", function()
				local cache = InMemoryCache.new()
				local aQuery = gql("query { a }")
				local abQuery = gql("query { a b }")
				local bQuery = gql("query { b }")
				cache:writeQuery({ query = abQuery, data = { a = "ay", b = "bee" } })
				local aInfo = watch(cache, aQuery)
				local abInfo = watch(cache, abQuery)
				local bInfo = watch(cache, bQuery)
				cache:writeQuery({ query = bQuery, broadcast = false, data = { b = "beeeee" } })
				jestExpect(aInfo.diffs).toEqual({})
				jestExpect(abInfo.diffs).toEqual({})
				jestExpect(bInfo.diffs).toEqual({})
				local dirtied = Map.new(nil)
				cache:batch({
					update = function(_self, cache)
						cache:modify({
							fields = {
								a = function(self, value)
									jestExpect(value).toBe("ay")
									return "ayyyy"
								end,
							},
						})
					end,
					optimistic = true,
					onWatchUpdated = function(self, watch, diff)
						dirtied:set(watch, diff)
					end,
				})
				jestExpect(dirtied.size).toBe(2)
				jestExpect(dirtied:has(aInfo.watch)).toBe(true)
				jestExpect(dirtied:has(abInfo.watch)).toBe(true)
				jestExpect(dirtied:has(bInfo.watch)).toBe(false)
				jestExpect(aInfo.diffs).toEqual({ { complete = true, result = { a = "ayyyy" } } })
				jestExpect(abInfo.diffs).toEqual({ { complete = true, result = { a = "ayyyy", b = "beeeee" } } })
				jestExpect(bInfo.diffs).toEqual({});
				(cache :: any)["broadcastWatches"](cache)
				jestExpect(aInfo.diffs).toEqual({ { complete = true, result = { a = "ayyyy" } } })
				jestExpect(abInfo.diffs).toEqual({ { complete = true, result = { a = "ayyyy", b = "beeeee" } } })
				jestExpect(bInfo.diffs).toEqual({ { complete = true, result = { b = "beeeee" } } })
				aInfo.cancel()
				abInfo.cancel()
				bInfo.cancel()
			end)
		end)

		describe("performTransaction", function()
			itWithInitialData(it, "will not broadcast mid-transaction", { {} }, function(cache)
				local numBroadcasts = 0
				local query = gql([[

        {
          a
        }
      ]])
				cache:watch({
					query = query,
					optimistic = false,
					callback = function()
						numBroadcasts += 1
					end,
				})
				jestExpect(numBroadcasts).toEqual(0)
				cache:performTransaction(function(proxy: InMemoryCache)
					proxy:writeQuery({ data = { a = 1 }, query = query })
					jestExpect(numBroadcasts).toEqual(0)
					proxy:writeQuery({
						data = { a = 4, b = 5, c = 6 },
						query = gql([[

            {
              a
              b
              c
            }
          ]]),
					})
					jestExpect(numBroadcasts).toEqual(0)
				end)
				jestExpect(numBroadcasts).toEqual(1)
			end)
		end)

		describe("recordOptimisticTransaction", function()
			itWithInitialData(it, "will only broadcast once", { {} }, function(cache)
				local numBroadcasts = 0
				local query = gql([[

        {
          a
        }
      ]])
				cache:watch({
					query = query,
					optimistic = true,
					callback = function()
						numBroadcasts += 1
					end,
				})
				jestExpect(numBroadcasts).toEqual(0)
				cache:recordOptimisticTransaction(function(proxy)
					proxy:writeQuery({ data = { a = 1 }, query = query })
					jestExpect(numBroadcasts).toEqual(0)
					proxy:writeQuery({
						data = { a = 4, b = 5, c = 6 },
						query = gql([[

              {
                a
                b
                c
              }
            ]]),
					})
					jestExpect(numBroadcasts).toEqual(0)
				end, 1 :: any)
				jestExpect(numBroadcasts).toEqual(1)
			end)
		end)
	end)

	-- ROBLOX TODO: requires jest.mock
	xdescribe("resultCacheMaxSize", function()
		local wrapSpy: JestMock = wrap :: JestMock
		beforeEach(function()
			wrapSpy:mockClear()
		end)

		it("does not set max size on caches if resultCacheMaxSize is not configured", function()
			InMemoryCache.new()
			jestExpect(wrapSpy).toHaveBeenCalled()
			Array.forEach(Array.splice(wrapSpy.mock.calls, 2), function(ref)
				local max = ref[2].max
				jestExpect(max).toBeUndefined()
			end)
		end)

		it("configures max size on caches when resultCacheMaxSize is set", function()
			local resultCacheMaxSize = 12345
			InMemoryCache.new({ resultCacheMaxSize = resultCacheMaxSize })
			jestExpect(wrapSpy).toHaveBeenCalled()
			Array.forEach(Array.splice(wrapSpy.mock.calls, 2), function(ref)
				local max = ref[2].max
				jestExpect(max).toBe(resultCacheMaxSize)
			end)
		end)
	end)

	describe("InMemoryCache#broadcastWatches", function()
		it("should keep distinct consumers distinct (issue #5733)", function()
			local cache = InMemoryCache.new()
			local query = gql([[

      query {
        value(arg: $arg) {
          name
        }
      }
    ]])

			local receivedCallbackResults: Array<Array<string | number | any>> = {}

			local nextWatchId = 1

			local function watch(arg: number)
				local watchId = ("id%s"):format(tostring(nextWatchId))
				nextWatchId += 1
				cache:watch({
					query = query,
					variables = { arg = arg },
					optimistic = false,
					callback = function(_self, result)
						table.insert(receivedCallbackResults, { watchId :: any, arg, result })
					end,
				})
				return watchId
			end

			local id1 = watch(1)

			jestExpect(receivedCallbackResults).toEqual({})

			local function write(arg: number, name: string)
				cache:writeQuery({
					query = query,
					variables = { arg = arg },
					data = {
						value = { name = name },
					},
				})
			end

			write(1, "one")

			local received1 = { id1 :: any, 1, { result = { value = { name = "one" } }, complete = true } }

			jestExpect(receivedCallbackResults).toEqual({ received1 })

			local id2 = watch(2)

			jestExpect(receivedCallbackResults).toEqual({ received1 })

			write(2, "two")

			local received2 = { id2 :: any, 2, { result = { value = { name = "two" } }, complete = true } }

			jestExpect(receivedCallbackResults).toEqual({
				received1,
				-- New results:
				received2,
			})

			local id3 = watch(1)
			local id4 = watch(1)

			write(1, "one")

			local received3 = {
				id3 :: any,
				1,
				{
					result = {
						value = {
							name = "one",
						},
					},
					complete = true,
				},
			}

			local received4 = {
				id4 :: any,
				1,
				{
					result = {
						value = {
							name = "one",
						},
					},
					complete = true,
				},
			}

			jestExpect(receivedCallbackResults).toEqual({
				received1,
				received2,
				-- New results:
				received3,
				received4,
			})

			write(2, "TWO")

			local received2AllCaps = {
				id2 :: any,
				2,
				{
					result = {
						value = {
							name = "TWO",
						},
					},
					complete = true,
				},
			}

			jestExpect(receivedCallbackResults).toEqual({
				received1,
				received2,
				received3,
				received4,
				-- New results:
				received2AllCaps,
			})
		end)
	end)

	describe("InMemoryCache#modify", function()
		it("should work with single modifier function", function()
			local cache = InMemoryCache.new()
			local query = gql([[

      query {
        a
        b
        c
      }
    ]])

			cache:writeQuery({
				query = query,
				data = {
					a = 0,
					b = 0,
					c = 0,
				},
			})

			local resultBeforeModify = cache:readQuery({ query = query })
			jestExpect(resultBeforeModify).toEqual({ a = 0, b = 0, c = 0 })

			cache:modify({
				-- Passing a function for options.fields is equivalent to invoking
				-- that function for all fields within the object.
				fields = function(_self, value: number, ref: { fieldName: string })
					local fieldName = ref.fieldName
					if fieldName == "a" then
						return value + 1
					elseif fieldName == "b" then
						return value - 1
					else
						return value
					end
				end,
			})

			jestExpect(cache:extract()).toEqual({
				ROOT_QUERY = {
					__typename = "Query",
					a = 1,
					b = -1,
					c = 0,
				},
			})

			local resultAfterModify = cache:readQuery({ query = query })
			jestExpect(resultAfterModify).toEqual({ a = 1, b = -1, c = 0 })
		end)

		it("should work with multiple modifier functions", function()
			local cache = InMemoryCache.new()
			local query = gql([[

      query {
        a
        b
        c
      }
    ]])
			cache:writeQuery({
				query = query,
				data = {
					a = 0,
					b = 0,
					c = 0,
				},
			})

			local resultBeforeModify = cache:readQuery({ query = query })
			jestExpect(resultBeforeModify).toEqual({ a = 0, b = 0, c = 0 })

			local checkedTypename = false
			cache:modify({
				fields = {
					a = function(_self, value: number)
						return value + 1
					end,
					b = function(_self, value: number)
						return value - 1
					end,
					__typename = function(_self, t: string, ref: { readField: ReadFieldFunction })
						jestExpect(t).toBe("Query")
						jestExpect(ref:readField("c")).toBe(0)
						checkedTypename = true
						return t
					end,
				},
			})
			jestExpect(checkedTypename).toBe(true)

			jestExpect(cache:extract()).toEqual({
				ROOT_QUERY = {
					__typename = "Query",
					a = 1,
					b = -1,
					c = 0,
				},
			})

			local resultAfterModify = cache:readQuery({ query = query })
			jestExpect(resultAfterModify).toEqual({ a = 1, b = -1, c = 0 })
		end)

		it("should allow invalidation using details.INVALIDATE", function()
			local cache = InMemoryCache.new({
				typePolicies = {
					Book = {
						keyFields = { "isbn" },
					},
					Author = {
						keyFields = { "name" },
					},
				},
			})

			local query: TypedDocumentNode<{ currentlyReading: { title: string, isbn: string, author: { name: string } } }, {
				[string]: any,
			}> =
				gql(
					[[

      query {
        currentlyReading {
          title
          isbn
          author {
            name
          }
        }
      }
    ]]
				)

			local currentlyReading = {
				__typename = "Book",
				isbn = "0374110034",
				title = "Beowulf: A New Translation",
				author = {
					__typename = "Author",
					name = "Maria Dahvana Headley",
				},
			}

			cache:writeQuery({
				query = query,
				data = {
					currentlyReading = currentlyReading,
				},
			})

			local function read()
				return cache:readQuery({ query = query }) :: any
			end

			local initialResult = read()

			jestExpect(cache:extract()).toMatchSnapshot()

			jestExpect(cache:modify({
				id = cache:identify({
					__typename = "Author",
					name = "Maria Dahvana Headley",
				}),
				fields = {
					name = function(_self, _, ref)
						return ref.INVALIDATE
					end,
				},
			})).toBe(false) -- Nothing actually modified.

			local resultAfterAuthorInvalidation = read()
			jestExpect(resultAfterAuthorInvalidation).toEqual(initialResult)
			jestExpect(resultAfterAuthorInvalidation).toBe(initialResult)

			jestExpect(cache:modify({
				id = cache:identify({
					__typename = "Book",
					isbn = "0374110034",
				}),
				-- Invalidate all fields of the Book entity.
				fields = function(_self, _, ref)
					return ref.INVALIDATE
				end,
			})).toBe(false) -- Nothing actually modified.

			local resultAfterBookInvalidation = read()
			jestExpect(resultAfterBookInvalidation).toEqual(resultAfterAuthorInvalidation)
			jestExpect(resultAfterBookInvalidation).toBe(resultAfterAuthorInvalidation)
			jestExpect(resultAfterBookInvalidation.currentlyReading.author).toEqual({
				__typename = "Author",
				name = "Maria Dahvana Headley",
			})
			jestExpect(resultAfterBookInvalidation.currentlyReading.author).toBe(
				resultAfterAuthorInvalidation.currentlyReading.author
			)
		end)

		it("should allow deletion using details.DELETE", function()
			local cache = InMemoryCache.new({
				typePolicies = {
					Book = {
						keyFields = { "isbn" },
					},
					Author = {
						keyFields = { "name" },
					},
				},
			})

			local query = gql([[

      query {
        currentlyReading {
          title
          isbn
          author {
            name
            yearOfBirth
          }
        }
      }
    ]])

			local currentlyReading = {
				__typename = "Book",
				isbn = "147670032X",
				title = "Why We're Polarized",
				author = {
					__typename = "Author",
					name = "Ezra Klein",
					yearOfBirth = 1983,
				},
			}

			cache:writeQuery({
				query = query,
				data = {
					currentlyReading = currentlyReading,
				},
			})

			jestExpect(cache:extract()).toEqual({
				ROOT_QUERY = {
					__typename = "Query",
					currentlyReading = {
						__ref = 'Book:{"isbn":"147670032X"}',
					},
				},
				['Book:{"isbn":"147670032X"}'] = {
					__typename = "Book",
					isbn = "147670032X",
					author = {
						__ref = 'Author:{"name":"Ezra Klein"}',
					},
					title = "Why We're Polarized",
				},
				['Author:{"name":"Ezra Klein"}'] = {
					__typename = "Author",
					name = "Ezra Klein",
					yearOfBirth = 1983,
				},
			})

			local authorId = cache:identify(currentlyReading.author) :: any
			jestExpect(authorId).toBe('Author:{"name":"Ezra Klein"}')

			cache:modify({
				id = authorId,
				fields = {
					yearOfBirth = function(_self, yob: number)
						return yob + 1
					end,
				},
			})

			-- ROBLOX TODO: fragments are not supported yet
			-- local yobResult = cache:readFragment({
			-- 	id = authorId,
			-- 	fragment = gql("fragment YOB on Author { yearOfBirth }"),
			-- })

			-- jestExpect(yobResult).toEqual({ __typename = "Author", yearOfBirth = 1984 })

			local bookId = cache:identify(currentlyReading) :: any

			-- Modifying the Book in order to modify the Author is fancier than
			-- necessary, but we want fancy use cases to work, too.
			cache:modify({
				id = bookId,
				fields = {
					author = function(_self, author: Reference, ref: { readField: ReadFieldFunction })
						jestExpect(ref:readField("title")).toBe("Why We're Polarized")
						jestExpect(ref:readField("name", author)).toBe("Ezra Klein")
						cache:modify({
							fields = {
								yearOfBirth = function(_self, yob, ref: { DELETE: any })
									local DELETE = ref.DELETE
									jestExpect(yob).toBe(1984)
									return DELETE
								end,
							},
							id = cache:identify({
								__typename = ref:readField("__typename", author),
								name = ref:readField("name", author),
							}),
						})
						return author
					end,
				},
			})

			local snapshotWithoutYOB = cache:extract()
			jestExpect((snapshotWithoutYOB[tostring(authorId)] :: any).yearOfBirth).toBeUndefined()
			jestExpect(Array.indexOf(Object.keys(snapshotWithoutYOB[tostring(authorId)] :: any), "yearOfBirth") ~= -1).toBe(
				false
			)
			jestExpect(snapshotWithoutYOB).toEqual({
				ROOT_QUERY = {
					__typename = "Query",
					currentlyReading = {
						__ref = 'Book:{"isbn":"147670032X"}',
					},
				},
				['Book:{"isbn":"147670032X"}'] = {
					__typename = "Book",
					isbn = "147670032X",
					author = {
						__ref = 'Author:{"name":"Ezra Klein"}',
					},
					title = "Why We're Polarized",
				},
				['Author:{"name":"Ezra Klein"}'] = {
					__typename = "Author",
					name = "Ezra Klein",
					-- yearOfBirth is gone now
				},
			})

			-- Delete the whole Book.
			cache:modify({
				id = bookId,
				fields = function(_self, _, ref)
					return ref.DELETE
				end,
			})

			local snapshotWithoutBook = cache:extract()
			jestExpect(snapshotWithoutBook[tostring(bookId)]).toBeUndefined()
			jestExpect(Array.indexOf(Object.keys(snapshotWithoutBook), tostring(bookId)) ~= -1).toBe(false)
			jestExpect(snapshotWithoutBook).toEqual({
				ROOT_QUERY = {
					__typename = "Query",
					currentlyReading = {
						__ref = 'Book:{"isbn":"147670032X"}',
					},
				},
				['Author:{"name":"Ezra Klein"}'] = {
					__typename = "Author",
					name = "Ezra Klein",
				},
			})

			-- Delete all fields of the Author, which also removes the object.
			cache:modify({
				id = authorId,
				fields = {
					__typename = function(_self, _, ref)
						return ref.DELETE
					end,
					name = function(_self, _, ref)
						return ref.DELETE
					end,
				},
			})

			local snapshotWithoutAuthor = cache:extract()
			jestExpect(snapshotWithoutAuthor[tostring(authorId)]).toBeUndefined()
			jestExpect(Array.indexOf(Object.keys(snapshotWithoutAuthor), authorId) ~= -1).toBe(false)
			jestExpect(snapshotWithoutAuthor).toEqual({
				ROOT_QUERY = {
					__typename = "Query",
					currentlyReading = {
						__ref = 'Book:{"isbn":"147670032X"}',
					},
				},
			})

			cache:modify({
				fields = function(_self, _, ref)
					return ref.DELETE
				end,
			})

			jestExpect(cache:extract()).toEqual({})
		end)

		it("can remove specific items from paginated lists", function()
			local cache = InMemoryCache.new({
				typePolicies = {
					Thread = {
						keyFields = { "tid" },
						fields = {
							comments = {
								merge = function(
									_self,
									existing: Array<Reference>,
									incoming: Array<Reference>,
									ref: FieldFunctionOptions<{ offset: number, limit: number }, Record<string, any>>
								)
									local args = ref.args :: { offset: number, limit: number }
									local merged
									if Boolean.toJSBoolean(existing) then
										merged = Array.slice(existing, 1)
									else
										merged = {}
									end
									local end_ = (args :: any).offset + math.min(args.limit, #incoming)
									local i = args.offset + 1
									while i <= end_ do
										merged[i] = ref:mergeObjects(merged[i], incoming[i - args.offset]) :: Reference
										i += 1
									end
									return merged
								end,
								read = function(_self, existing: Array<Reference>, ref): Array<Reference>?
									local args = ref.args
									local page
									if Boolean.toJSBoolean(existing) then
										page = Array.slice(
											existing,
											(args :: any).offset,
											(args :: any).offset + (args :: any).limit
										)
									else
										page = existing
									end
									if Boolean.toJSBoolean(page) and #page > 0 then
										return page
									end
									return
								end,
							},
						},
					},
					Comment = { keyFields = { "id" } },
				},
			})
			local query = gql([[

      query GetThread($offset: Int, $limit: Int) {
        thread {
          tid
          comments(offset: $offset, limit: $limit) {
            id
            text
          }
        }
      }
    ]])
			cache:writeQuery({
				query = query,
				data = {
					thread = {
						__typename = "Thread",
						tid = 123,
						comments = {
							{ __typename = "Comment", id = "c1", text = "first post" },
							{ __typename = "Comment", id = "c2", text = "I have thoughts" },
							{ __typename = "Comment", id = "c3", text = "friendly ping" },
						},
					},
				},
				variables = { offset = 0, limit = 3 },
			})
			jestExpect(cache:extract()).toEqual({
				ROOT_QUERY = { __typename = "Query", thread = { __ref = 'Thread:{"tid":123}' } },
				['Thread:{"tid":123}'] = {
					__typename = "Thread",
					tid = 123,
					comments = {
						{ __ref = 'Comment:{"id":"c1"}' },
						{ __ref = 'Comment:{"id":"c2"}' },
						{ __ref = 'Comment:{"id":"c3"}' },
					},
				},
				['Comment:{"id":"c1"}'] = { __typename = "Comment", id = "c1", text = "first post" },
				['Comment:{"id":"c2"}'] = { __typename = "Comment", id = "c2", text = "I have thoughts" },
				['Comment:{"id":"c3"}'] = { __typename = "Comment", id = "c3", text = "friendly ping" },
			})
			cache:modify({
				fields = {
					comments = function(_self, comments: Array<Reference>, ref)
						jestExpect(Object.isFrozen(comments)).toBe(true)
						jestExpect(#comments).toBe(3)
						local filtered = Array.filter(comments, function(comment)
							return ref:readField("id", comment) ~= "c1"
						end)
						jestExpect(#filtered).toBe(2)
						return filtered
					end,
				},
				id = cache:identify({ __typename = "Thread", tid = 123 }),
			})
			jestExpect(cache:gc()).toEqual({ 'Comment:{"id":"c1"}' })
			jestExpect(cache:extract()).toEqual({
				ROOT_QUERY = { __typename = "Query", thread = { __ref = 'Thread:{"tid":123}' } },
				['Thread:{"tid":123}'] = {
					__typename = "Thread",
					tid = 123,
					comments = { { __ref = 'Comment:{"id":"c2"}' }, { __ref = 'Comment:{"id":"c3"}' } },
				},
				['Comment:{"id":"c2"}'] = { __typename = "Comment", id = "c2", text = "I have thoughts" },
				['Comment:{"id":"c3"}'] = { __typename = "Comment", id = "c3", text = "friendly ping" },
			})
		end)

		it("should not revisit deleted fields", function()
			local cache = InMemoryCache.new()
			local query = gql("query { a b c }")

			cache:recordOptimisticTransaction(function(cache)
				cache:writeQuery({
					query = query,
					data = {
						a = 1,
						b = 2,
						c = 3,
					},
				})
			end, "transaction")

			cache:modify({
				fields = {
					b = function(_self, value, ref)
						local DELETE = ref.DELETE
						jestExpect(value).toBe(2)
						return DELETE
					end,
				},
				optimistic = true,
			})

			jestExpect(cache:extract(true)).toEqual({
				ROOT_QUERY = {
					__typename = "Query",
					a = 1,
					c = 3,
				},
			})

			cache:modify({
				fields = function(_self, value, ref)
					local fieldName = ref.fieldName
					jestExpect(fieldName).never.toBe("b")
					if fieldName == "a" then
						jestExpect(value).toBe(1)
					end
					if fieldName == "c" then
						jestExpect(value).toBe(3)
					end
				end,
				optimistic = true,
			})

			cache:removeOptimistic("transaction")

			jestExpect(cache:extract(true)).toEqual({})
		end)

		it("should broadcast watches for queries with changed fields", function()
			local cache = InMemoryCache.new()
			local queryA = gql("{ a { value } }")
			local queryB = gql("{ b { value } }")
			cache:writeQuery({ query = queryA, data = { a = { __typename = "A", id = 1, value = 123 } } })
			cache:writeQuery({ query = queryB, data = { b = { __typename = "B", id = 1, value = 321 } } })
			jestExpect(cache:extract()).toEqual({
				ROOT_QUERY = { __typename = "Query", a = { __ref = "A:1" }, b = { __ref = "B:1" } },
				["A:1"] = { __typename = "A", id = 1, value = 123 },
				["B:1"] = { __typename = "B", id = 1, value = 321 },
			})
			local aResults: Array<any> = {}
			cache:watch({
				query = queryA,
				optimistic = true,
				immediate = true,
				callback = function(_self, data)
					table.insert(aResults, data)
				end,
			})
			local bResults: Array<any> = {}
			cache:watch({
				query = queryB,
				optimistic = true,
				immediate = true,
				callback = function(_self, data)
					table.insert(bResults, data)
				end,
			})
			local function makeResult(__typename: string, value: number, complete: boolean?)
				if complete == nil then
					complete = true
				end
				return {
					complete = complete,
					result = {
						[string.lower(__typename)] = { __typename = __typename, value = value },
					},
				}
			end
			local a123 = makeResult("A", 123)
			local b321 = makeResult("B", 321)
			jestExpect(aResults).toEqual({ a123 })
			jestExpect(bResults).toEqual({ b321 })
			local aId = cache:identify({ __typename = "A", id = 1 })
			local bId = cache:identify({ __typename = "B", id = 1 })
			cache:modify({
				id = aId,
				fields = {
					value = function(self, x: number)
						return x + 1
					end,
				},
			})
			local a124 = makeResult("A", 124)
			jestExpect(aResults).toEqual({ a123, a124 })
			jestExpect(bResults).toEqual({ b321 })
			cache:modify({
				id = bId,
				fields = {
					value = function(self, x: number)
						return x + 1
					end,
				},
			})
			local b322 = makeResult("B", 322)
			jestExpect(aResults).toEqual({ a123, a124 })
			jestExpect(bResults).toEqual({ b321, b322 })
			jestExpect(cache:gc({ resetResultCache = true })).toEqual({})
			jestExpect(aResults).toEqual({ a123, a124 })
			jestExpect(bResults).toEqual({ b321, b322 });
			(cache :: any)["broadcastWatches"](cache)
			jestExpect(aResults).toEqual({ a123, a124 })
			jestExpect(bResults).toEqual({ b321, b322 })
		end)

		it("should handle argument-determined field identities", function()
			local cache = InMemoryCache.new({
				typePolicies = {
					Query = { fields = { book = { keyArgs = { "isbn" } } } },
					Book = { keyFields = { "isbn" } },
				},
			})
			local function addBook(isbn: string, title: string)
				cache:writeQuery({
					query = gql([[

          query {
            book(isbn: $isbn) {
              isbn
              title
            }
          }
        ]]),
					data = { book = { __typename = "Book", isbn = isbn, title = title } },
					variables = { isbn = isbn },
				})
			end
			addBook("147670032X", "Why We're Polarized")
			addBook("1760641790", "How To Do Nothing")
			addBook("0735211280", "Spineless")
			local fullSnapshot = {
				ROOT_QUERY = {
					__typename = "Query",
					['book:{"isbn":"0735211280"}'] = { __ref = 'Book:{"isbn":"0735211280"}' },
					['book:{"isbn":"147670032X"}'] = { __ref = 'Book:{"isbn":"147670032X"}' },
					['book:{"isbn":"1760641790"}'] = { __ref = 'Book:{"isbn":"1760641790"}' },
				},
				['Book:{"isbn":"147670032X"}'] = {
					__typename = "Book",
					isbn = "147670032X",
					title = "Why We're Polarized",
				},
				['Book:{"isbn":"1760641790"}'] = {
					__typename = "Book",
					isbn = "1760641790",
					title = "How To Do Nothing",
				},
				['Book:{"isbn":"0735211280"}'] = {
					__typename = "Book",
					isbn = "0735211280",
					title = "Spineless",
				},
			}
			jestExpect(cache:extract()).toEqual(fullSnapshot)
			local function check(isbnToDelete: string?)
				local bookCount = 0
				cache:modify({
					fields = {
						book = function(
							_self,
							book: Reference,
							ref: {
								fieldName: string,
								storeFieldName: string,
								isReference: (self: any, obj: any) -> boolean, -- typeof(isReference),
								readField: ReadFieldFunction,
								DELETE: any,
							}
						)
							local fieldName, storeFieldName, DELETE = ref.fieldName, ref.storeFieldName, ref.DELETE
							jestExpect(fieldName).toBe("book")
							jestExpect(ref:isReference(book)).toBe(true)
							jestExpect(typeof(ref:readField("title", book))).toBe("string")
							jestExpect(ref:readField("__typename", book)).toBe("Book")
							jestExpect(ref:readField({ fieldName = "__typename", from = book })).toBe("Book")
							local parts = String.split(storeFieldName, ":")
							jestExpect(table.remove(parts, 1)).toBe("book")
							local keyArgs = HttpService:JSONDecode(Array.join(parts, ":"))
							jestExpect(typeof(keyArgs.isbn)).toBe("string")
							jestExpect(Object.keys(keyArgs)).toEqual({ "isbn" })
							jestExpect(ref:readField("isbn", book)).toBe(keyArgs.isbn)
							if isbnToDelete == keyArgs.isbn then
								return DELETE
							end
							bookCount += 1
							return book
						end,
					},
				})
				return bookCount
			end
			jestExpect(check()).toBe(3)
			jestExpect(check()).toBe(3)
			jestExpect(check("0735211280")).toBe(2)
			jestExpect(check("147670032X")).toBe(1)
			jestExpect(check("0735211280")).toBe(1)
			jestExpect(check("147670032X")).toBe(1)
			jestExpect(cache:extract()).toEqual({
				ROOT_QUERY = {
					__typename = "Query",
					['book:{"isbn":"1760641790"}'] = { __ref = 'Book:{"isbn":"1760641790"}' },
				},
				['Book:{"isbn":"147670032X"}'] = {
					__typename = "Book",
					isbn = "147670032X",
					title = "Why We're Polarized",
				},
				['Book:{"isbn":"1760641790"}'] = {
					__typename = "Book",
					isbn = "1760641790",
					title = "How To Do Nothing",
				},
				['Book:{"isbn":"0735211280"}'] = {
					__typename = "Book",
					isbn = "0735211280",
					title = "Spineless",
				},
			})
			jestExpect(Array.sort(cache:gc())).toEqual({
				'Book:{"isbn":"0735211280"}',
				'Book:{"isbn":"147670032X"}',
			})
			jestExpect(cache:extract()).toEqual({
				ROOT_QUERY = {
					__typename = "Query",
					['book:{"isbn":"1760641790"}'] = { __ref = 'Book:{"isbn":"1760641790"}' },
				},
				['Book:{"isbn":"1760641790"}'] = {
					__typename = "Book",
					isbn = "1760641790",
					title = "How To Do Nothing",
				},
			})
			jestExpect(check("1760641790")).toBe(0)
			jestExpect(cache:extract()).toEqual({
				ROOT_QUERY = { __typename = "Query" },
				['Book:{"isbn":"1760641790"}'] = {
					__typename = "Book",
					isbn = "1760641790",
					title = "How To Do Nothing",
				},
			})
			jestExpect(cache:gc()).toEqual({ 'Book:{"isbn":"1760641790"}' })
			jestExpect(cache:extract()).toEqual({ ROOT_QUERY = { __typename = "Query" } })
		end)

		it("should modify ROOT_QUERY only when options.id absent", function()
			local cache = InMemoryCache.new()
			cache:writeQuery({ query = gql("query { field }"), data = { field = "oyez" } })
			local snapshot = { ROOT_QUERY = { __typename = "Query", field = "oyez" } }
			jestExpect(cache:extract()).toEqual(snapshot)
			local function check(id: any)
				jestExpect(cache:modify({
					id = id,
					fields = function(_self, value)
						error(Error.new(("unexpected value: %s"):format(value)))
					end,
				})).toBe(false)
			end
			-- ROBLOX deviation: hasOwnProperty cannot check for { [key] = nil }
			-- check(nil)
			check(false)
			check(NULL)
			check("")
			check("bogus:id")
			jestExpect(cache:extract()).toEqual(snapshot)
		end)
	end)

	describe("ReactiveVar and makeVar", function()
		local function makeCacheAndVar(
			resultCaching: boolean
		): { cache: InMemoryCache, nameVar: ReactiveVar<string>, query: DocumentNode }
			local nameVar = makeVar("Ben")
			local cache: InMemoryCache = InMemoryCache.new({
				resultCaching = resultCaching,
				typePolicies = {
					Person = { fields = {
						name = function()
							return nameVar()
						end,
					} },
				},
			})
			local query = gql([[

      query {
        onCall @client {
          name
        }
      }
    ]])
			cache:writeQuery({ query = query, data = { onCall = { __typename = "Person" } } })
			return { cache = cache, nameVar = nameVar, query = query }
		end

		it("should work with resultCaching enabled (default)", function()
			local ref = makeCacheAndVar(true)
			local cache, nameVar, query = ref.cache, ref.nameVar, ref.query

			local result1 = cache:readQuery({ query = query })
			jestExpect(result1).toEqual({
				onCall = {
					__typename = "Person",
					name = "Ben",
				},
			})

			-- No change before updating the nameVar.
			jestExpect(cache:readQuery({ query = query })).toBe(result1)

			jestExpect(nameVar()).toBe("Ben")
			jestExpect(nameVar("Hugh")).toBe("Hugh")

			local result2 = cache:readQuery({ query = query })
			jestExpect(result2).never.toBe(result1)
			jestExpect(result2).toEqual({
				onCall = {
					__typename = "Person",
					name = "Hugh",
				},
			})

			jestExpect(nameVar()).toBe("Hugh")
			jestExpect(nameVar("James")).toBe("James")

			jestExpect(cache:readQuery({ query = query })).toEqual({
				onCall = {
					__typename = "Person",
					name = "James",
				},
			})
		end)

		it("should work with resultCaching disabled (unusual)", function()
			local ref = makeCacheAndVar(false)
			local cache, nameVar, query = ref.cache, ref.nameVar, ref.query

			local result1 = cache:readQuery({ query = query })
			jestExpect(result1).toEqual({
				onCall = {
					__typename = "Person",
					name = "Ben",
				},
			})

			local result2 = cache:readQuery({ query = query })
			jestExpect(result2).toEqual(result1)
			jestExpect(result2).toBe(result1)

			jestExpect(nameVar()).toBe("Ben")
			jestExpect(nameVar("Hugh")).toBe("Hugh")

			local result3 = cache:readQuery({ query = query })
			jestExpect(result3).toEqual({
				onCall = {
					__typename = "Person",
					name = "Hugh",
				},
			})
		end)

		it("should forget cache once all watches are cancelled", function()
			local ref = makeCacheAndVar(false)
			local cache, nameVar, query = ref.cache :: any, ref.nameVar, ref.query

			--[[
				ROBLOX deviation:
				using jest.fn instead of jest.spyOn until spyOn is implemented
				original code:
				local spy = jest.spyOn(nameVar, "forgetCache")
			]]
			local originalForgetCache = nameVar.forgetCache
			local spy = jest.fn(nameVar.forgetCache)
			nameVar["forgetCache"] = function(_, ...)
				spy(...)
			end

			local diffs: Array<Cache_DiffResult<any>> = {}
			local function watch()
				return cache:watch({
					query = query,
					optimistic = true,
					immediate = true,
					callback = function(_self, diff)
						table.insert(diffs, diff)
					end,
				})
			end

			local unwatchers = {
				watch(),
				watch(),
				watch(),
				watch(),
				watch(),
			}

			jestExpect(#diffs).toBe(5)

			jestExpect(cache["watches"].size).toBe(5)
			jestExpect(spy).never.toBeCalled();

			(table.remove(unwatchers) :: any)()
			jestExpect(cache["watches"].size).toBe(4)
			jestExpect(spy).never.toBeCalled();

			(table.remove(unwatchers, 1) :: any)()
			jestExpect(cache["watches"].size).toBe(3)
			jestExpect(spy).never.toBeCalled();

			(table.remove(unwatchers) :: any)()
			jestExpect(cache["watches"].size).toBe(2)
			jestExpect(spy).never.toBeCalled()

			jestExpect(#diffs).toBe(5)
			table.insert(unwatchers, watch())
			jestExpect(#diffs).toBe(6)

			jestExpect(#unwatchers).toBe(3)
			Array.forEach(unwatchers, function(unwatch)
				return unwatch()
			end)

			jestExpect(cache["watches"].size).toBe(0)
			jestExpect(spy).toBeCalledTimes(1)
			jestExpect(spy).toBeCalledWith(cache)

			-- ROBLOX deviation: restoring original forgetCache function
			nameVar.forgetCache = originalForgetCache
		end)

		it("should recall forgotten vars once cache has watches again", function()
			local ref = makeCacheAndVar(false)
			local cache, nameVar, query = ref.cache :: any, ref.nameVar, ref.query

			--[[
				ROBLOX deviation:
				using jest.fn instead of jest.spyOn until spyOn is implemented
				original code:
				local spy = jest.spyOn(nameVar, "forgetCache")
			]]
			local originalForgetCache = nameVar.forgetCache
			local spy = jest.fn(nameVar.forgetCache)
			nameVar["forgetCache"] = function(_, ...)
				spy(...)
			end

			local diffs: Array<Cache_DiffResult<any>> = {}
			local function watch(immediate: boolean?)
				if immediate == nil then
					immediate = true
				end
				return cache:watch({
					query = query,
					optimistic = true,
					immediate = immediate,
					callback = function(_self, diff)
						table.insert(diffs, diff)
					end,
				})
			end

			local unwatchers = {
				watch(),
				watch(),
				watch(),
			}

			local function names()
				return Array.map(diffs, function(diff)
					return diff.result.onCall.name
				end)
			end

			jestExpect(#diffs).toBe(3)
			jestExpect(names()).toEqual({
				"Ben",
				"Ben",
				"Ben",
			})

			jestExpect(cache["watches"].size).toBe(3)
			jestExpect(spy).never.toBeCalled();

			(table.remove(unwatchers) :: any)()
			jestExpect(cache["watches"].size).toBe(2)
			jestExpect(spy).never.toBeCalled();

			(table.remove(unwatchers, 1) :: any)()
			jestExpect(cache["watches"].size).toBe(1)
			jestExpect(spy).never.toBeCalled()

			nameVar("Hugh")
			jestExpect(names()).toEqual({
				"Ben",
				"Ben",
				"Ben",
				"Hugh",
			});

			(table.remove(unwatchers) :: any)()
			jestExpect(cache["watches"].size).toBe(0)
			jestExpect(spy).toBeCalledTimes(1)
			jestExpect(spy).toBeCalledWith(cache)

			-- This update is ignored because the cache no longer has any watchers.
			nameVar("ignored")
			jestExpect(names()).toEqual({
				"Ben",
				"Ben",
				"Ben",
				"Hugh",
			})

			-- Call watch(false) to avoid immediate delivery of the "ignored" name.
			table.insert(unwatchers, watch(false))
			jestExpect(cache["watches"].size).toBe(1)
			jestExpect(names()).toEqual({
				"Ben",
				"Ben",
				"Ben",
				"Hugh",
			})

			-- This is the test that would fail if cache.watch did not call
			-- recallCache(cache) upon re-adding the first watcher.
			nameVar("Jenn")
			jestExpect(names()).toEqual({
				"Ben",
				"Ben",
				"Ben",
				"Hugh",
				"Jenn",
			})

			Array.forEach(unwatchers, function(cancel)
				return cancel()
			end)
			jestExpect(spy).toBeCalledTimes(2)
			jestExpect(spy).toBeCalledWith(cache)

			-- Ignored again because all watchers have been cancelled.
			nameVar("also ignored")
			jestExpect(names()).toEqual({
				"Ben",
				"Ben",
				"Ben",
				"Hugh",
				"Jenn",
			})

			-- ROBLOX deviation: restoring original forgetCache function
			nameVar.forgetCache = originalForgetCache
		end)

		it("should broadcast only once for multiple reads of same variable", function()
			local nameVar = makeVar("Ben")
			local cache = InMemoryCache.new({
				typePolicies = {
					Query = { fields = {
						name = function()
							return nameVar()
						end,
					} },
				},
			})
			cache:restore({ ROOT_QUERY = {} })
			local broadcast = (cache :: any)["broadcastWatches"]
			local broadcastCount = 0;
			(cache :: any)["broadcastWatches"] = function(self, ...)
				broadcastCount += 1
				return broadcast(self, ...)
			end
			local query = gql([[

      query {
        name1: name
        name2: name
      }
    ]])
			local watchDiffs: Array<Cache_DiffResult<any>> = {}
			cache:watch({
				query = query,
				optimistic = true,
				callback = function(_self, diff)
					table.insert(watchDiffs, diff)
				end,
			})
			local benResult = cache:readQuery({ query = query })
			jestExpect(benResult).toEqual({ name1 = "Ben", name2 = "Ben" })
			jestExpect(watchDiffs).toEqual({})
			jestExpect(broadcastCount).toBe(0)
			nameVar("Jenn")
			jestExpect(broadcastCount).toBe(1)
			local jennResult = cache:readQuery({ query = query })
			jestExpect(jennResult).toEqual({ name1 = "Jenn", name2 = "Jenn" })
			jestExpect(watchDiffs).toEqual({ { complete = true, result = { name1 = "Jenn", name2 = "Jenn" } } })
			jestExpect(broadcastCount).toBe(1)
			nameVar("Hugh")
			jestExpect(broadcastCount).toBe(2)
			local hughResult = cache:readQuery({ query = query })
			jestExpect(hughResult).toEqual({ name1 = "Hugh", name2 = "Hugh" })
			jestExpect(watchDiffs).toEqual({
				{ complete = true, result = { name1 = "Jenn", name2 = "Jenn" } },
				{ complete = true, result = { name1 = "Hugh", name2 = "Hugh" } },
			})
		end)

		it("should broadcast to manually added caches", function()
			local rv = makeVar(0) :: ReactiveVar<number>
			local cache = InMemoryCache.new()
			local query = gql("query { value }")
			local diffs: Array<Cache_DiffResult<any>> = {}
			local watch: Cache_WatchOptions<Watcher_> = {
				query = query,
				optimistic = true,
				callback = function(_self, diff)
					table.insert(diffs, diff)
				end,
			}
			cache:writeQuery({ query = query, data = { value = "oyez" } })
			local cancel = cache:watch(watch)
			rv(rv() + 1)
			jestExpect(diffs).toEqual({})
			rv:attachCache(cache)(rv() + 1)
			jestExpect(diffs).toEqual({ { complete = true, result = { value = "oyez" } } })
			cache:writeQuery({ query = query, broadcast = false, data = { value = "oyez, oyez" } })
			jestExpect(diffs).toEqual({ { complete = true, result = { value = "oyez" } } })
			rv(rv() + 1)
			jestExpect(diffs).toEqual({
				{ complete = true, result = { value = "oyez" } },
				{ complete = true, result = { value = "oyez, oyez" } },
			})
			jestExpect(rv:forgetCache(cache)).toBe(true)
			cache:writeQuery({ query = query, broadcast = false, data = { value = "oyez, oyez, oyez" } })
			rv(rv() + 1)
			jestExpect(diffs).toEqual({
				{ complete = true, result = { value = "oyez" } },
				{ complete = true, result = { value = "oyez, oyez" } },
			});
			(cache :: any)["broadcastWatches"](cache)
			jestExpect(diffs).toEqual({
				{ complete = true, result = { value = "oyez" } },
				{ complete = true, result = { value = "oyez, oyez" } },
				{ complete = true, result = { value = "oyez, oyez, oyez" } },
			})
			cancel()
			jestExpect(rv()).toBe(4)
		end)
	end)

	describe("TypedDocumentNode<Data, Variables>", function()
		type Book = { isbn: string?, title: string, author: { name: string } }
		local query: TypedDocumentNode<{ book: Book }, { isbn: string }> = gql([[query GetBook($isbn: String!) {
    book(isbn: $isbn) {
      title
      author {
        name
      }
    }
  }]])
		-- ROBLOX TODO: fragments are not supported yet
		-- 		local fragment: TypedDocumentNode<Book, { [string]: any }> = gql([[

		--     fragment TitleAndAuthor on Book {
		--       title
		--       isbn
		--       author {
		--         name
		--       }
		--     }
		--   ]])
		it("should determine Data and Variables types of {write,read}{Query,Fragment}", function()
			local cache = InMemoryCache.new({
				typePolicies = {
					Query = {
						fields = {
							book = function(self, existing, ref)
								local args, toReference = ref.args, ref.toReference
								if existing ~= nil then
									return existing
								else
									if Boolean.toJSBoolean(args) then
										return toReference({
											__typename = "Book",
											isbn = args.isbn,
										})
									else
										return args
									end
								end
							end,
						},
					},
					Book = { keyFields = { "isbn" } },
					Author = { keyFields = { "name" } },
				},
			})
			local jcmAuthor = { __typename = "Author", name = "John C. Mitchell" }
			local ffplBook = {
				__typename = "Book",
				isbn = "0262133210",
				title = "Foundations for Programming Languages",
				author = jcmAuthor,
			}
			local ffplVariables = { isbn = "0262133210" }
			cache:writeQuery({ query = query, variables = ffplVariables, data = { book = ffplBook } })
			jestExpect(cache:extract()).toMatchSnapshot()
			local ffplQueryResult = cache:readQuery({ query = query, variables = ffplVariables })
			if ffplQueryResult == nil then
				error(Error.new("null result"))
			end
			jestExpect(ffplQueryResult.book.isbn).toBeUndefined()
			jestExpect(ffplQueryResult.book.author.name).toBe(jcmAuthor.name)
			jestExpect(ffplQueryResult).toEqual({
				book = {
					__typename = "Book",
					title = "Foundations for Programming Languages",
					author = { __typename = "Author", name = "John C. Mitchell" },
				},
			})
			-- ROBLOX TODO: fragments are not supported yet
			-- local sicpBook = {
			-- 	__typename = "Book",
			-- 	isbn = "0262510871",
			-- 	title = "Structure and Interpretation of Computer Programs",
			-- 	author = { __typename = "Author", name = "Harold Abelson" },
			-- }
			-- local sicpRef = cache:writeFragment({ fragment = fragment, data = sicpBook })
			-- jestExpect(isReference(sicpRef)).toBe(true)
			-- jestExpect(cache:extract()).toMatchSnapshot()

			-- local ffplFragmentResult = cache:readFragment({
			-- 	fragment = fragment,
			-- 	id = cache:identify(ffplBook),
			-- })
			-- if ffplFragmentResult == nil then
			-- 	error(Error.new("null result"))
			-- end
			-- jestExpect(ffplFragmentResult.title).toBe(ffplBook.title)
			-- jestExpect(ffplFragmentResult.author.name).toBe(ffplBook.author.name)
			-- jestExpect(ffplFragmentResult).toEqual(ffplBook)
			-- local sicpReadResult = cache:readQuery({
			-- 	query = query,
			-- 	variables = { isbn = sicpBook.isbn },
			-- })
			-- if sicpReadResult == nil then
			-- 	error(Error.new("null result"))
			-- end
			-- jestExpect(sicpReadResult.book.isbn).toBeUndefined()
			-- jestExpect(sicpReadResult.book.title).toBe(sicpBook.title)
			-- jestExpect(sicpReadResult.book.author.name).toBe(sicpBook.author.name)
			-- jestExpect(sicpReadResult).toEqual({
			-- 	book = {
			-- 		__typename = "Book",
			-- 		title = "Structure and Interpretation of Computer Programs",
			-- 		author = { __typename = "Author", name = "Harold Abelson" },
			-- 	},
			-- })
		end)
	end)
end
