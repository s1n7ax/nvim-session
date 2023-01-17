local Settings = require("settings")
local helper = require("session.helper")

local sm = Settings:new("nvim-sessions")

local M = {}

function M.save_session()
	local settings = sm:get_settings()
	local curr_session

	if not settings.session_list then
		curr_session = helper.create_new_session_setting()

		sm:save_settings({
			session_list = {
				curr_session,
			},
		})
	else
		curr_session = helper.find_session_by_cwd(settings.session_list)

		if not curr_session then
			curr_session = helper.create_new_session_setting()
			table.insert(settings.session_list, curr_session)
		end

		sm:save_settings(settings)
	end

	vim.cmd.mkview({
		curr_session.file_path,
		bang = true,
	})

	vim.cmd.mksession({
		curr_session.file_path,
		bang = true,
	})
end

function M.restore_session()
	local settings = sm:get_settings()

	local curr_session = helper.find_session_by_cwd(settings.session_list)

	if not curr_session then
		helper.notify_warn("No session to restore")
		return
	end

	vim.cmd.source({ curr_session.file_path })
end

return M
