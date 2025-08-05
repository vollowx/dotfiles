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
  c_primary                   = { '#b1d18a', nil }
  c_surfaceTint               = { '#b1d18a', nil }
  c_onPrimary                 = { '#1f3701', nil }
  c_primaryContainer          = { '#354e16', nil }
  c_onPrimaryContainer        = { '#cdeda3', nil }
  c_secondary                 = { '#bfcbad', nil }
  c_onSecondary               = { '#2a331e', nil }
  c_secondaryContainer        = { '#404a33', nil }
  c_onSecondaryContainer      = { '#dce7c8', nil }
  c_tertiary                  = { '#a0d0cb', nil }
  c_onTertiary                = { '#003735', nil }
  c_tertiaryContainer         = { '#1f4e4b', nil }
  c_onTertiaryContainer       = { '#bcece7', nil }
  c_error                     = { '#ffb4ab', nil }
  c_onError                   = { '#690005', nil }
  c_errorContainer            = { '#93000a', nil }
  c_onErrorContainer          = { '#ffdad6', nil }
  c_background                = { '#12140e', nil }
  c_onBackground              = { '#e2e3d8', nil }
  c_surface                   = { '#12140e', nil }
  c_onSurface                 = { '#e2e3d8', nil }
  c_surfaceVariant            = { '#44483d', nil }
  c_onSurfaceVariant          = { '#c5c8ba', nil }
  c_outline                   = { '#8f9285', nil }
  c_outlineVariant            = { '#44483d', nil }
  c_shadow                    = { '#000000', nil }
  c_scrim                     = { '#000000', nil }
  c_inverseSurface            = { '#e2e3d8', nil }
  c_inverseOnSurface          = { '#2f312a', nil }
  c_inversePrimary            = { '#4c662b', nil }
  c_primaryFixed              = { '#cdeda3', nil }
  c_onPrimaryFixed            = { '#102000', nil }
  c_primaryFixedDim           = { '#b1d18a', nil }
  c_onPrimaryFixedVariant     = { '#354e16', nil }
  c_secondaryFixed            = { '#dce7c8', nil }
  c_onSecondaryFixed          = { '#151e0b', nil }
  c_secondaryFixedDim         = { '#bfcbad', nil }
  c_onSecondaryFixedVariant   = { '#404a33', nil }
  c_tertiaryFixed             = { '#bcece7', nil }
  c_onTertiaryFixed           = { '#00201e', nil }
  c_tertiaryFixedDim          = { '#a0d0cb', nil }
  c_onTertiaryFixedVariant    = { '#1f4e4b', nil }
  c_surfaceDim                = { '#12140e', nil }
  c_surfaceBright             = { '#383a32', nil }
  c_surfaceContainerLowest    = { '#0c0f09', nil }
  c_surfaceContainerLow       = { '#1a1c16', nil }
  c_surfaceContainer          = { '#1e201a', nil }
  c_surfaceContainerHigh      = { '#282b24', nil }
  c_surfaceContainerHighest   = { '#33362e', nil }
  c_warningColor              = { '#d9c76f', nil }
  c_warningOnColor            = { '#393000', nil }
  c_warningColorContainer     = { '#524700', nil }
  c_warningOnColorContainer   = { '#f6e388', nil }
