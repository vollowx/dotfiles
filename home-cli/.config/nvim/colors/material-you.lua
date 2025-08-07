-- Clear hlgroups and set colors_name {{{
vim.cmd.hi('clear')
if vim.fn.exists('syntax_on') then
  vim.cmd('syntax reset')
end
vim.g.colors_name = 'material-you'
-- }}}

-- Palette {{{
local json_path = os.getenv("XDG_CACHE_HOME") .. '/md3-generated/colors.json'
local content = table.concat(vim.fn.readfile(json_path), '\n')
local palette = vim.fn.json_decode(content)

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
  CursorLineNr = { fg = c.primary, bold = true },
  LineNr = { fg = c.outline },
  SignColumn = { fg = c.on_surface_variant },
  VertSplit = { fg = c.outline },
  WinSeparator = { link = 'VertSplit' },
  StatusLine = { bg = c.surface_container, fg = c.on_surface_variant },
  StatusLineNC = { bg = c.surface_container_low, fg = c.outline },
  TabLine = { link = 'StatusLineNC' },
  TabLineFill = { link = 'StatusLineNC' },
  TabLineSel = { bg = c.background, fg = c.primary },
  Pmenu = { bg = c.surface_container_high, fg = c.on_surface },
  PmenuSel = { bg = c.primary, fg = c.on_primary },
  PmenuSbar = { bg = c.surface_container_highest },
  PmenuThumb = { bg = c.outline },
  Visual = { bg = c.surface_container_high },
  Folded = { bg = c.surface_container, fg = c.on_surface_variant },
  Search = { bg = c.warning_color_container, fg = c.on_background },
  IncSearch = {
    bg = c.warning_color,
    fg = c.warning_on_color,
    bold = true,
  },

  -- Syntax
  Boolean = { fg = c.tertiary },
  Comment = { fg = c.on_surface_variant },
  Constant = { fg = c.tertiary },
  Character = { link = 'String' },
  Delimiter = { fg = c.outline },
  Error = { fg = c.error, bg = c.error_container },
  ErrorMsg = { fg = c.error },
  Float = { link = 'Number' },
  Function = { fg = c.primary },
  Identifier = { fg = c.on_background },
  Keyword = { fg = c.tertiary },
  Number = { fg = c.primary },
  Operator = { fg = c.on_background },
  PreProc = { fg = c.tertiary },
  Property = { fg = c.on_surface_variant },
  Special = { fg = c.primary },
  Statement = { fg = c.secondary },
  String = { fg = c.secondary },
  Todo = {
    bg = c.warning_color,
    fg = c.warning_on_color,
    bold = true,
  },
  Title = { fg = c.primary, bold = true },
  Type = { fg = c.error },
  Underlined = { fg = c.primary, underline = true },
  WarningMsg = { fg = c.warning_color },

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
  ['@string.regexp'] = { fg = c.warning_color },
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
    fg = c.on_error_container,
    bg = c.error,
    bold = true,
  },
  ['@comment.warning'] = {
    fg = c.warning_on_color_container,
    bg = c.warning_color,
    bold = true,
  },
  ['@comment.todo'] = { link = 'Todo' },
  ['@variable'] = { link = 'Property' },
  ['@variable.builtin'] = { fg = c.primary_fixed_dim },
  ['@markup.list.checked'] = { fg = c.on_tertiary_container, bold = true },
  ['@markup.list.unchecked'] = { fg = c.tertiary },
  ['@type.astro'] = { link = '@tag.astro' },

  -- LSP
  LspCodeLens = { fg = c.on_surface_variant },
  LspReferenceRead = { bg = c.surface_container_high },
  LspReferenceText = { bg = c.surface_container_high },
  LspReferenceWrite = { bg = c.surface_container_high, underline = true },
  LspSignatureActiveParameter = { fg = c.primary, bold = true },

  -- Diagnostic
  DiagnosticError = { fg = c.error },
  DiagnosticWarn = { fg = c.warning_color },
  DiagnosticInfo = { fg = c.secondary },
  DiagnosticHint = { fg = c.tertiary },
  DiagnosticOk = { fg = c.outline },
  DiagnosticSignError = { fg = c.error },
  DiagnosticSignWarn = { fg = c.warning_color },
  DiagnosticSignInfo = { fg = c.secondary },
  DiagnosticSignHint = { fg = c.tertiary },
  DiagnosticSignOk = { fg = c.outline },
  DiagnosticUnderlineError = { sp = c.error, undercurl = true },
  DiagnosticUnderlineWarn = { sp = c.warning_color, undercurl = true },
  DiagnosticUnderlineInfo = { sp = c.primary, undercurl = true },
  DiagnosticUnderlineHint = { sp = c.secondary, undercurl = true },
  DiagnosticUnderlineOk = { sp = c.secondary, undercurl = true },
  DiagnosticVirtualTextError = {
    fg = c.on_error_container,
    bg = c.error_container,
  },
  DiagnosticVirtualTextWarn = {
    fg = c.warning_on_color_container,
    bg = c.warning_color_container,
  },
  DiagnosticVirtualTextInfo = {
    fg = c.on_secondary_container,
    bg = c.secondary_container,
  },
  DiagnosticVirtualTextHint = {
    fg = c.on_tertiary_container,
    bg = c.tertiary_container,
  },

  -- Plugins
  StatusLineHeader = {
    fg = c.on_surface,
    bg = c.surface_container_highest,
  },
  StatusLineHeaderModified = {
    fg = c.on_error_container,
    bg = c.error_container,
  },

  GitSignsAdd = { fg = c.primary },
  GitSignsChange = { fg = c.warning_color },
  GitSignsDelete = { fg = c.error },

  BlinkCmpDocBorder = { link = 'FloatBorder' },
  BlinkCmpSignatureHelpBorder = { link = 'FloatBorder' },
  BlinkCmpKindText = { fg = c.secondary },
  BlinkCmpKindMethod = { fg = c.primary },
  BlinkCmpKindFunction = { fg = c.primary },
  BlinkCmpKindConstructor = { fg = c.primary },
  BlinkCmpKindField = { fg = c.secondary },
  BlinkCmpKindVariable = { fg = c.tertiary },
  BlinkCmpKindClass = { fg = c.warning_color },
  BlinkCmpKindInterface = { fg = c.warning_color },
  BlinkCmpKindModule = { fg = c.primary },
  BlinkCmpKindProperty = { fg = c.primary },
  BlinkCmpKindUnit = { fg = c.secondary },
  BlinkCmpKindValue = { fg = c.tertiary_fixed_dim },
  BlinkCmpKindEnum = { fg = c.warning_color },
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
