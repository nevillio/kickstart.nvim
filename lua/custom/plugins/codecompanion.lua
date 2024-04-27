return {
  'olimorris/codecompanion.nvim',
  config = function()
    vim.keymap.set('n', '<leader>tc', ':CodeCompanionChat Toggle<CR>', { desc = '[T]oggle [C]odeCompanion' })
    require('codecompanion').setup {
      adapters = {
        gemini = require('codecompanion.adapters').extend('gemini', {
          env = {
            api_key = os.getenv 'GEMINI_API_KEY',
          },
          schema = {
            model = {
              default = 'gemini-2.0-flash-thinking-exp',
            },
          },
        }),
      },
      strategies = {
        chat = {
          adapter = 'gemini',
          slash_commands = {
            ['file'] = {
              callback = 'strategies.chat.slash_commands.file',
              description = 'Select a file using telescope',
              opts = {
                provider = 'telescope',
                contains_code = true,
              },
            },
          },
        },
        inline = {
          adapter = 'gemini',
        },
        cmd = {
          adapter = 'gemini',
        },
      },
      display = {
        chat = {
          window = {
            width = 0.3,
          },
        },
      },
    }
  end,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
}
