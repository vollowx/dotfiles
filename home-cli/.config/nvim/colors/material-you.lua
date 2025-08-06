-- Clear hlgroups and set colors_name {{{
vim.cmd.hi('clear')
if vim.fn.exists('syntax_on') then
  vim.cmd('syntax reset')
end
vim.g.colors_name = 'material-you'
-- }}}

-- Palette {{{
-- stylua: ignore start
local c_primary
local c_surfaceTint
local c_onPrimary
local c_primaryContainer
local c_onPrimaryContainer
local c_secondary
local c_onSecondary
local c_secondaryContainer
local c_onSecondaryContainer
local c_tertiary
local c_onTertiary
local c_tertiaryContainer
local c_onTertiaryContainer
local c_error
local c_onError
local c_errorContainer
local c_onErrorContainer
local c_background
local c_onBackground
local c_surface
local c_onSurface
local c_surfaceVariant
local c_onSurfaceVariant
local c_outline
local c_outlineVariant
local c_shadow
local c_scrim
local c_inverseSurface
local c_inverseOnSurface
local c_inversePrimary
local c_primaryFixed
local c_onPrimaryFixed
local c_primaryFixedDim
local c_onPrimaryFixedVariant
local c_secondaryFixed
local c_onSecondaryFixed
local c_secondaryFixedDim
local c_onSecondaryFixedVariant
local c_tertiaryFixed
local c_onTertiaryFixed
local c_tertiaryFixedDim
local c_onTertiaryFixedVariant
local c_surfaceDim
local c_surfaceBright
local c_surfaceContainerLowest
local c_surfaceContainerLow
local c_surfaceContainer
local c_surfaceContainerHigh
local c_surfaceContainerHighest
local c_warningColor
local c_warningOnColor
local c_warningColorContainer
local c_warningOnColorContainer

if vim.go.bg == 'dark' then
  c_primary                   = { '#DBB9F9', nil }
  c_surfaceTint               = { '#DBB9F9', nil }
  c_onPrimary                 = { '#3F2458', nil }
  c_primaryContainer          = { '#563A70', nil }
  c_onPrimaryContainer        = { '#F0DBFF', nil }
  c_secondary                 = { '#D0C1D9', nil }
  c_onSecondary               = { '#362C3F', nil }
  c_secondaryContainer        = { '#4E4356', nil }
  c_onSecondaryContainer      = { '#EDDDF6', nil }
  c_tertiary                  = { '#F3B7BD', nil }
  c_onTertiary                = { '#4B252A', nil }
  c_tertiaryContainer         = { '#653A40', nil }
  c_onTertiaryContainer       = { '#FFD9DC', nil }
  c_error                     = { '#FFB4AB', nil }
  c_onError                   = { '#690005', nil }
  c_errorContainer            = { '#93000A', nil }
  c_onErrorContainer          = { '#FFDAD6', nil }
  c_background                = { '#151217', nil }
  c_onBackground              = { '#E8E0E8', nil }
  c_surface                   = { '#151217', nil }
  c_onSurface                 = { '#E8E0E8', nil }
  c_surfaceVariant            = { '#4A454E', nil }
  c_onSurfaceVariant          = { '#CCC4CE', nil }
  c_outline                   = { '#968E98', nil }
  c_outlineVariant            = { '#4A454E', nil }
  c_shadow                    = { '#000000', nil }
  c_scrim                     = { '#000000', nil }
  c_inverseSurface            = { '#E8E0E8', nil }
  c_inverseOnSurface          = { '#332F35', nil }
  c_inversePrimary            = { '#6F528A', nil }
  c_primaryFixed              = { '#F0DBFF', nil }
  c_onPrimaryFixed            = { '#280D42', nil }
  c_primaryFixedDim           = { '#DBB9F9', nil }
  c_onPrimaryFixedVariant     = { '#563A70', nil }
  c_secondaryFixed            = { '#EDDDF6', nil }
  c_onSecondaryFixed          = { '#211829', nil }
  c_secondaryFixedDim         = { '#D0C1D9', nil }
  c_onSecondaryFixedVariant   = { '#4E4356', nil }
  c_tertiaryFixed             = { '#FFD9DC', nil }
  c_onTertiaryFixed           = { '#321016', nil }
  c_tertiaryFixedDim          = { '#F3B7BD', nil }
  c_onTertiaryFixedVariant    = { '#653A40', nil }
  c_surfaceDim                = { '#151217', nil }
  c_surfaceBright             = { '#3C383E', nil }
  c_surfaceContainerLowest    = { '#100D12', nil }
  c_surfaceContainerLow       = { '#1E1A20', nil }
  c_surfaceContainer          = { '#221E24', nil }
  c_surfaceContainerHigh      = { '#2C292E', nil }
  c_surfaceContainerHighest   = { '#373339', nil }
  c_warningColor              = { '#827200', nil }
  c_warningOnColor            = { '#393000', nil }
  c_warningColorContainer     = { '#524700', nil }
  c_warningOnColorContainer   = { '#f6e388', nil }
else
  c_primary                   = { '#6F528A', nil }
  c_surfaceTint               = { '#6F528A', nil }
  c_onPrimary                 = { '#FFFFFF', nil }
  c_primaryContainer          = { '#F0DBFF', nil }
  c_onPrimaryContainer        = { '#563A70', nil }
  c_secondary                 = { '#665A6F', nil }
  c_onSecondary               = { '#FFFFFF', nil }
  c_secondaryContainer        = { '#EDDDF6', nil }
  c_onSecondaryContainer      = { '#4E4356', nil }
  c_tertiary                  = { '#805157', nil }
  c_onTertiary                = { '#FFFFFF', nil }
  c_tertiaryContainer         = { '#FFD9DC', nil }
  c_onTertiaryContainer       = { '#653A40', nil }
  c_error                     = { '#BA1A1A', nil }
  c_onError                   = { '#FFFFFF', nil }
  c_errorContainer            = { '#FFDAD6', nil }
  c_onErrorContainer          = { '#93000A', nil }
  c_background                = { '#FFF7FE', nil }
  c_onBackground              = { '#1E1A20', nil }
  c_surface                   = { '#FFF7FE', nil }
  c_onSurface                 = { '#1E1A20', nil }
  c_surfaceVariant            = { '#E9DFEB', nil }
  c_onSurfaceVariant          = { '#4A454E', nil }
  c_outline                   = { '#7C757E', nil }
  c_outlineVariant            = { '#CCC4CE', nil }
  c_shadow                    = { '#000000', nil }
  c_scrim                     = { '#000000', nil }
  c_inverseSurface            = { '#332F35', nil }
  c_inverseOnSurface          = { '#F7EEF6', nil }
  c_inversePrimary            = { '#DBB9F9', nil }
  c_primaryFixed              = { '#F0DBFF', nil }
  c_onPrimaryFixed            = { '#280D42', nil }
  c_primaryFixedDim           = { '#DBB9F9', nil }
  c_onPrimaryFixedVariant     = { '#563A70', nil }
  c_secondaryFixed            = { '#EDDDF6', nil }
  c_onSecondaryFixed          = { '#211829', nil }
  c_secondaryFixedDim         = { '#D0C1D9', nil }
  c_onSecondaryFixedVariant   = { '#4E4356', nil }
  c_tertiaryFixed             = { '#FFD9DC', nil }
  c_onTertiaryFixed           = { '#321016', nil }
  c_tertiaryFixedDim          = { '#F3B7BD', nil }
  c_onTertiaryFixedVariant    = { '#653A40', nil }
  c_surfaceDim                = { '#DFD8DF', nil }
  c_surfaceBright             = { '#FFF7FE', nil }
  c_surfaceContainerLowest    = { '#FFFFFF', nil }
  c_surfaceContainerLow       = { '#F9F1F9', nil }
  c_surfaceContainer          = { '#F4EBF3', nil }
  c_surfaceContainerHigh      = { '#EEE6EE', nil }
  c_surfaceContainerHighest   = { '#E8E0E8', nil }
  c_warningColor              = { '#827200', nil }
  c_warningOnColor            = { '#ffffff', nil }
  c_warningColorContainer     = { '#f6e388', nil }
  c_warningOnColorContainer   = { '#524700', nil }
end
-- stylua: ignore end
-- }}}

