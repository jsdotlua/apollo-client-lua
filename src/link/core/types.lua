-- ROBLOX upstream: https://github.com/apollographql/apollo-client/blob/v3.4.0-rc.17/src/link/core/types.ts
local exports = {}
type Record<T, U> = { [T]: U }

local srcWorkspace = script.Parent.Parent.Parent
local rootWorkspace = srcWorkspace.Parent
local graphqlModule = require(rootWorkspace.GraphQL)
export type DocumentNode = graphqlModule.DocumentNode
type ExecutionResult = graphqlModule.ExecutionResult
local utilitiesModule = require(script.Parent.Parent.Parent.utilities)
type Observable<T> = utilitiesModule.Observable<T>

export type GraphQLRequest = {
	query: DocumentNode,
	variables: Record<string, any>?,
	operationName: string?,
	context: Record<string, any>?,
	extensions: Record<string, any>?,
}
export type Operation = {
	query: DocumentNode,
	variables: Record<string, any>,
	operationName: string,
	extensions: Record<string, any>,
	setContext: ((
		self: Operation,
		context: (Record<string, any> | ((Record<string, any>) -> Record<string, any>)) -- ROBLOX deviation: second param needs to be union with function because functions are not tables in Lua
	) -> Record<string, any>),
	getContext: ((self: Operation) -> Record<string, any>),
}
export type FetchResult<TData, C, E> = ExecutionResult & { data: (TData | nil)?, extensions: E?, context: C? }

export type NextLink = ((
	operation: Operation
) -> Observable<FetchResult<{ [string]: any }, Record<string, any>, Record<string, any>>>)

export type RequestHandler = (
	self: any, -- ApolloLink
	operation: Operation,
	forward: NextLink
) -> Observable<FetchResult<{ [string]: any }, Record<string, any>, Record<string, any>>> | nil

return exports
