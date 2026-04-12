local M = {}

M.root_markers = {
  -- Must include python environment root markers here so that we can set cwd
  -- inside a python project and have correct python version in nvim.
  -- This is crucial for running pytest from within nvim using vim-test or
  -- other jobs that requires a python virtual environment.
  { 'venv', 'env', '.venv', '.env' },
  { '.python-version' },
  {
    '.git',
    '.svn',
    '.bzr',
    '.hg',
  },
  {
    '.project',
    '.pro',
    '.sln',
    '.vcxproj',
  },
  {
    'Makefile',
    'makefile',
    'MAKEFILE',
  },
  {
    '.gitignore',
    '.editorconfig',
  },
  {
    'README',
    'README.md',
    'README.txt',
    'README.org',
  },
}

local fs_root = vim.fs.root

---Wrapper of `vim.fs.root()` that accepts layered root markers like
---`vim.lsp.Config.root_markers`
---@param source? integer|string default to current working directory
---@param marker? (string|string[]|string[][]|fun(name: string, path: string): boolean) default to `utils.fs.root_markers`
---@return string?
function M.root(source, marker)
  source = source or 0
  marker = marker or M.root_markers

  if type(marker) ~= 'table' then
    return fs_root(source, marker)
  end

  local joined_markers = {} ---@type string[]

  for _, m in ipairs(marker) do
    -- `m` is a string, join with previous string markers as they are
    -- considered to have the same priority
    if type(m) == 'string' then
      table.insert(joined_markers, m)
      goto continue
    end

    -- `m` is a set of markers of the same priority, search them directly
    -- with `vim.fs.root()`, but before that we have to deal with previous
    -- unresolved marker set
    if not vim.tbl_isempty(joined_markers) then
      local root = fs_root(source, joined_markers)
      joined_markers = {}
      if root then
        return root
      end
    end

    local root = fs_root(source, m)
    if root then
      return root
    end
    ::continue::
  end
end

---Given a list of paths, return a list of path heads that uniquely distinguish each path
---e.g. { 'a/b/c', 'a/b/d', 'a/e/f' } -> { 'c', 'd', 'f' }
---     { 'a/b/c', 'd/b/c', 'e/c' } -> { 'a/b', 'd/b', 'e' }
---@param paths string[]
---@return string[]
function M.diff(paths)
  local n_paths = (function()
    local path_set = {}
    for _, path in ipairs(paths) do
      path_set[path] = true
    end
    return #vim.tbl_keys(path_set)
  end)()

  ---@alias my.ipath { [1]: string, [2]: integer }
  ---Paths with index
  ---@type my.ipath[]
  local ipaths = {}
  for i, path in ipairs(paths) do
    table.insert(ipaths, { path, i })
  end

  ---Groups of paths with the same tail
  ---key:val = tail:ihead[]
  ---@type table<string, my.ipath[]>
  local groups = { [''] = ipaths }

  while #vim.tbl_keys(groups) < n_paths do
    local g = {} ---@type table<string, my.ipath[]>
    for tail, iheads in pairs(groups) do
      for _, ihead in ipairs(iheads) do
        local head = ihead[1]
        local idx = ihead[2]
        local t = vim.fn.fnamemodify(head, ':t')
        local h = vim.fn.fnamemodify(head, ':h')
        if #vim.tbl_keys(groups) > 1 then
          t = t == '' and tail or tail == '' and t or vim.fs.joinpath(t, tail)
        end
        h = h == '.' and '' or h

        if not g[t] then
          g[t] = {}
        end
        table.insert(g[t], { h, idx })
      end
    end
    groups = g
  end

  local diffs = {}
  for tail, iheads in pairs(groups) do
    for _, ihead in ipairs(iheads) do
      diffs[ihead[2]] = tail
    end
  end
  return diffs
end

return M
