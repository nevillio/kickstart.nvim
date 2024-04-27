return {
  {
    'catppuccin/nvim',
    lazy = false,
    enabled = false,
    name = 'catppuccin',
    priority = 1000,

    config = function()
      require('catppuccin').setup {
        transparent_background = true,
      }
      -- vim.cmd.colorscheme 'catppuccin-mocha'
    end,
  },
}
