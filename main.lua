local mp = require("mp")
local ex = require("explorer")

mp.add_key_binding(":", "init", ex.init)
mp.add_key_binding(";", "jump-to-random", ex.jump)
mp.add_key_binding([["]], "folder-prev", ex.dir_prev)
mp.add_key_binding([[|]], "folder-next", ex.dir_next)
mp.add_key_binding("'", "file_prev", ex.file_prev)
mp.add_key_binding("\\", "file_next", ex.file_next)
