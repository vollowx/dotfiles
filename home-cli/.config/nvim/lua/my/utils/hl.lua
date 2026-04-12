local M = {}

---Wrapper of nvim_get_hl(), but does not create a highlight group
---if it doesn't exist (default to opts.create = false), and add
---new option opts.winhl_link to get highlight attributes without
---being affected by winhl
---@param ns_id integer
---@param opts table{ name: string?, id: integer?, link: boolean? }
---@return vim.api.keyset.hl_info: highlight attributes
function M.get(ns_id, opts)
  local no_winhl_link = opts.winhl_link == false
  opts.winhl_link = nil
  opts.create = opts.create or false
  local attr = vim.api.nvim_get_hl(ns_id, opts)
  -- We want to get true highlight attribute not affected by winhl
  if no_winhl_link then
    while attr.link do
      opts.name = attr.link
      attr = vim.api.nvim_get_hl(ns_id, opts)
    end
  end
  return attr
end

---@param attr_type 'fg'|'bg'|'ctermfg'|'ctermbg'
---@param fbg? string|integer
---@param default? integer
---@return integer|string|nil
function M.normalize_fg_or_bg(attr_type, fbg, default)
  if not fbg then
    return default
  end
  local data_type = type(fbg)
  if data_type == 'number' then
    if attr_type:match('^cterm') then
      return fbg >= 0 and fbg <= 255 and fbg or default
    end
    return fbg
  end
  if data_type == 'string' then
    if vim.fn.hlexists(fbg) == 1 then
      return M.get(0, {
        name = fbg,
        winhl_link = false,
      })[attr_type]
    end
    if fbg:match('^#%x%x%x%x%x%x$') then
      if attr_type:match('^cterm') then
        return default
      end
      return fbg
    end
  end
  return default
end

---Normalize highlight attributes
---1. Replace `attr.fg` and `attr.bg` with their corresponding color codes
---   if they are set to highlight group names
---2. If `attr.link` used in combination with other attributes, will first
---   retrieve the attributes of the linked highlight group, then merge
---   with other attributes
---Side effect: change `attr` table
---@param attr vim.api.keyset.highlight highlight attributes
---@return table: normalized highlight attributes
function M.normalize(attr)
  if attr.link then
    local num_keys = #vim.tbl_keys(attr)
    if num_keys <= 1 then
      return attr
    end
    attr.fg = M.normalize_fg_or_bg('fg', attr.fg)
    attr.bg = M.normalize_fg_or_bg('bg', attr.bg)
    attr = vim.tbl_extend('force', M.get(0, {
      name = attr.link,
      winhl_link = false,
    }) or {}, attr)
    attr.link = nil
    return attr
  end
  local fg = attr.fg
  local bg = attr.bg
  local ctermfg = attr.ctermfg
  local ctermbg = attr.ctermbg
  attr.fg = M.normalize_fg_or_bg('fg', fg)
  attr.bg = M.normalize_fg_or_bg('bg', bg)
  attr.ctermfg = M.normalize_fg_or_bg('ctermfg', ctermfg or fg)
  attr.ctermbg = M.normalize_fg_or_bg('ctermbg', ctermbg or bg)
  return attr
end

---Wrapper of nvim_set_hl(), normalize highlight attributes before setting
---@param ns_id integer namespace id
---@param name string
---@param attr vim.api.keyset.highlight highlight attributes
---@return nil
function M.set(ns_id, name, attr)
  return vim.api.nvim_set_hl(ns_id, name, M.normalize(attr))
end

---Set default highlight attributes, normalize highlight attributes before setting
---@param ns_id integer namespace id
---@param name string
---@param attr vim.api.keyset.highlight highlight attributes
---@return nil
function M.set_default(ns_id, name, attr)
  attr.default = true
  return vim.api.nvim_set_hl(ns_id, name, M.normalize(attr))
end

return M