else
  c_primary                   = { '#4c662b', nil }
  c_surfaceTint               = { '#4c662b', nil }
  c_onPrimary                 = { '#ffffff', nil }
  c_primaryContainer          = { '#cdeda3', nil }
  c_onPrimaryContainer        = { '#354e16', nil }
  c_secondary                 = { '#586249', nil }
  c_onSecondary               = { '#ffffff', nil }
  c_secondaryContainer        = { '#dce7c8', nil }
  c_onSecondaryContainer      = { '#404a33', nil }
  c_tertiary                  = { '#386663', nil }
  c_onTertiary                = { '#ffffff', nil }
  c_tertiaryContainer         = { '#bcece7', nil }
  c_onTertiaryContainer       = { '#1f4e4b', nil }
  c_error                     = { '#ba1a1a', nil }
  c_onError                   = { '#ffffff', nil }
  c_errorContainer            = { '#ffdad6', nil }
  c_onErrorContainer          = { '#93000a', nil }
  c_background                = { '#f9faef', nil }
  c_onBackground              = { '#1a1c16', nil }
  c_surface                   = { '#f9faef', nil }
  c_onSurface                 = { '#1a1c16', nil }
  c_surfaceVariant            = { '#e1e4d5', nil }
  c_onSurfaceVariant          = { '#44483d', nil }
  c_outline                   = { '#75796c', nil }
  c_outlineVariant            = { '#c5c8ba', nil }
  c_shadow                    = { '#000000', nil }
  c_scrim                     = { '#000000', nil }
  c_inverseSurface            = { '#2f312a', nil }
  c_inverseOnSurface          = { '#f1f2e1', nil }
  c_inversePrimary            = { '#b1d18a', nil }
  c_primaryFixed              = { '#cdeda3', nil }
  c_onPrimaryFixed            = { '#102000', nil }
  c_primaryFixedDim           = { '#b1d18a', nil }
  c_onPrimaryFixedVariant     = { '#354e16', nil }
  c_secondaryFixed            = { '#dce7c8', nil }
  c_onSecondaryFixed          = { '#151e0b', nil }
  c_secondaryFixedDim         = { '#bfcbad', nil }
  c_onSecondaryFixedVariant   = { '#404a33', nil }
  c_tertiaryFixed             = { '#bcece7', nil }
  c_onTertiaryFixed           = { '#00201e', nil }
  c_tertiaryFixedDim          = { '#a0d0cb', nil }
  c_onTertiaryFixedVariant    = { '#1f4e4b', nil }
  c_surfaceDim                = { '#dadbca', nil }
  c_surfaceBright             = { '#f9faef', nil }
  c_surfaceContainerLowest    = { '#ffffff', nil }
  c_surfaceContainerLow       = { '#f3f4e5', nil }
  c_surfaceContainer          = { '#eeefe7', nil }
  c_surfaceContainerHigh      = { '#e8e9de', nil }
  c_surfaceContainerHighest   = { '#e2e3d8', nil }
  c_warningColor              = { '#6c5e10', nil }
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
  Comment = { fg = c_onSurfaceVariant, italic = true },
  Constant = { fg = c_tertiary },
  String = { fg = c_secondary },
  Character = { link = 'String' },
  Number = { fg = c_tertiary },
  Boolean = { fg = c_tertiary },
  Float = { link = 'Number' },
  Function = { fg = c_primary },
  Identifier = { link = 'Normal' },
  Statement = { fg = c_secondary },
  Keyword = { fg = c_secondary, italic = true },
  Operator = { fg = c_onBackground },
  PreProc = { fg = c_secondary },
  Type = { fg = c_secondary, italic = true },
  Special = { fg = c_tertiary },
  Underlined = { fg = c_primary, underline = true },
  Error = { fg = c_error, bg = c_errorContainer },
  ErrorMsg = { fg = c_error },
  WarningMsg = { fg = c_warningColor },
  Todo = { bg = c_warningColor, fg = c_warningOnColor, bold = true },
  Title = { fg = c_primary, bold = true },
  Delimiter = { fg = c_outline },
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
  ['@tag.attribute'] = { fg = c_secondary },
  ['@tag.delimiter'] = { link = 'Delimiter' },
  ['@markup.strong'] = { bold = true },
  ['@markup.emphasis'] = { italic = true },
  ['@markup.heading'] = { link = 'Title' },
  ['@markup.link.url'] = { fg = c_secondary, underline = true },
  ['@markup.raw'] = { link = 'String' },
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
  DiagnosticVirtualTextError = { fg = c_error },
  DiagnosticVirtualTextWarn = { fg = c_warningColor },
  DiagnosticVirtualTextInfo = { fg = c_secondary },
  DiagnosticVirtualTextHint = { fg = c_tertiary },
  DiagnosticVirtualLinesError = { fg = c_error },
  DiagnosticVirtualLinesWarn = { fg = c_warningColor },
  DiagnosticVirtualLinesInfo = { fg = c_secondary },
  DiagnosticVirtualLinesHint = { fg = c_tertiary },
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
