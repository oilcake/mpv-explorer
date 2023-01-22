local mp = require('mp')
local lib = require('lib')
local dir1 = '/Volumes/BIGBRO2/VDTMPRR/UntitledDiskEver/[CUTCUT]'

Lib = lib:new(dir1)

local M = {}

local function update_current()
  mp.commandv('loadfile', Lib.file_name)
end

function M.jump()
  mp.commandv('playlist-shuffle')
  mp.commandv('playlist-next')
  mp.commandv('playlist-unshuffle')
end

function M.file_next()
  Lib:next_file()
  update_current()
end

function M.file_prev()
  Lib:prev_file()
  update_current()
end

function M.dir_next()
  Lib:next_dir()
  update_current()
end

function M.dir_prev()
  Lib:prev_dir()
  update_current()
end

function M.init()
  update_current()
end

return M
