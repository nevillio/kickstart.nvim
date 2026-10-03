vim.pack.add { 'https://github.com/supermaven-inc/supermaven-nvim' }
vim.api.nvim_create_autocmd('UIEnter', {
  once = true,
  callback = function()
    local supermaven = require 'supermaven-nvim'
    supermaven.setup {
      keymaps = {
        accept_suggestion = '<C-g>',
      },
      ignore_filetypes = {
        javascript = true,
        typescript = true,
        python = true,
        codecompanion = true,
      },
    }
    vim.keymap.set('n', '<leader>ts', '<cmd>SupermavenToggle<CR>', { desc = '[T]oggle [S]uperMaven' })
  end,
})
