---@class Palette
---@field background string
---@field error string
---@field error_container string
---@field inverse_on_surface string
---@field inverse_primary string
---@field inverse_surface string
---@field on_background string
---@field on_error string
---@field on_error_container string
---@field on_primary string
---@field on_primary_container string
---@field on_primary_fixed string
---@field on_primary_fixed_variant string
---@field on_secondary string
---@field on_secondary_container string
---@field on_secondary_fixed string
---@field on_secondary_fixed_variant string
---@field on_surface string
---@field on_surface_variant string
---@field on_tertiary string
---@field on_tertiary_container string
---@field on_tertiary_fixed string
---@field on_tertiary_fixed_variant string
---@field outline string
---@field outline_variant string
---@field primary string
---@field primary_container string
---@field primary_fixed string
---@field primary_fixed_dim string
---@field scrim string
---@field secondary string
---@field secondary_container string
---@field secondary_fixed string
---@field secondary_fixed_dim string
---@field shadow string
---@field source_color string
---@field surface string
---@field surface_bright string
---@field surface_container string
---@field surface_container_high string
---@field surface_container_highest string
---@field surface_container_low string
---@field surface_container_lowest string
---@field surface_dim string
---@field surface_tint string
---@field surface_variant string
---@field tertiary string
---@field tertiary_container string
---@field tertiary_fixed string
---@field tertiary_fixed_dim string
---@field ok string
---@field ok_container string
---@field on_ok string
---@field on_ok_container string
---@field hint string
---@field hint_container string
---@field on_hint string
---@field on_hint_container string
---@field warning string
---@field warning_container string
---@field on_warning string
---@field on_warning_container string

-- Clear hlgroups and set colors_name {{{
vim.cmd.hi('clear')
if vim.fn.exists('syntax_on') then
  vim.cmd('syntax reset')
end
vim.g.colors_name = 'material-you'
-- }}}

-- Palette {{{
local json_path = os.getenv('XDG_CACHE_HOME') .. '/dotfiles/md3/colors.json'
local content = table.concat(vim.fn.readfile(json_path), '\n')
local palette = vim.fn.json_decode(content)

---@type Palette
---@diagnostic disable-next-line
local c = {}

for key, val in pairs(palette) do
  if val and val ~= '' then
    c[key] = val
  end
end
-- }}}

