local M = {}

local function load(plug_data)
  local spec = plug_data.spec
  local data = spec.data or {}

  if data.skip_load then
    return
  end

  if data.on then
    local events = type(data.on) == 'string' and { data.on } or data.on

    vim.api.nvim_create_autocmd(events, {
      once = true,
      callback = function()
        if type(data.load) == 'function' then
          data.load(plug_data)
        else
          vim.cmd.packadd(spec.name)
        end
      end,
    })
    return
  end

  if type(data.load) == 'function' then
    data.load(plug_data)
    return
  end

  vim.cmd.packadd(spec.name)
end

M.add = function(specs)
  vim.pack.add(specs, { load = load })
end

M.resolve_all = function()
  local config_path = vim.fn.stdpath('config') .. '/lua/my/packs'
  local handle = vim.uv.fs_scandir(config_path)

  if not handle then
    return
  end

  while true do
    local name, f_type = vim.uv.fs_scandir_next(handle)
    if not name then
      break
    end

    if f_type == 'file' and name:match('%.lua$') then
      local module_name = 'my.packs.' .. name:gsub('%.lua$', '')

      package.loaded[module_name] = nil

      local ok, specs = pcall(require, module_name)

      if ok and type(specs) == 'table' then
        M.add(specs)
      elseif not ok then
        vim.notify(
          'Error loading pack spec: ' .. module_name .. '\n' .. specs,
          vim.log.levels.ERROR
        )
      end
    end
  end
end

return M
