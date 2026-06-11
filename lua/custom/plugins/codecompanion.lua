local plugins = {
  {
    src = 'https://www.github.com/olimorris/codecompanion.nvim',
    version = vim.version.range '^19.0.0',
  },
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://www.github.com/ravitemer/codecompanion-history.nvim',
}

vim.schedule(function()
  vim.pack.add(plugins)

  local opencode = require('codecompanion.adapters').extend('openai_compatible', {
    env = { url = 'http://localhost:8330', api_key = 'opencode' },
    schema = { model = { default = 'big-pickle' } },
  })

  local ollama = require('codecompanion.adapters').extend('openai_compatible', {
    schema = { model = { default = 'qwen3:4b' } },
  })

  local gemini = require('codecompanion.adapters').extend('gemini', {
    env = { api_key = os.getenv 'GEMINI_API_KEY' },
    schema = { model = { default = 'gemini-2.5-flash' } },
  })

  require('codecompanion').setup {
    adapters = { http = { opencode = opencode, ollama = ollama, gemini = gemini } },
    strategies = {
      chat = {
        adapter = 'opencode',
        roles = { llm = '✨ Big Pickle' },
        slash_commands = {
          ['file'] = { callback = 'strategies.chat.slash_commands.file', opts = { provider = 'telescope', contains_code = true } },
          ['buffer'] = { callback = 'strategies.chat.slash_commands.buffer' },
          ['symbols'] = { callback = 'strategies.chat.slash_commands.symbols' },
        },
      },
      inline = { adapter = 'opencode' },
      agent = { adapter = 'opencode' },
      cmd = { adapter = 'opencode' },
    },
    display = {
      chat = {
        window = { width = 0.35 },
      },
      action_palette = { width = 0.5, height = 0.3 },
    },
    opts = {
      log_level = 'INFO',
      auto_submit = false,
    },
    extensions = {
      history = {
        enabled = true,
        opts = {
          auto_save = false,
          chat_filter = function(chat_data) return chat_data.cwd == vim.fn.getcwd() end,
        },
      },
    },
  }

  vim.keymap.set('n', '<leader>ac', '<cmd>CodeCompanionChat Toggle<CR>', { desc = '[A]I [C]hat Toggle' })
  vim.keymap.set('n', '<leader>aa', '<cmd>CodeCompanionActions<CR>', { desc = '[A]I [A]ctions' })
  vim.keymap.set('v', '<leader>ac', '<cmd>CodeCompanionChat<CR>', { desc = '[A]I [C]hat Add' })
  vim.keymap.set('v', '<leader>af', '<cmd>CodeCompanion /fix<CR>', { desc = '[A]I [I]nline Assistant' })
  vim.keymap.set('v', '<leader>ae', '<cmd>CodeCompanion /explain<CR>', { desc = '[A]I [E]xplain/Cmd' })
  vim.keymap.set('n', '<leader>ah', '<cmd>CodeCompanionHistory<CR>', { desc = '[A]I [H]istory' })
end)