-- Highlight groups {{{1
local hlgroups = {
  -- UI
  Normal = { bg = c.background, fg = c.on_background },
  NormalFloat = { bg = c.surface_container_lowest, fg = c.on_surface },
  FloatBorder = { bg = c.surface_container_lowest, fg = c.outline },
  ColorColumn = { bg = c.surface_container_low },
  Cursor = { bg = c.on_background, fg = c.background },
  CursorLine = { bg = c.surface_container_low },
  CursorLineNr = { fg = c.on_surface, bold = true },
  Directory = { fg = c.primary },
  LineNr = { fg = c.outline },
  MoreMsg = { fg = c.tertiary },
  SignColumn = { fg = c.on_surface_variant },
  VertSplit = { fg = c.outline_variant },
  WinSeparator = { link = 'VertSplit' },
  StatusLine = { bg = c.surface_container, fg = c.on_surface_variant },
  StatusLineNC = { bg = c.surface_container_low, fg = c.outline },
  TabLine = { link = 'StatusLineNC' },
  TabLineFill = { link = 'StatusLineNC' },
  TabLineSel = { bg = c.background, fg = c.on_surface },
  Pmenu = { bg = c.surface_container_high, fg = c.on_surface },
  PmenuSel = { bg = c.primary, fg = c.on_primary },
  PmenuSbar = { bg = c.surface_container_highest },
  PmenuThumb = { bg = c.outline },
  Visual = { bg = c.surface_container },
  Folded = { bg = c.surface_container, fg = c.on_surface_variant },
  Search = { bg = c.tertiary_container, fg = c.on_tertiary_container },
  IncSearch = {
    bg = c.on_tertiary_container,
    fg = c.tertiary_container,
    bold = true,
  },
  CurSearch = {
    bg = c.tertiary,
    fg = c.on_tertiary,
    bold = true,
  },

  -- Syntax
  Boolean = { fg = c.tertiary, bold = true },
  Comment = { fg = c.outline },
  Constant = { fg = c.tertiary },
  Character = { link = 'String' },
  Delimiter = { fg = c.outline },
  Error = { fg = c.error, bg = c.error_container },
  ErrorMsg = { fg = c.error },
  Float = { link = 'Number' },
  Function = { fg = c.on_surface_variant },
  Identifier = { fg = c.on_background },
  Keyword = { fg = c.tertiary },
  Number = { fg = c.primary },
  Operator = { fg = c.on_surface },
  PreProc = { fg = c.tertiary },
  Property = { fg = c.on_surface },
  Special = { fg = c.primary },
  Statement = { fg = c.secondary },
  String = { fg = c.secondary },
  Todo = {
    bg = c.secondary_container,
    fg = c.on_secondary_container,
    bold = true,
  },
  Title = { fg = c.primary, bold = true },
  Type = { fg = c.error },
  Underlined = { fg = c.primary, underline = true },
  WarningMsg = { fg = c.warning },

  -- Treesitter
  ['@attribute'] = { link = 'Constant' },
  ['@constructor'] = { fg = c.primary },
  ['@keyword.import'] = { link = 'PreProc' },
  ['@keyword.operator'] = { fg = c.primary_fixed_dim, bold = true },
  ['@keyword.return'] = { link = 'Statement' },
  ['@module'] = { fg = c.tertiary },
  ['@operator'] = { link = 'Operator' },
  ['@punctuation.bracket'] = { link = 'Delimiter' },
  ['@punctuation.delimiter'] = { link = 'Delimiter' },
  ['@string.escape'] = { fg = c.tertiary_fixed },
  ['@string.regexp'] = { fg = c.tertiary },
  ['@string.plain.css'] = { fg = c.primary },
  ['@tag.attribute'] = { fg = c.tertiary },
  ['@tag.delimiter'] = { link = 'Delimiter' },
  ['@type.tag.css'] = { link = '@tag.css' },
  ['@markup.strong'] = { bold = true },
  ['@markup.emphasis'] = { italic = true },
  ['@markup.heading'] = { fg = c.error },
  ['@markup.link.url'] = { fg = c.secondary, underline = true },
  ['@markup.raw'] = { link = 'String' },
  ['@markup.quote'] = { link = 'String' },
  ['@comment.error'] = {
    bg = c.error_container,
    fg = c.on_error_container,
    bold = true,
  },
  ['@comment.warning'] = {
    fg = c.warning_container,
    bg = c.on_warning_container,
    bold = true,
  },
  ['@comment.todo'] = { link = 'Todo' },
  ['@variable'] = { link = 'Property' },
  ['@variable.builtin'] = { fg = c.primary_fixed_dim },
  ['@markup.list.checked'] = { fg = c.on_tertiary_container, bold = true },
  ['@markup.list.unchecked'] = { fg = c.tertiary },
  ['@type.astro'] = { link = '@tag.astro' },
  ['@type.builtin.c'] = { link = 'Type' },

  -- Markdown
  CodeBlock = { bg = c.on_surface_variant },
  ['@nospell.markdown_inline'] = { link = 'CodeBlock' },

  -- LSP
  LspCodeLens = { fg = c.on_surface_variant },
  LspReferenceRead = { bg = c.surface_container_high },
  LspReferenceText = { bg = c.surface_container_high },
  LspReferenceWrite = { bg = c.surface_container_high, underline = true },
  LspSignatureActiveParameter = { fg = c.primary, bold = true },

  -- Diagnostic
  DiagnosticError = { fg = c.error },
  DiagnosticWarn = { fg = c.warning },
  DiagnosticInfo = { fg = c.secondary },
  DiagnosticHint = { fg = c.hint },
  DiagnosticOk = { fg = c.ok },
  DiagnosticSignError = { fg = c.error },
  DiagnosticSignWarn = { fg = c.warning },
  DiagnosticSignInfo = { fg = c.secondary },
  DiagnosticSignHint = { fg = c.hint },
  DiagnosticSignOk = { fg = c.ok },
  DiagnosticUnderlineError = { sp = c.error, undercurl = true },
  DiagnosticUnderlineWarn = { sp = c.warning, undercurl = true },
  DiagnosticUnderlineInfo = { sp = c.secondary, undercurl = true },
  DiagnosticUnderlineHint = { sp = c.hint, undercurl = true },
  DiagnosticUnderlineOk = { sp = c.ok, undercurl = true },
  DiagnosticVirtualTextError = {
    bg = c.error_container,
    fg = c.on_error_container,
  },
  DiagnosticVirtualTextWarn = {
    bg = c.warning_container,
    fg = c.on_warning_container,
  },
  DiagnosticVirtualTextInfo = {
    bg = c.secondary_container,
    fg = c.on_secondary_container,
  },
  DiagnosticVirtualTextHint = {
    bg = c.hint_container,
    fg = c.on_hint_container,
  },
  DiagnosticVirtualTextOK = {
    bg = c.ok_container,
    fg = c.on_ok_container,
  },

  -- Plugins
  StatusLineHeader = {
    bg = c.surface_container_highest,
    fg = c.on_surface,
  },
  StatusLineHeaderModified = {
    bg = c.error_container,
    fg = c.on_error_container,
  },

  VisualNonText = { bg = c.surface_container, fg = c.surface_variant },

  GitSignsAdd = { fg = c.primary },
  GitSignsChange = { fg = c.secondary },
  GitSignsDelete = { fg = c.error },

  BlinkCmpDocBorder = { link = 'FloatBorder' },
  BlinkCmpSignatureHelpBorder = { link = 'FloatBorder' },
  BlinkCmpKindText = { fg = c.secondary },
  BlinkCmpKindMethod = { fg = c.primary },
  BlinkCmpKindFunction = { fg = c.primary },
  BlinkCmpKindConstructor = { fg = c.primary },
  BlinkCmpKindField = { fg = c.secondary },
  BlinkCmpKindVariable = { fg = c.tertiary },
  BlinkCmpKindClass = { fg = c.warning },
  BlinkCmpKindInterface = { fg = c.warning },
  BlinkCmpKindModule = { fg = c.primary },
  BlinkCmpKindProperty = { fg = c.primary },
  BlinkCmpKindUnit = { fg = c.secondary },
  BlinkCmpKindValue = { fg = c.tertiary_fixed_dim },
  BlinkCmpKindEnum = { fg = c.warning },
  BlinkCmpKindKeyword = { fg = c.primary_fixed_dim },
  BlinkCmpKindSnippet = { fg = c.tertiary },
  BlinkCmpKindColor = { fg = c.error },
  BlinkCmpKindFile = { fg = c.primary },
  BlinkCmpKindReference = { fg = c.error },
  BlinkCmpKindFolder = { fg = c.primary },
  BlinkCmpKindEnumMember = { fg = c.secondary_fixed_dim },
  BlinkCmpKindConstant = { fg = c.tertiary_fixed_dim },
  BlinkCmpKindStruct = { fg = c.primary },
  BlinkCmpKindEvent = { fg = c.primary },
  BlinkCmpKindOperator = { fg = c.primary_fixed },
  BlinkCmpKindTypeParameter = { fg = c.tertiary_container },
  BlinkCmpKindCopilot = { fg = c.secondary_fixed_dim },
}
-- }}}1

-- Highlight group overrides {{{1
if vim.go.bg == 'light' then
  -- Light mode overrides are blank as requested
end
-- }}}

-- Set highlight groups {{{1
for name, attr in pairs(hlgroups) do
  vim.api.nvim_set_hl(0, name, attr)
end
-- }}}

-- vim:ts=2:sw=2:sts=2:fdm=marker
