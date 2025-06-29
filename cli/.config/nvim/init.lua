-- Disable validation for speed
---@diagnostic disable-next-line: duplicate-set-field
vim.validate = function() end

-- Enable faster lua loader using byte-compilation
-- https://github.com/neovim/neovim/commit/2257ade3dc2daab5ee12d27807c0b3bcf103cd29
vim.loader.enable()

_G.settings = {
  ui = {
    border = 'shadow',
    border_preview = 'solid',
    border_input = 'rounded',
    background = 'dark',
    colorscheme = 'catppuccin-macchiato',
  },
}

-- stylua: ignore start
_G.icons      = {
  diagnostics = {
    DiagnosticSignError = '󰅚 ',
    DiagnosticSignHint  = '󰌶 ',
    DiagnosticSignInfo  = '󰋽 ',
    DiagnosticSignOk    = '󰄬 ',
    DiagnosticSignWarn  = '󰀪 ',
  },
  kinds       = {
    Array             = '󰅪 ',
    Boolean           = ' ',
    BreakStatement    = '󰙧 ',
    Call              = '󰃷 ',
    CaseStatement     = '󱃙 ',
    Class             = ' ',
    Color             = '󰏘 ',
    Constant          = '󰏿 ',
    Constructor       = '󰒓 ',
    ContinueStatement = '→ ',
    Declaration       = '󰙠 ',
    Delete            = '󰩺 ',
    DoStatement       = '󰑖 ',
    Enum              = ' ',
    EnumMember        = ' ',
    Event             = ' ',
    Field             = ' ',
    File              = '󰈔 ',
    Folder            = '󰉋 ',
    ForStatement      = '󰑖 ',
    Format            = '󰗈 ',
    Function          = '󰊕 ',
    H1Marker          = '󰉫 ',
    H2Marker          = '󰉬 ',
    H3Marker          = '󰉭 ',
    H4Marker          = '󰉮 ',
    H5Marker          = '󰉯 ',
    H6Marker          = '󰉰 ',
    Identifier        = '󰀫 ',
    IfStatement       = '󰇉 ',
    Interface         = ' ',
    Keyboard          = '󰥻 ',
    Keyword           = '󰌋 ',
    List              = '󰅪 ',
    Log               = '󰦪 ',
    Lsp               = ' ',
    Macro             = '󰁌 ',
    MarkdownH1        = '󰉫 ',
    MarkdownH2        = '󰉬 ',
    MarkdownH3        = '󰉭 ',
    MarkdownH4        = '󰉮 ',
    MarkdownH5        = '󰉯 ',
    MarkdownH6        = '󰉰 ',
    Method            = '󰆧 ',
    Module            = '󰏗 ',
    Namespace         = '󰅩 ',
    Null              = '󰢤 ',
    Number            = '󰎠 ',
    Object            = '󰅩 ',
    Operator          = '󰆕 ',
    Package           = '󰆦 ',
    Pair              = '󰅪 ',
    Property          = ' ',
    Reference         = '󰦾 ',
    Regex             = ' ',
    Repeat            = '󰑖 ',
    Scope             = '󰅩 ',
    Snippet           = '󰩫 ',
    Specifier         = '󰦪 ',
    Statement         = '󰅩 ',
    String            = '󰉾 ',
    Struct            = ' ',
    SwitchStatement   = '󰺟 ',
    Terminal          = ' ',
    Text              = ' ',
    Type              = ' ',
    TypeParameter     = '󰆩 ',
    Unit              = ' ',
    Value             = '󰎠 ',
    Variable          = '󰀫 ',
    WhileStatement    = '󰑖 ',
  },
  ft          = {
    Config = '󰒓 ',
    Lua    = ' ',
  },
  ui          = {
    AngleDown           = ' ',
    AngleLeft           = ' ',
    AngleRight          = ' ',
    AngleUp             = ' ',
    ArrowDown           = '↓ ',
    ArrowLeft           = '← ',
    ArrowRight          = '→ ',
    ArrowUp             = '↑ ',
    Branch              = ' ',
    Calculator          = '󰃬 ',
    CircleDots          = '󰧞 ',
    Copilot             = ' ',
    CopilotError        = ' ',
    CopilotWarning      = ' ',
    Cmd                 = '󰞷 ',
    Cross               = '󰅖 ',
    Ok                  = '󰄬 ',
    Diamond             = '◆ ',
    Ellipsis            = '… ',
    Ghost               = '󰊠 ',
    GitSignAdd          = '▍ ',
    GitSignChange       = '▍ ',
    GitSignChangedelete = '▍ ',
    GitSignDelete       = '▁ ',
    GitSignTopdelete    = '▔ ',
    GitSignUntracked    = '▍ ',
    Help                = '󰘥 ',
    Lazy                = '󰒲 ',
    Magnify             = '󰍉 ',
    Neovim              = ' ',
    Pin                 = '󰐃 ',
    Play                = '󰼛 ',
    TriangleDown        = '▼ ',
    TriangleLeft        = '◀ ',
    TriangleRight       = '▶ ',
    TriangleUp          = '▲ ',
  },
}
-- stylua: ignore end

vim.g.has_ui = #vim.api.nvim_list_uis() > 0
vim.g.has_gui = vim.g.has_ui
  and (vim.env.DISPLAY ~= nil or vim.env.WAYLAND_DISPLAY ~= nil)

require('core.opts')
require('core.mappings')
require('core.autocmds')
require('core.lsp')
require('core.plugins')

vim.go.bg = settings.ui.background

if not vim.g.has_gui then
  if vim.g.has_ui then
    vim.cmd.colorscheme('default')
  end
  return
end

vim.cmd.colorscheme({
  args = { settings.ui.colorscheme },
  mods = { emsg_silent = true },
})
