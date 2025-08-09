require('CopilotChat').setup({
  model = 'gpt-4.1',
  temperature = 0.1,
  window = {
    layout = 'vertical',
    width = 0.5,
  },
  auto_insert_mode = true,
})
