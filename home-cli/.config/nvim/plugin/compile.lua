local function run_compile(is_loclist)
  local cmd = vim.fn.input('Compile command: ', 'make -k')

  if cmd == '' then
    print('\nCompilation cancelled.')
    return
  end

  local old_makeprg = vim.bo.makeprg

  vim.bo.makeprg = cmd

  if is_loclist then
    vim.cmd('lmake!')
    vim.cmd('lopen')
  else
    vim.cmd('make!')
    vim.cmd('copen')
  end

  vim.bo.makeprg = old_makeprg
end

-- Create the User Commands
vim.api.nvim_create_user_command('Compile', function()
  run_compile(false)
end, { desc = 'Run a command into the Quickfix list' })

vim.api.nvim_create_user_command('LCompile', function()
  run_compile(true)
end, { desc = 'Run a command into the Location list' })
