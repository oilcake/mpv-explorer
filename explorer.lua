local mp = require('mp')
local lib = require('lib')
local dir1 = '/Volumes/BIGBRO2/VDTMPRR/UntitledDiskEver/[CUTCUT]'


local M = {}

local function update_current()
  print(Lib.file_name)
  mp.commandv('loadfile', Lib.file_name)
end

function M.jump()
  Lib:random_dir()
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
  update_current()
end

function M.dir_prev()
  Lib:prev_dir()
  update_current()
end

function M.init()
  Lib = lib:new(dir1)
  update_current()
end

return M
