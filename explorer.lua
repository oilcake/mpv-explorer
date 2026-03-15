local mp = require("mp")
local lib = require("lib")
local tmp_playlist = "tmp_playlist.mpv"
local working_dir = mp.get_property("working-directory")

local M = {}

local function dir_content_to_file()
	local playlist_file = io.open(tmp_playlist, "w")
	if playlist_file ~= nil then
		for _, file in ipairs(Lib.dir_content) do
			playlist_file:write(file)
			playlist_file:write("\n")
		end
		playlist_file:close()
	end
end

local function update_playlist()
	dir_content_to_file()
	mp.commandv("loadlist", tmp_playlist, "replace")
end

local function update_current()
	mp.commandv("playlist-play-index", Lib.file_id:current() - 1)
end

function M.jump()
	Lib:random_dir()
	update_playlist()
	update_current()
end

function M.file_next()
	Lib:next_file()
	update_current()
end

function M.file_prev()
	Lib:prev_file()
	update_current()
end

function M.file_random()
	Lib:random_file()
	update_current()
end

function M.dir_next()
	Lib:next_dir()
	update_playlist()
	update_current()
end

function M.dir_prev()
	Lib:prev_dir()
	update_playlist()
	update_current()
end

function M.init()
	Lib = lib:new(working_dir)
	update_playlist()
	update_current()
end

return M
