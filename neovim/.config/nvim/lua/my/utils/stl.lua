local M = {}

---Get string representation of a string with highlight
---@param str? string sign symbol
---@param hl? string name of the highlight group
---@param restore? boolean restore highlight after the sign, default true
---@return string sign string representation of the sign with highlight
function M.hl(str, hl, restore)
  hl = hl or ''
  str = str and tostring(str) or ''
  restore = restore == nil or restore
  return restore and table.concat({ '%#', hl, '#', str, '%*' })
    or table.concat({ '%#', hl, '#', str })
end

---Escape '%' with '%' in a string to avoid it being treated as a statusline
---field, see `:h 'statusline'`
---@param str string
---@return string
function M.escape(str)
  return (str:gsub('%%', '%%%%'))
end

return M
