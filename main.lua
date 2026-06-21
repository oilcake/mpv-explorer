local mp = require("mp")

local opts = require("mp.options")
local config = { auto_init = false }
opts.read_options(config, "explorer")

if config.auto_init then
	local ex = require("explorer")

	mp.add_key_binding("|", "jump-to-random", ex.jump)
	mp.add_key_binding("b", "folder-prev", ex.dir_prev)
	mp.add_key_binding("n", "folder-next", ex.dir_next)
	mp.add_key_binding("'", "file-prev", ex.file_prev)
	mp.add_key_binding([[\]], "file-next", ex.file_next)
	mp.add_key_binding(";", "file-random", ex.file_random)
end
