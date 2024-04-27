-- https://github.com/Exafunction/codeium.nvim
return {
  'Exafunction/codeium.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'hrsh7th/nvim-cmp',
  },
  event = 'BufEnter',
  config = function()
    require('codeium').setup {
      enable_cmp_source = false,
      filetypes = { TelescopePrompt = false },
      virtual_text = {
        enabled = false,
        idle_delay = 75,
        key_bindings = {
          accept = '<C-g>',
          accept_word = '<C-k>',
          accept_line = false,
          next = '<C-;>',
          prev = '<C-,>',
        },
      },
    }
  end,
}
