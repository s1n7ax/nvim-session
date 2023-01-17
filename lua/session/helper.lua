local config = require("session.config")

local notify_title = { title = "Session" }
local WARN = vim.log.levels.WARN

local M = {}

function M.create_new_session_setting()
	return {
		wd = vim.fn.getcwd(),
		file_path = string.format("%s/%s", config.session_dir, M.get_random_int() .. ".vim"),
	}
end

function M.get_random_int()
	return math.random(os.time())
end

function M.find_list_value_by(list, func)
	for _, value in ipairs(list) do
		if func(value) then
			return value
		end
	end
end

function M.find_session_by_cwd(sessions)
	local cwd = vim.fn.getcwd()

	return M.find_list_value_by(sessions, function(session)
		return session.wd == cwd
	end)
end

function M.notify_warn(message)
	vim.notify(message, WARN, notify_title)
end

return M
