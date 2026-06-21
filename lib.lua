local reader = require("reader")

local function has_dirs(path)
	local p = io.popen('find "' .. path .. '" -type d | wc -l')
	if p == nil then
		return false
	end
	local count = tonumber(p:read("*a"))
	p:close()
	if count > 1 then
		return true
	end
	return false
end

local function is_empty(dir)
	local p = io.popen('find "' .. dir .. '" -type f | wc -l')
	if p == nil then
		return true
	end
	local count = tonumber(p:read("*a"))
	p:close()
	if count > 0 then
		return false
	end
	return true
end

local function list_dirs(path)
	-- accepts unescaped path
	local dirs = {}
	local p = io.popen('find "' .. path .. '" -type d | sort --version-sort -f')
	-- loop through all dirs
	if p == nil then
		return nil, error("couldn't read dir")
	end
	for dir in p:lines() do
		if not has_dirs(dir) and not is_empty(dir) then
			table.insert(dirs, dir)
		end
	end
	p:close()
	return dirs, nil
end

local function isVideoFile(filename)
	-- Список допустимых видео расширений (можно дополнять)
	local videoExtensions = {
		".mp4",
		".avi",
		".mov",
		".wmv",
		".flv",
		".mkv",
		".webm",
		".mpeg",
		".mpg",
		".m4v",
		".3gp",
		".ogg",
		".ogv",
		".vob",
		".ts",
	}

	-- Приводим имя файла к нижнему регистру для унификации
	filename = filename:lower()

	-- Проверяем каждое расширение из списка
	for _, ext in ipairs(videoExtensions) do
		if filename:sub(-#ext) == ext then
			return true
		end
	end

	return false
end

local function list_files_in(dir)
	-- opens directory looks for files
	-- accepts unescaped path
	local files = {}
	local p = io.popen('find "' .. dir .. '" -type f | sort --version-sort -f')
	-- loop through all files
	if p == nil then
		return nil, error("couldn't read dir")
	end
	for file in p:lines() do
		if not file:match("^.+/%..+") and not file:match("^.+%.clp") and isVideoFile(file) then
			table.insert(files, file)
		end
	end
	return files, nil
end

-- Lib is kinda filesystem object that holds an array of arrays of files
local Lib = {
	dirs = {},
	dir_id = nil,
	dir_name = nil,
	dir_content = {},
	file_id = nil,
	ids = {},
}

function Lib:new(path)
	assert(path ~= nil)
	local dirs = list_dirs(path)
	assert(dirs ~= nil)
	-- ponytail: filter dirs with video files only, skip empty/invalid
	local valid_dirs = {}
	for _, dir in ipairs(dirs) do
		local files = list_files_in(dir)
		if files and #files > 0 then
			table.insert(valid_dirs, dir)
			self.ids[dir] = 1
		end
	end
	if #valid_dirs == 0 then
		return nil, "no directories with video files found"
	end
	self.dirs = valid_dirs
	self.dir_id = reader:new(self.dirs, 1)
	self.dir_name = self.dirs[self.dir_id:current()]
	self:update()
	math.randomseed(os.time())
	return self
end

function Lib:update()
	self.dir_content = list_files_in(self.dir_name)
	local position = self.ids[self.dir_name]
	self.file_id = reader:new(self.dir_content, position)
end

function Lib:next_dir()
	self.dir_name = self.dirs[self.dir_id:next()]
	self:update()
end

function Lib:prev_dir()
	self.dir_name = self.dirs[self.dir_id:prev()]
	self:update()
end

function Lib:random_dir()
	local number = math.random(#self.dirs)
	self.dir_id.id = number
	self.dir_name = self.dirs[self.dir_id:current()]
	self:update()
end

function Lib:next_file()
	self.ids[self.dir_name] = self.file_id:next()
end

function Lib:prev_file()
	self.ids[self.dir_name] = self.file_id:prev()
end

function Lib:random_file()
	local number = math.random(#self.dir_content)
	self.file_id.id = number
	self.ids[self.dir_name] = self.file_id:current()
end

return Lib
