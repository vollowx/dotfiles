if vim.g.loaded_eldoc then
  return
end
vim.g.loaded_eldoc = true

local last_message = ''

---@param err lsp.ResponseError?
---@param result lsp.SignatureHelp
local function handle_signature_help(err, result)
  if err or not result or not result.signatures or #result.signatures == 0 then
    if last_message ~= '' then
      vim.api.nvim_echo({ { '', '' } }, false, { kind = 'msg' })
      last_message = ''
    end
    return
  end

  local sig = result.signatures[(result.activeSignature or 0) + 1]
    or result.signatures[1]
  local label = sig.label:gsub('\n', ' ')

  local max_w = vim.o.columns - 1
  if #label > max_w then
    label = label:sub(1, max_w) .. '…'
  end

  if label == last_message then return end

  last_message = label

  vim.api.nvim_echo({ { '', '' } }, false, { kind = 'msg' })
  vim.api.nvim_echo({ { label, 'NonText' } }, false, { kind = 'msg' })
end

local function handle_cursor_hold()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then return end

  local params =
    vim.lsp.util.make_position_params(0, clients[1].offset_encoding)

  vim.lsp.buf_request(
    0,
    'textDocument/signatureHelp',
    params,
    handle_signature_help
  )
end

vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
  group = vim.api.nvim_create_augroup('Eldoc', { clear = true }),
  callback = handle_cursor_hold,
})
