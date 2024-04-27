-- Unless you are still migrating, remove the deprecated commands from v1.x
vim.cmd [[ let g:neo_tree_remove_legacy_commands = 1 ]]
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<leader>n', ':Neotree reveal<CR>', opts)

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
    '3rd/image.nvim',
  },
  config = function()
    require('neo-tree').setup {
      window = {
        width = 40,
      },
      icon = {
        -- folder_closed = '',
        -- folder_open = '',
        -- folder_empty = '󰜌',
      },
    }
  end,
}
