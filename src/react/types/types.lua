-- ROBLOX upstream: https://github.com/apollographql/apollo-client/blob/v3.4.0-rc.17/src/react/types/types.ts
local srcWorkspace = script.Parent.Parent.Parent
local rootWorkspace = srcWorkspace.Parent

type Record<T, U> = { [T]: U }
type Array<T> = { [number]: T }
type Object = { [string]: any }
-- ROBLOX deviation: Promise isn't supported
type Promise<T> = any
type JSX_Element = any
type ZenObservable_Subscription = any

local RoactModule = require(rootWorkspace.Roact)
type ReactNode = RoactModule.ReactNode
local GraphQLModule = require(rootWorkspace.GraphQL)
type DocumentNode = GraphQLModule.DocumentNode
-- ROBLOX TODO: use import when TypedDocumentNode is imported
-- local TypedDocumentNode = require(Packages.@graphql-typed-document-node.core).TypedDocumentNode
type TypedDocumentNode<TData, TVariables> = any
local coreModule = require(srcWorkspace.core)

-- ROBLOX TODO: use import when Observable is imported
-- local Observable = require(script.Parent.Parent.Parent.utilities).Observable
type Observable<T> = any

-- ROBLOX TODO: use import when FetchResult is imported
-- local FetchResult = require(script.Parent.Parent.Parent.link.core).FetchResult
type FetchResult<TData> = any

-- ROBLOX TODO use import when ApolloError is imported
-- local ApolloError = require(script.Parent.Parent.Parent.errors).ApolloError
type ApolloError = any

-- ROBLOX TODO: use import when ApolloCache is imported
-- local ApolloCache = coreModule.ApolloCache
type ApolloCache = any

local apolloClientModule = require(srcWorkspace.core.ApolloClient)
type ApolloClient<TCacheShape> = apolloClientModule.ApolloClient<TCacheShape>

-- ROBLOX TODO use import when ApolloQueryResult is imported
-- local ApolloQueryResult = coreModule.ApolloQueryResult
type ApolloQueryResult<TData> = any

-- ROBLOX TODO use import when DefaultContext is imported
-- local DefaultContext = coreModule.DefaultContext
type DefaultContext = any

-- ROBLOX TODO use import when FetchMoreOptions is imported
-- local FetchMoreOptions = coreModule.FetchMoreOptions
type FetchMoreOptions<TData, TVariables> = any

-- ROBLOX TODO use import when FetchMoreQueryOptions is imported
-- local FetchMoreQueryOptions = coreModule.FetchMoreQueryOptions
type FetchMoreQueryOptions<TVariables, TData> = any

-- ROBLOX TODO use import when FetchPolicy is imported
-- local FetchPolicy = coreModule.FetchPolicy
type FetchPolicy = any

-- ROBLOX TODO use import when MutationOptions is imported
-- local MutationOptions = coreModule.MutationOptions
type MutationOptions<TData, TVariables, TContext, TCache> = any

-- ROBLOX TODO: use import when NetworkStatus is imported
-- local NetworkStatus = coreModule.NetworkStatus
type NetworkStatus = any

-- ROBLOX TODO use import when ObservableQuery is implemented
-- local ObservableQuery = coreModule.ObservableQuery
type ObservableQuery = any

-- ROBLOX TODO use import when OperationVariables is imported
-- local OperationVariables = coreModule.OperationVariables
type OperationVariables = any

-- ROBLOX TODO use import when InternalRefetchQueriesInclude is imported
-- local InternalRefetchQueriesInclude = coreModule.InternalRefetchQueriesInclude
type InternalRefetchQueriesInclude = any

-- ROBLOX TODO use import when WatchQueryOptions is imported
-- local WatchQueryOptions = coreModule.WatchQueryOptions
type WatchQueryOptions = any

--[[ Common types ]]

export type Context = DefaultContext

export type CommonOptions<TOptions> = TOptions & { client: ApolloClient<Object>? }

--[[ Query types ]]

-- ROBLOX TODO: when we port over WatchQueryOptions we should implement the omitted version of it
export type BaseQueryOptionsWithoutWatchQueryOptions<TVariables> = any

--[[ ROBLOX deviation: there are no default generic params in Luau: `TVariables = OperationVariables` ]]
export type BaseQueryOptions<TVariables> =
	BaseQueryOptionsWithoutWatchQueryOptions<TVariables> & { ssr: boolean?, client: ApolloClient<any>?, context: DefaultContext? }

--[[ ROBLOX deviation: there are no default generic params in Luau: `<
  TData = any,
  TVariables = OperationVariables
>` ]]
export type QueryFunctionOptions<TData, TVariables> = BaseQueryOptions<TVariables> & {
	displayName: string?,
	skip: boolean?,
	onCompleted: ((TData) -> ())?,
	onError: ((ApolloError) -> ())?,
}

-- ROBLOX deviation: implements a version of pick for ObservableQuery
type ObservableQueryPick<TData, TVariables> = {
	startPolling: any,
	stopPolling: any,
	subscribeToMore: any,
	updateQuery: any,
	refetch: any,
	variables: any,
}

