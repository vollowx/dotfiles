local M = {}
local _pending_specs = {}

---@param path string
local function resolve_path(path)
  if path:find('^@') then
    path = path:gsub('^@', vim.fn.stdpath('config'))
  end
  return vim.fn.expand(path)
end

---@param plug_data {spec: vim.pack.Spec, path: string})
local function _load(plug_data)
  local spec = plug_data.spec
  local data = spec.data or {}

  if type(data.init) == 'function' then
    data.init()
  end

  if data.on then -- Event-based loading
    local events = type(data.on) == 'string' and { data.on } or data.on
    vim.api.nvim_create_autocmd(events, {
      once = true,
      pattern = data.pattern or '*',
      callback = function()
        vim.cmd.packadd(spec.name)
        if type(data.postload) == 'function' then
          data.postload(plug_data)
        end
      end,
    })
    return
  else -- Immediate loading
    vim.cmd.packadd(spec.name)
    if type(data.postload) == 'function' then
      data.postload(plug_data)
    end
  end
end

---@param specs vim.pack.Spec
M.add = function(specs)
  if not specs then return end
  local list = (specs.name or type(specs[1]) == 'string') and { specs } or specs
  for _, s in ipairs(list) do
    table.insert(_pending_specs, s)
  end
end

---@param path string Path to a file or directory, `@`s will be replaced with
---the Neovim config path
M.source = function(path)
  local full_path = resolve_path(path)
  local stat = vim.uv.fs_stat(full_path)

  if not stat then
    vim.notify("Path not found: " .. full_path, vim.log.levels.WARN)
    return
  end

  if stat.type == 'directory' then
    local handle = vim.uv.fs_scandir(full_path)
    while true and handle do
      local name, f_type = vim.uv.fs_scandir_next(handle)
      if not name then break end
      if f_type == 'file' and name:match('%.lua$') then
        M.source(full_path .. '/' .. name) -- Recursive call for files
      end
    end
  elseif stat.type == 'file' then
    local ok, specs = pcall(dofile, full_path)
    if ok then M.add(specs) else
      vim.notify("Error in " .. full_path .. ": " .. specs, vim.log.levels.ERROR)
    end
  end
end

---Should be called after all `add()`s and `ensure()`s
M.ensure = function()
  if #_pending_specs == 0 then return end
  vim.pack.add(_pending_specs, { load = _load })
end

return M
