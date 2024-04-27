return {
  'olimorris/codecompanion.nvim',
  opts = {},
  config = function()
    require('codecompanion').setup {
      adapters = {
        gemini = require('codecompanion.adapters').extend('gemini', {
          env = {
            api_key = 'AIzaSyAAKPS0pyauvrgo_G_DjahIV7s83F_G-s0',
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
  keys = {
    { '<leader>cc', ':CodeCompanionChat<CR>', desc = 'Open [C]odeCompanion [C]hat' },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
}