export type ObservableQueryFields<TData, TVariables> = ObservableQueryPick<TData, TVariables> & {
	fetchMore: ((
		FetchMoreQueryOptions<TVariables, TData> & FetchMoreOptions<TData, TVariables>
	) -> Promise<ApolloQueryResult<TData>>) & ((
		{ query: (DocumentNode | TypedDocumentNode<TData, TVariables>)? } & FetchMoreQueryOptions<TVariables2, TData> & FetchMoreOptions<TData2, TVariables2>
	) -> Promise<ApolloQueryResult<TData2>>),
}

--[[ ROBLOX deviation: there are no default generic params in Luau: `<TData = any, TVariables = OperationVariables>` ]]
export type QueryResult<TData, TVariables> = ObservableQueryFields<TData, TVariables> & {
	client: ApolloClient<any>,
	data: TData | nil,
	previousData: TData?,
	error: ApolloError?,
	loading: boolean,
	networkStatus: NetworkStatus,
	-- ROBLOX deviation: using `boolean` instead of `true`
	called: boolean,
}

--[[ ROBLOX deviation: there are no default generic params in Luau: `<TData = any, TVariables = OperationVariables>` ]]
export type QueryDataOptions<TData, TVariables> = QueryFunctionOptions<TData, TVariables> & {
	children: ((QueryResult<TData, TVariables>) -> ReactNode)?,
	query: DocumentNode | TypedDocumentNode<TData, TVariables>,
}

--[[ ROBLOX deviation: there are no default generic params in Luau: `<TData = any, TVariables = OperationVariables>` ]]
export type QueryHookOptions<TData, TVariables> =
	QueryFunctionOptions<TData, TVariables> & { query: (DocumentNode | TypedDocumentNode<TData, TVariables>)? }

-- ROBLOX deviation: implements a version of skip for QueryFunctionOptions
export type QueryFunctionOptionsWithoutSkip<TData, TVariables> = BaseQueryOptions<TVariables> & {
	displayName: string?,
	onCompleted: ((TData) -> ())?,
	onError: ((ApolloError) -> ())?,
}

--[[ ROBLOX deviation: there are no default generic params in Luau: `<TData = any, TVariables = OperationVariables>` ]]
export type LazyQueryHookOptions<TData, TVariables> = QueryFunctionOptionsWithoutSkip<TData, TVariables> & {
	query: (DocumentNode | TypedDocumentNode<TData, TVariables>)?,
}

export type QueryLazyOptions<TVariables> = { variables: TVariables?, context: DefaultContext? }

--[[ ROBLOX deviation: original types -> {
  loading: false;
  networkStatus: NetworkStatus.ready;
  called: false;
  data: undefined;
  previousData?: undefined;
} ]]
type UnexecutedLazyFields = { loading: boolean, networkStatus: any, called: boolean, data: nil, previousData: any? }

-- ROBLOX deviation: not native to lua and was resolved with QueryResultWithoutUnexceutedLazyField
-- type Impartial<T> = {
-- P in keyof T: never?
-- }

-- ROBLOX deviation: remove UnexecutedLazyFields types from new QueryResult, make other types optional or nil
-- type AbsentLazyResultFields =
--   Omit<
--     Impartial<QueryResult<unknown, unknown>>,
--     keyof UnexecutedLazyFields>

-- ROBLOX deviation: implements a version of omit for QueryResult
export type QueryResultWithoutUnexceutedLazyField<TData, TVariables> = ObservableQueryFields<TData, TVariables> & {
	-- client: ApolloClient<any> | nil?,
	client: nil?,
	-- error: ApolloError | nil?,
	error: nil?,
}

type AbsentLazyResultFields<TData, TVariables> = QueryResultWithoutUnexceutedLazyField<TData, TVariables>

type UnexecutedLazyResult<TData, TVariables> = UnexecutedLazyFields & AbsentLazyResultFields<TData, TVariables>

export type LazyQueryResult<TData, TVariables> = UnexecutedLazyResult<TData, TVariables> | QueryResult<TData, TVariables>

--[[ 
	ROBLOX deviation: no way to type a tuple in Luau. Adding a similar concept of a tuple as a return type of function.
	original type:
	export type QueryTuple<TData, TVariables> = [
	  (options?: QueryLazyOptions<TVariables>) => void,
	  LazyQueryResult<TData, TVariables>
	];
]]
export type QueryTupleAsReturnType<TData, TVariables> = (
	...any
) -> (((QueryLazyOptions<TVariables>) -> ()), LazyQueryResult<TData, TVariables>)

-- /* Mutation types */

export type RefetchQueriesFunction = (...any) -> InternalRefetchQueriesInclude

-- ROBLOX TODO: when we port over MutationOptions we should implement the omitted version of it
export type MutationOptionsWithoutMutationProperty<TData, TVariables, TContext, TCache> = any

