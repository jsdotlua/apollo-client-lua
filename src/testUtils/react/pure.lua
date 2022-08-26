-- ROBLOX upstream: https://github.com/testing-library/react-testing-library/blob/12.1.2/src/pure.js

local srcWorkspace = script.Parent.Parent.Parent
local rootWorkspace = srcWorkspace.Parent

local LuauPolyfill = require(rootWorkspace.LuauPolyfill)
local Error = LuauPolyfill.Error
local Object = LuauPolyfill.Object
local Promise = require(rootWorkspace.Promise)

local React = require(rootWorkspace.React)
type ReactElement<P, T> = React.ReactElement<P, T>
local ReactRoblox = require(rootWorkspace.ReactRoblox)

-- ROBLOX deviation: not converting react-dom
-- local ReactDOM = require(Packages["react-dom"]).default

local domModule = require(script.Parent.Parent.dom)
-- ROBLOX deviation: not converting these parts of dom testing lib
-- local getQueriesForElement = domModule.getQueriesForElement
-- local prettyDOM = domModule.prettyDOM
local configureDTL = domModule.configure
-- local fireEvent = require(script.Parent.["fire-event"]

local actCompatModule = require(script.Parent["act-compat"])
local act = actCompatModule.default

local asyncAct = actCompatModule.asyncAct

local exports = {}

type GenericObject = { [string]: any }

configureDTL({
	asyncWrapper = function(cb: (...any) -> ...any)
		return Promise.resolve():andThen(function()
			local result
			Promise.resolve()
				:andThen(function()
					return asyncAct(function()
						return Promise.resolve():andThen(function()
							result = cb():expect()
						end)
					end)
				end)
				:expect()
			return result
		end)
	end,
	eventWrapper = function(cb)
		local result
		act(function()
			result = cb()
		end)
		return result
	end,
})

-- ROBLOX deviation: instead of importing getQueriesForElement, we are defining it here
local function getQueriesForElement(rootInstance: Instance)
	return {
		getByText = function(text: string): Instance
			local descendants = rootInstance:GetDescendants()
			for _index, descendant in ipairs(descendants) do
				if descendant.Text == text then
					return descendant
				end
			end
			error(Error.new(("Unable to find an element with the text: %s"):format(text)))
		end,
		getAllByText = function(text: string): { Instance }
			local results = {}
			local descendants = rootInstance:GetDescendants()
			for _index, descendant in ipairs(descendants) do
				if descendant.Text == text then
					table.insert(results, descendant)
				end
			end
			if #results == 0 then
				error(Error.new(("Unable to find an element with the text: %s"):format(text)))
			end
			return results
		end,
		getFirstChild = function(): Instance
			return rootInstance:GetChildren()[1]
		end,
	}
end

-- ROBLOX deviation: using a table instead of Set
-- local mountedContainers = Set.new()
local mountedContainers = {}

type Container = any

type RenderOptions = {
	-- RenderOptions properties
	container: Container?,
	baseElement: GenericObject?,
	queries: any?,
	hydrate: boolean?,
	wrapper: GenericObject?,
}

local rootInstance: Instance?

local function render(ui: any, renderOptions: RenderOptions?)
	local assertedRenderOptions = renderOptions :: RenderOptions
	local container = assertedRenderOptions and assertedRenderOptions.container
	-- ROBLOX deviation: we aren't using baseElement for querying yet
	-- local baseElement = assertedRenderOptions.baseElement or container
	-- ROBLOX deviation: we arent using queries
	-- local queries = assertedRenderOptions.queries
	-- ROBLOX deviation: we aren't using hydrate
	-- local hydrate = assertedRenderOptions and assertedRenderOptions.hydrate or false
	local WrapperComponent = assertedRenderOptions and assertedRenderOptions.wrapper

	--[[
    if (!baseElement) {
      // default to document.body instead of documentElement to avoid output of potentially-large
      // head elements (such as JSS style blocks) in debug output
      baseElement = document.body
    }
  ]]

	if not container then
		rootInstance = Instance.new("Folder") :: Folder;
		(rootInstance :: Folder).Name = "GuiRoot"
		container = ReactRoblox.createLegacyRoot(rootInstance :: Instance)
	else
		rootInstance = container and container._internalRoot and container._internalRoot.containerInfo
	end

	table.insert(mountedContainers, container)

	local function wrapUiIfNeeded(innerElement): any
		if WrapperComponent ~= nil then
			return React.createElement(WrapperComponent :: any, nil, innerElement) :: any
		else
			return innerElement :: any
		end
	end

	-- ROBLOX deviation: not using hydrate, not fully supported in ReactRoblox
	act(function()
		if container.render ~= nil then
			container:render(wrapUiIfNeeded(ui))
		end
	end)

	-- ROBLOX Luau FIXME: Luau doesn't track the keys through Object.assign()
	local queriesForElement = getQueriesForElement(rootInstance :: Instance)

	return {
		container = container,
		-- ROBLOX deviation: we aren't using baseElement for querying
		-- baseElement = baseElement,
		-- ROBLOX deviation: not including debug function, havent converted prettyDOM
		-- debug = function(el, maxLength, options)
		-- 	if el == nil then
		-- 		el = baseElement
		-- 	end
		-- 	if Array.isArray(el) then
		-- 		return Array.forEach(el, function(e)
		-- 			return console.log(prettyDOM(e, maxLength, options))
		-- 		end)
		-- 	else
		-- 		return console:log(prettyDOM(el, maxLength, options))
		-- 	end
		-- end,
		-- ROBLOX deviation: using ReactRoblox's root's unmount function
		unmount = function()
			act(function()
				container:unmount()
			end)
		end,
		rerender = function(rerenderUi)
			render(wrapUiIfNeeded(rerenderUi), { container = container })
			-- Intentionally do not return anything to avoid unnecessarily complicating the API.
			-- folks can use all the same utilities we return in the first place that are bound to the container
		end,
		-- ROBLOX deviation: not using asFragment
		-- asFragment = function()
		-- 	if typeof(document.createRange) == "function" then
		-- 		return document:createRange():createContextualFragment(container.innerHTML)
		-- 	else
		-- 		local template = document:createElement("template")
		-- 		template.innerHTML = container.innerHTML
		-- 		return template.content
		--  end
		-- end,
		-- ROBLOX deviation: manually expand these, since Luau can't track the keys through Object.assign()
		getByText = queriesForElement.getByText,
		getAllByText = queriesForElement.getAllByText,
		getFirstChild = queriesForElement.getFirstChild,
	}
end
exports.render = render

-- ROBLOX deviation: customizing cleanup functionality for ReactRobloxRoot
-- local function cleanup()
-- 	mountedContainers:forEach(cleanupAtContainer)
-- end

-- local function cleanupAtContainer(container)
-- 	ReactDOM:unmountComponentAtNode(container)
-- 	if container.parentNode == document.body then
-- 		document.body:removeChild(container)
-- 	end
-- 	mountedContainers:delete(container)
-- end

local function cleanup()
	for _, container in ipairs(mountedContainers) do
		if container.unmount ~= nil then
			act(function()
				container:unmount()
			end)
		end
	end
	if rootInstance then
		(rootInstance :: Folder).Parent = nil
	end
end
exports.cleanup = cleanup

Object.assign(exports, domModule)

-- ROBLOX deviation: not converting fireEvent
-- exports.fireEvent = fireEvent
exports.act = act

return exports :: typeof(exports) & typeof(domModule)
