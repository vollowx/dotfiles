require('blink.cmp').setup({
  cmdline = { enabled = false },
  completion = {
    list = { selection = { preselect = false, auto_insert = true } },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 0,
      window = { border = 'single' },
    },
    menu = {
      min_width = vim.go.pumwidth,
      max_height = vim.go.pumheight,
      draw = {
        columns = { { 'label' }, { 'kind' } },
        components = {
          label = {
            text = function(ctx)
              return require('colorful-menu').blink_components_text(ctx)
            end,
            highlight = function(ctx)
              return require('colorful-menu').blink_components_highlight(ctx)
            end,
          },
        },
      },
    },
  },
  signature = {
    enabled = true,
    window = { border = 'single' },
  },
  keymap = {
    ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
    ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
  },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
    providers = {
      lsp = {
        -- Don't wait for LSP completions for a long time before fallback to
        -- buffer completions
        -- - https://github.com/Saghen/blink.cmp/issues/2042
        -- - https://cmp.saghen.dev/configuration/sources.html#show-buffer-completions-with-lsp
        timeout_ms = 500,
      },
      buffer = {
        -- Keep first letter capitalization on buffer source
        -- https://cmp.saghen.dev/recipes.html#keep-first-letter-capitalization-on-buffer-source
        transform_items = function(ctx, items)
          local keyword = ctx.get_keyword()
          if not (keyword:match('^%l') or keyword:match('^%u')) then
            return items
          end

          local pattern ---@type string
          local case_func ---@type function
          if keyword:match('^%l') then
            pattern = '^%u%l+$'
            case_func = string.lower
          else
            pattern = '^%l+$'
            case_func = string.upper
          end

          local seen = {}
          local out = {}
          for _, item in ipairs(items) do
            if not item.insertText then
              goto continue
            end

            if item.insertText:match(pattern) then
              local text = case_func(item.insertText:sub(1, 1))
                .. item.insertText:sub(2)
              item.insertText = text
              item.label = text
            end

            if seen[item.insertText] then
              goto continue
            end
            seen[item.insertText] = true

            table.insert(out, item)
            ::continue::
          end
          return out
        end,
      },
    },
  },
  snippets = { preset = pcall(require, 'luasnip') and 'luasnip' or 'default' },
})