--[[ ROBLOX deviation: there are no default generic params in Luau: `<TData, TVariables extends OperationVariables, TCache extends ApolloCache<any> = ApolloCache<any>>` ]]
export type BaseMutationOptions<TData, TVariables, TContext, TCache> = MutationOptionsWithoutMutationProperty<TData, TVariables, TContext, TCache> & {
	client: ApolloClient<Object>?,
	notifyOnNetworkStatusChange: boolean?,
	onCompleted: ((TData) -> ())?,
	onError: ((ApolloError) -> ())?,
	ignoreResults: boolean?,
}

--[[ ROBLOX deviation: there are no default generic params in Luau: `<TData, TVariables, TContext, TCache extends ApolloCache<any>,` ]]
type MutationFunctionOptions<TData, TVariables, TContext, TCache> = BaseMutationOptions<TData, TVariables, TContext, TCache> & {
	mutation: (DocumentNode | TypedDocumentNode<TData, TVariables>)?,
}

--[[ ROBLOX deviation: there are no default generic params in Luau: `<TData = any>` ]]
export type MutationResult<TData> = {
	data: (TData | nil)?,
	error: ApolloError?,
	loading: boolean,
	called: boolean,
	client: ApolloClient<Object>,
}

--[[ ROBLOX deviation: there are no default generic params in Luau: `<TData = any, TVariables = OperationVariables, TContext = DefaultContext, TCache extends ApolloCache<any> = ApolloCache<any>,` ]]
export type MutationFunction<TData, TVariables, TContext, TCache> = (
	MutationFunctionOptions<TData, TVariables, TContext, TCache>?
) -> Promise<FetchResult<TData>>

--[[ ROBLOX deviation: there are no default generic params in Luau: `<TData = any, TVariables = OperationVariables, TContext = DefaultContext, TCache extends ApolloCache<any> = ApolloCache<any>,` ]]
export type MutationHookOptions<TData, TVariables> = BaseMutationOptions<TData, TVariables, TContext, TCache> & {
	mutation: (DocumentNode | TypedDocumentNode<TData, TVariables>)?,
}

--[[ ROBLOX deviation: there are no default generic params in Luau: `<TData, TVariables extends OperationVariables, TContext extends DefaultContext, TCache extends ApolloCache<any>,` ]]
export type MutationDataOptions<TData, TVariables, TContext, TCache> = BaseMutationOptions<TData, TVariables, TContext, TCache> & { BaseMutationOptions<TData, TVariables, TContext, TCache> & {
	mutation: DocumentNode | TypedDocumentNode<TData, TVariables>,
} }

--[[ ROBLOX deviation: no way to type a tuple in Luau. Adding a similar concept of a tuple as a return type of function.
	original type:
 export type MutationTuple<TData, TVariables, TContext, TCache extends ApolloCache<any>> = [
   (
     options?: MutationFunctionOptions<TData, TVariables, TContext, TCache>
  ) => Promise<FetchResult<TData>>,
   MutationResult<TData>
 ];
]]
export type MutationTupleAsReturnType<TData, TVariables, TContext, TCache> =
	(
	...any
) -> (((MutationFunctionOptions<TData, TVariables, TContext, TCache>) -> Promise<FetchResult<TData>>), MutationResult<TData>)

--[[ Subscription types ]]

--[[ ROBLOX deviation: there are no default generic params in Luau: `<TData = any>` ]]
export type OnSubscriptionDataOptions<TData> = {
	client: ApolloClient<Object>,
	subscriptionData: SubscriptionResult<TData>,
}

--[[ ROBLOX deviation: there are no default generic params in Luau: `<TData = any, TVariables = OperationVariables>` ]]
export type BaseSubscriptionOptions<TData, TVariables> = {
	variables: TVariables?,
	fetchPolicy: FetchPolicy?,
	shouldResubscribe: (boolean | ((BaseSubscriptionOptions<TData, TVariables>) -> boolean))?,
	client: ApolloClient<Object>?,
	skip: boolean?,
	context: DefaultContext?,
	onSubscriptionData: ((OnSubscriptionDataOptions<TData>) -> any)?,
	onSubscriptionComplete: (() -> ())?,
}

--[[ ROBLOX deviation: there are no default generic params in Luau: `<TData = any>` ]]
export type SubscriptionResult<TData> = { loading: boolean, data: TData?, error: ApolloError? }

--[[ ROBLOX deviation: there are no default generic params in Luau: `<TData = any, TVariables = OperationVariables>` ]]
export type SubscriptionHookOptions<TData, TVariables> = BaseSubscriptionOptions<TData, TVariables> & {
	subscription: (DocumentNode | TypedDocumentNode<TData, TVariables>)?,
}

--[[ ROBLOX deviation: there are no default generic params in Luau: `<TData = any, TVariables = OperationVariables>` ]]
export type SubscriptionDataOptions<TData, TVariables> = BaseSubscriptionOptions<TData, TVariables> & {
	subscription: DocumentNode | TypedDocumentNode<TData, TVariables>,
	children: (nil | ((SubscriptionResult<TData>) -> JSX_Element | nil))?,
}

export type SubscriptionCurrentObservable = { query: Observable<T>?, subscription: ZenObservable_Subscription? }

return {}