-- Highlight groups {{{1
local hlgroups = {
  -- UI {{{2
  Normal = { bg = c_background, fg = c_onBackground },
  NormalFloat = { bg = c_surfaceContainerLowest, fg = c_onSurface },
  FloatBorder = { bg = c_surfaceContainerLowest, fg = c_outline },
  ColorColumn = { bg = c_surfaceContainerLow },
  Cursor = { bg = c_onBackground, fg = c_background },
  CursorLine = { bg = c_surfaceContainerLow },
  CursorLineNr = { fg = c_primary, bold = true },
  LineNr = { fg = c_outline },
  SignColumn = { fg = c_onSurfaceVariant },
  VertSplit = { fg = c_outline },
  WinSeparator = { link = 'VertSplit' },
  StatusLine = { bg = c_surfaceContainer, fg = c_onSurfaceVariant },
  StatusLineNC = { bg = c_surfaceContainerLow, fg = c_outline },
  TabLine = { link = 'StatusLineNC' },
  TabLineFill = { link = 'StatusLineNC' },
  TabLineSel = { bg = c_background, fg = c_primary },
  Pmenu = { bg = c_surfaceContainerHigh, fg = c_onSurface },
  PmenuSel = { bg = c_primary, fg = c_onPrimary },
  PmenuSbar = { bg = c_surfaceContainerHighest },
  PmenuThumb = { bg = c_outline },
  Visual = { bg = c_surfaceContainerHigh },
  Folded = { bg = c_surfaceContainer, fg = c_onSurfaceVariant },
  Search = { bg = c_warningColorContainer, fg = c_onBackground },
  IncSearch = { bg = c_warningColor, fg = c_warningOnColor, bold = true },
  -- }}}2

  -- Syntax {{{2
  Boolean = { fg = c_tertiary },
  Comment = { fg = c_onSurfaceVariant },
  Constant = { fg = c_tertiary },
  Character = { link = 'String' },
  Delimiter = { fg = c_outline },
  Error = { fg = c_error, bg = c_errorContainer },
  ErrorMsg = { fg = c_error },
  Float = { link = 'Number' },
  Function = { fg = c_primary },
  Identifier = { fg = c_onBackground },
  Keyword = { fg = c_tertiary },
  Number = { fg = c_primary },
  Operator = { fg = c_onBackground },
  PreProc = { fg = c_tertiary },
  Property = { fg = c_onSurfaceVariant },
  Special = { fg = c_primary },
  Statement = { fg = c_secondary },
  String = { fg = c_secondary },
  Todo = { bg = c_warningColor, fg = c_warningOnColor, bold = true },
  Title = { fg = c_primary, bold = true },
  Type = { fg = c_error },
  Underlined = { fg = c_primary, underline = true },
  WarningMsg = { fg = c_warningColor },
  -- }}}

  -- Treesitter syntax {{{2
  ['@attribute'] = { link = 'Constant' },
  ['@constructor'] = { fg = c_primary },
  ['@keyword.import'] = { link = 'PreProc' },
  ['@keyword.operator'] = { bold = true, fg = c_primaryFixedDim },
  ['@keyword.return'] = { link = 'Statement' },
  ['@module'] = { fg = c_tertiary },
  ['@operator'] = { link = 'Operator' },
  ['@punctuation.bracket'] = { link = 'Delimiter' },
  ['@punctuation.delimiter'] = { link = 'Delimiter' },
  ['@string.escape'] = { fg = c_tertiaryFixed },
  ['@string.regexp'] = { fg = c_warningColor },
  ['@string.plain.css'] = { fg = c_primary },
  ['@tag.attribute'] = { fg = c_tertiary },
  ['@tag.delimiter'] = { link = 'Delimiter' },
  ['@type.tag.css'] = { link = '@tag.css' },
  ['@markup.strong'] = { bold = true },
  ['@markup.emphasis'] = { italic = true },
  ['@markup.heading'] = { fg = c_error },
  ['@markup.link.url'] = { fg = c_secondary, underline = true },
  ['@markup.raw'] = { link = 'String' },
  ['@markup.quote'] = { link = 'String' },
  ['@comment.error'] = { fg = c_onErrorContainer, bg = c_error, bold = true },
  ['@comment.warning'] = {
    fg = c_warningOnColorContainer,
    bg = c_warningColor,
    bold = true,
  },
  ['@comment.todo'] = { link = 'Todo' },
  ['@variable'] = { link = 'Property' },
  ['@variable.builtin'] = { fg = c_primaryFixedDim },
  ['@markup.list.checked'] = { fg = c_onTertiaryContainer, bold = true },
  ['@markup.list.unchecked'] = { fg = c_tertiary },
  ['@type.astro'] = { link = '@tag.astro' },
  -- }}}

  -- LSP {{{2
  LspCodeLens = { fg = c_onSurfaceVariant },
  LspReferenceRead = { bg = c_surfaceContainerHigh },
  LspReferenceText = { bg = c_surfaceContainerHigh },
  LspReferenceWrite = { bg = c_surfaceContainerHigh, underline = true },
  LspSignatureActiveParameter = { fg = c_warningColor, bold = true },
  -- }}}

  -- Diagnostic {{{2
  DiagnosticError = { fg = c_error },
  DiagnosticWarn = { fg = c_warningColor },
  DiagnosticInfo = { fg = c_secondary },
  DiagnosticHint = { fg = c_tertiary },
  DiagnosticOk = { fg = c_outline },
  DiagnosticSignError = { fg = c_error },
  DiagnosticSignWarn = { fg = c_warningColor },
  DiagnosticSignInfo = { fg = c_secondary },
  DiagnosticSignHint = { fg = c_tertiary },
  DiagnosticSignOk = { fg = c_outline },
  DiagnosticUnderlineError = { sp = c_error, undercurl = true },
  DiagnosticUnderlineWarn = { sp = c_warningColor, undercurl = true },
  DiagnosticUnderlineInfo = { sp = c_primary, undercurl = true },
  DiagnosticUnderlineHint = { sp = c_secondary, undercurl = true },
  DiagnosticUnderlineOk = { sp = c_secondary, undercurl = true },
  DiagnosticVirtualTextError = {
    fg = c_onErrorContainer,
    bg = c_errorContainer,
  },
  DiagnosticVirtualTextWarn = {
    fg = c_warningOnColorContainer,
    bg = c_warningColorContainer,
  },
  DiagnosticVirtualTextInfo = {
    fg = c_onSecondaryContainer,
    bg = c_secondaryContainer,
  },
  DiagnosticVirtualTextHint = {
    fg = c_onTertiaryContainer,
    bg = c_tertiaryContainer,
  },
  -- }}}

  -- Plugins {{{2
  -- statusline
  StatusLineHeader = {
    fg = c_onSurface,
    bg = c_surfaceContainerHighest,
  },
  StatusLineHeaderModified = {
    fg = c_onErrorContainer,
    bg = c_errorContainer,
  },

  -- gitsigns
  GitSignsAdd = { fg = c_primary },
  GitSignsChange = { fg = c_warningColor },
  GitSignsDelete = { fg = c_error },

  -- blink
  BlinkCmpDocBorder = { link = 'FloatBorder' },
  BlinkCmpSignatureHelpBorder = { link = 'FloatBorder' },
  BlinkCmpKindText = { fg = c_secondary },
  BlinkCmpKindMethod = { fg = c_primary },
  BlinkCmpKindFunction = { fg = c_primary },
  BlinkCmpKindConstructor = { fg = c_primary },
  BlinkCmpKindField = { fg = c_secondary },
  BlinkCmpKindVariable = { fg = c_tertiary },
  BlinkCmpKindClass = { fg = c_warningColor },
  BlinkCmpKindInterface = { fg = c_warningColor },
  BlinkCmpKindModule = { fg = c_primary },
  BlinkCmpKindProperty = { fg = c_primary },
  BlinkCmpKindUnit = { fg = c_secondary },
  BlinkCmpKindValue = { fg = c_tertiaryFixedDim },
  BlinkCmpKindEnum = { fg = c_warningColor },
  BlinkCmpKindKeyword = { fg = c_primaryFixedDim },
  BlinkCmpKindSnippet = { fg = c_tertiary },
  BlinkCmpKindColor = { fg = c_error },
  BlinkCmpKindFile = { fg = c_primary },
  BlinkCmpKindReference = { fg = c_error },
  BlinkCmpKindFolder = { fg = c_primary },
  BlinkCmpKindEnumMember = { fg = c_secondaryFixedDim },
  BlinkCmpKindConstant = { fg = c_tertiaryFixedDim },
  BlinkCmpKindStruct = { fg = c_primary },
  BlinkCmpKindEvent = { fg = c_primary },
  BlinkCmpKindOperator = { fg = c_primaryFixed },
  BlinkCmpKindTypeParameter = { fg = c_tertiaryContainer },
  BlinkCmpKindCopilot = { fg = c_secondaryFixedDim },
  -- }}}
}
-- }}}1

-- Highlight group overrides {{{1
if vim.go.bg == 'light' then
  -- Light mode overrides are blank as requested
end
-- }}}

-- Set highlight groups {{{1
for name, attr in pairs(hlgroups) do
  attr.ctermbg = attr.bg and attr.bg[2]
  attr.ctermfg = attr.fg and attr.fg[2]
  attr.bg = attr.bg and attr.bg[1]
  attr.fg = attr.fg and attr.fg[1]
  attr.sp = attr.sp and attr.sp[1]
  vim.api.nvim_set_hl(0, name, attr)
end
-- }}}

-- vim:ts=2:sw=2:sts=2:fdm=marker
