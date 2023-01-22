local Reader = {}

function Reader:new(items, initial)
  self = {
    id = 1,
    count = 0,
    current = function()
      return self.id
    end,
    next = function()
      if self.id >= self.count then
        self.id = 1
      else self.id = (self.id + 1)
      end
      return self.id
    end,
    prev = function()
      if self.id <= 1 then
        self.id = self.count
      else self.id = self.id - 1
      end
      return self.id
    end
  }
  setmetatable({}, self)
  self.count = #items
  self.id = initial
  return self
end

return Reader
