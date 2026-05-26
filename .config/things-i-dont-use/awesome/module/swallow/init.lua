local require = require
local setmetatable = setmetatable
local tostring = tostring

local capi = { client = client }

local awful = require("awful")
local utils = require(... .. ".utils")

---@param swallow swallow
local function set_spawn_callback(swallow)
	swallow.client_spawn_callback = function(client)
		-- Get the last focused window to check if it is a parent window.
		local parent_client = awful.client.focus.history.get(client.screen, 1)
		if not parent_client then
			return
		elseif parent_client.type == "dialog" or parent_client.type == "splash" then
			return
		end
		local function handle_parent_pid(err, ppid)
			if err then
				return
			end
			local parent_pid = ppid
			--Searches for "(parent_client.pid)" inside the parent_pid string
			local is_parent_id_matching = tostring(parent_pid):find("(" .. tostring(parent_client.pid) .. ")")
			local should_swallow = swallow:check_swallow(parent_client.class, client.class)
			if is_parent_id_matching and should_swallow then
				client:connect_signal("request::unmanage", function()
					if parent_client then
						utils.turn_on(parent_client)
						utils.sync(parent_client, client)
					end
				end)
				utils.sync(client, parent_client)
				utils.turn_off(parent_client)
			end
		end
		utils.get_parent_pid(client.pid, handle_parent_pid)
	end
end

---@class swallow
---@field parent_filter_list table?
---@field child_filter_list table?
---@field window_swallow_active boolean
---@field client_spawn_callback fun(client: client)?
local swallow = {}

function swallow:new(args)
	local object = setmetatable({}, self)
	self.__index = self
	object.parent_filter_list = args.parent_filter_list or {}
	object.child_filter_list = args.child_filter_list or {}
	object.window_swallow_active = false
	object.client_spawn_callback = nil
	return object
end

---If the swallowing filter is active checks the child and parent classes against their filters.
---@param parent any
---@param child any
---@return boolean
function swallow:check_swallow(parent, child)
	local result = true
	local prnt = not utils.is_in_table(parent, self.parent_filter_list)
	local chld = not utils.is_in_table(child, self.child_filter_list)
	result = (prnt and chld)
	return result
end

function swallow:start()
	set_spawn_callback(self)
	capi.client.connect_signal("request::manage", self.client_spawn_callback)
	self.window_swallowing_activated = true
end

function swallow:stop()
	capi.client.disconnect_signal("request::manage", self.client_spawn_callback)
	self.window_swallowing_activated = false
end

function swallow:toggle()
	if self.window_swallowing_activated then
		self:stop()
	else
		self:start()
	end
end

return swallow
