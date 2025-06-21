local utils = require('utils')

---Check if there exists an LS that supports the given method
---for the given buffer
---@param method string the method to check for
---@param bufnr number buffer handler
local function supports_method(method, bufnr)
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  for _, client in ipairs(clients) do
    if client.supports_method(method) then
      return true
    end
  end
  return false
end

---Setup LSP keymaps
---@return nil
local function setup_keymaps()
  -- vim.keymap.set({ 'n' }, 'gq;', vim.lsp.buf.format)
  vim.keymap.set({ 'n', 'x' }, 'g/', vim.lsp.buf.references)
  vim.keymap.set({ 'n', 'x' }, 'g.', vim.lsp.buf.implementation)
  vim.keymap.set({ 'n', 'x' }, 'gd', function()
    return supports_method('textDocument/definition', 0)
        and '<Cmd>lua vim.lsp.buf.definition()<CR>'
      or 'gd'
  end, { expr = true })
  vim.keymap.set({ 'n', 'x' }, 'gD', function()
    return supports_method('textDocument/typeDefinition', 0)
        and '<Cmd>lua vim.lsp.buf.type_definition()<CR>'
      or 'gD'
  end, { expr = true })
  vim.keymap.set({ 'n', 'x' }, '<Leader>r', vim.lsp.buf.rename)
  vim.keymap.set({ 'n', 'x' }, '<Leader>a', vim.lsp.buf.code_action)
  vim.keymap.set({ 'n', 'x' }, '<Leader><', vim.lsp.buf.incoming_calls)
  vim.keymap.set({ 'n', 'x' }, '<Leader>>', vim.lsp.buf.outgoing_calls)
  vim.keymap.set({ 'n', 'x' }, '<Leader>s', vim.lsp.buf.document_symbol)
  vim.keymap.set({ 'n', 'x' }, '<Leader>S', vim.lsp.buf.workspace_symbol)
  vim.keymap.set({ 'n', 'x' }, '<Leader>d', vim.diagnostic.setloclist)
  vim.keymap.set({ 'n', 'x' }, '<Leader>D', vim.diagnostic.setqflist)
  vim.keymap.set({ 'n', 'x' }, '<Leader>i', vim.diagnostic.open_float)
  vim.keymap.set({ 'n', 'x' }, 'gy', function()
    local diags = vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 })
    local n_diags = #diags
    if n_diags == 0 then
      vim.notify(
        '[LSP] no diagnostics found in current line',
        vim.log.levels.WARN
      )
      return
    end

    ---@param msg string
    local function _yank(msg)
      vim.fn.setreg('"', msg)
      vim.fn.setreg(vim.v.register, msg)
    end

    if n_diags == 1 then
      local msg = diags[1].message
      _yank(msg)
      vim.notify(
        string.format([[[LSP] yanked diagnostic message '%s']], msg),
        vim.log.levels.INFO
      )
      return
    end

    vim.ui.select(
      vim.tbl_map(function(d)
        return d.message
      end, diags),
      { prompt = 'Select diagnostic message to yank: ' },
      _yank
    )
  end, { desc = '[LSP] Yank diagnostic message on current line' })

  local c = utils.keymap.count_wrap
  ---@param direction 'prev'|'next'
  ---@param level ('ERROR'|'WARN'|'INFO'|'HINT')?
  ---@return function
  local function diag_jump(direction, level)
    return function()
      vim.diagnostic.jump(level and {
        count = direction == 'next' and 1 or -1,
        severity = vim.diagnostic.severity[level],
      } or {
        count = direction == 'next' and 1 or -1,
      })
    end
  end
  vim.keymap.set({ 'n', 'x' }, '[d', c(diag_jump('prev')))
  vim.keymap.set({ 'n', 'x' }, ']d', c(diag_jump('next')))
  vim.keymap.set({ 'n', 'x' }, '[e', c(diag_jump('prev', 'ERROR')))
  vim.keymap.set({ 'n', 'x' }, ']e', c(diag_jump('next', 'ERROR')))
  vim.keymap.set({ 'n', 'x' }, '[w', c(diag_jump('prev', 'WARN')))
  vim.keymap.set({ 'n', 'x' }, ']w', c(diag_jump('next', 'WARN')))
  vim.keymap.set({ 'n', 'x' }, '[i', c(diag_jump('prev', 'INFO')))
  vim.keymap.set({ 'n', 'x' }, ']i', c(diag_jump('next', 'INFO')))
  vim.keymap.set({ 'n', 'x' }, '[h', c(diag_jump('prev', 'HINT')))
  vim.keymap.set({ 'n', 'x' }, ']h', c(diag_jump('next', 'HINT')))
