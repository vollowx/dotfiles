return {
  {
    src = 'https://github.com/xzbdmw/colorful-menu.nvim',
    data = { 
      on = 'InsertEnter',
      load = function(plug_data) 
        vim.cmd.packadd(plug_data.spec.name) 
      end 
    }
  },
  {
    src = 'https://github.com/saghen/blink.cmp',
    version = vim.version.range('v1.*'),
    data = {
      on = 'InsertEnter',
      load = function(plug_data)
        -- Ensure both are loaded
        vim.cmd.packadd('colorful-menu.nvim')
        vim.cmd.packadd(plug_data.spec.name)

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
              lsp = { timeout_ms = 500 },
              buffer = {
                transform_items = function(ctx, items)
                  local keyword = ctx.get_keyword()
                  if not (keyword:match('^%l') or keyword:match('^%u')) then return items end
                  local pattern, case_func
                  if keyword:match('^%l') then
                    pattern, case_func = '^%u%l+$', string.lower
                  else
                    pattern, case_func = '^%l+$', string.upper
                  end
                  local seen, out = {}, {}
                  for _, item in ipairs(items) do
                    if item.insertText then
                      if item.insertText:match(pattern) then
                        local text = case_func(item.insertText:sub(1, 1)) .. item.insertText:sub(2)
                        item.insertText, item.label = text, text
                      end
                      if not seen[item.insertText] then
                        seen[item.insertText] = true
                        table.insert(out, item)
                      end
                    end
                  end
                  return out
                end,
              },
            },
          },
          snippets = { preset = pcall(require, 'luasnip') and 'luasnip' or 'default' },
        })
      end,
    },
  },
}
