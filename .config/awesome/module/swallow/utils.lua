local pairs = pairs
local require = require
local string = string
local table = table

local awful = require("awful")

local M = {}

---Check if element exist in table.
---@param element any
---@param source table
---@return boolean true if element exists within table.
function M.is_in_table(element, source)
	local result = false
	for _, value in pairs(source) do
		if element:match(value) then
			result = true
			break
		end
	end
	return result
end

---Remove current tag from clients tags
---@param client client
---@param current_tag tag?
function M.turn_off(client, current_tag)
	if current_tag == nil then
		current_tag = client.screen.selected_tag
	end
	local ctags = {}
	for _, tag in pairs(client:tags()) do
		if tag ~= current_tag then
			table.insert(ctags, tag)
		end
	end
	client:tags(ctags)
	client.sticky = false
end

---Turn on passed client (add current tag to window's tags)
---@param client client
function M.turn_on(client)
	local current_tag = client.screen.selected_tag
	local ctags = { current_tag }
	for _, tag in pairs(client:tags()) do
		if tag ~= current_tag then
			table.insert(ctags, tag)
		end
	end
	client:tags(ctags)
	client:activate({})
end

---Sync two clients
---@param target_client client The client to which to write all properties
---@param source_client client The client from which to read all properties
function M.sync(target_client, source_client)
	if not source_client or not target_client then
		return
	end
	if not source_client.valid or not target_client.valid then
		return
	end
	if source_client.modal then
		return
	end
	target_client.floating = source_client.floating
	target_client.maximized = source_client.maximized
	target_client.above = source_client.above
	target_client.below = source_client.below
	target_client:geometry(source_client:geometry())
	-- TODO: Should also copy over the position in a tiling layout
end

---Async function to get the parent's process ID.
---parent_pid in format "init(1)---ancestorA(pidA)---ancestorB(pidB)...---process(pid)"
---@param child_ppid string
---@param callback fun(stderr: string?, ppid: string?)
function M.get_parent_pid(child_ppid, callback)
	local ppid_cmd = string.format("pstree -A -p -s %s", child_ppid)
	awful.spawn.easy_async(ppid_cmd, function(stdout, stderr)
		-- primitive error checking
		if stderr and stderr ~= "" then
			callback(stderr)
			return
		end
		local ppid = stdout
		callback(nil, ppid)
	end)
end

return M