end

---Setup LSP handlers overrides
---@return nil
local function setup_lsp_overrides()
  -- Show notification if no references, definition, declaration,
  -- implementation or type definition is found
  local handlers = {
    ['textDocument/references'] = vim.lsp.handlers['textDocument/references'],
    ['textDocument/definition'] = vim.lsp.handlers['textDocument/definition'],
    ['textDocument/declaration'] = vim.lsp.handlers['textDocument/declaration'],
    ['textDocument/implementation'] = vim.lsp.handlers['textDocument/implementation'],
    ['textDocument/typeDefinition'] = vim.lsp.handlers['textDocument/typeDefinition'],
  }
  for method, handler in pairs(handlers) do
    local obj_name = method:match('/(%w*)$'):gsub('s$', '')
    vim.lsp.handlers[method] = function(err, result, ctx, cfg)
      if not result or vim.tbl_isempty(result) then
        vim.notify('[LSP] no ' .. obj_name .. ' found')
        return
      end

      -- textDocument/definition can return Location or Location[]
      -- https://microsoft.github.io/language-server-protocol/specifications/specification-current/#textDocument_definition
      if not vim.islist(result) then
        result = { result }
      end

      if #result == 1 then
        local enc = vim.lsp.get_client_by_id(ctx.client_id).offset_encoding
        vim.lsp.util.jump_to_location(result[1], enc)
        vim.notify('[LSP] found 1 ' .. obj_name)
        return
      end
      handler(err, result, ctx, cfg)
    end
  end

  -- Configure hovering window style
  -- Hijack LSP floating window function to use custom options
  local _open_floating_preview = vim.lsp.util.open_floating_preview
  ---@param contents table of lines to show in window
  ---@param syntax string of syntax to set for opened buffer
  ---@param opts table with optional fields (additional keys are passed on to |nvim_open_win()|)
  ---@returns bufnr,winnr buffer and window number of the newly created floating preview window
  ---@diagnostic disable-next-line: duplicate-set-field
  function vim.lsp.util.open_floating_preview(contents, syntax, opts)
    local source_ft = vim.bo[vim.api.nvim_get_current_buf()].ft
    opts = vim.tbl_deep_extend('force', opts, {
      border = 'solid',
      max_width = math.max(80, math.ceil(vim.go.columns * 0.75)),
      max_height = math.max(20, math.ceil(vim.go.lines * 0.4)),
      close_events = {
        'CursorMovedI',
        'CursorMoved',
        'InsertEnter',
        'WinScrolled',
        'WinResized',
        'VimResized',
      },
    })
    -- If source filetype is markdown, use custom mkd syntax instead of
    -- markdown syntax to avoid using treesitter highlight and get math
    -- concealing provided by vimtex in the floating window
    if source_ft == 'markdown' then
      syntax = 'markdown'
      opts.wrap = false
    end
    local floating_bufnr, floating_winnr =
      _open_floating_preview(contents, syntax, opts)
    vim.wo[floating_winnr].concealcursor = 'nc'
    return floating_bufnr, floating_winnr
  end

  -- Use loclist instead of qflist by default when showing document symbols
  local _lsp_document_symbol = vim.lsp.buf.document_symbol
  vim.lsp.buf.document_symbol = function()
    ---@diagnostic disable-next-line: redundant-parameter
    _lsp_document_symbol({
      loclist = true,
    })
  end
end

---Set up diagnostic signs and virtual text
---@return nil
local function setup_diagnostic()
  vim.diagnostic.config({
    virtual_text = {
      spacing = 4,
      prefix = vim.trim(icons.ui.AngleLeft),
    },
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = icons.diagnostics.DiagnosticSignError,
        [vim.diagnostic.severity.WARN] = icons.diagnostics.DiagnosticSignWarn,
        [vim.diagnostic.severity.INFO] = icons.diagnostics.DiagnosticSignInfo,
        [vim.diagnostic.severity.HINT] = icons.diagnostics.DiagnosticSignHint,
      },
      numhl = {
        [vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
        [vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
        [vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
        [vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
      },
    },
  })
end

---Set up LSP and diagnostic
---@return nil
local function setup()
  if vim.g.loaded_lsp_diags ~= nil then
    return
  end
  vim.g.loaded_lsp_diags = true
  setup_lsp_overrides()
  setup_diagnostic()
  setup_keymaps()
end

return { setup = setup }
