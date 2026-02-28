return setmetatable({}, {
  __index = function(self, key)
    self[key] = require('my.utils.' .. key)
    return self[key]
  end,
})
