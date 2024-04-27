-- lazy.nvim
return {
  'GustavEikaas/code-playground.nvim',
  config = function()
    require('code-playground').setup()
  end,
  keys = {
    { '<leader>cp', ':Code<space>', desc = 'Run code playground with any language' },
  },
}
