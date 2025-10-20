local plugins = {
  'https://github.com/kdheepak/lazygit.nvim',
  'https://github.com/nvim-lua/plenary.nvim',
}

vim.schedule(function()
  vim.pack.add(plugins)
  require('lazygit')
end)

vim.keymap.set('n', '<leader>lg', '<cmd>LazyGit<cr>', { desc = '[L]azy[G]it' })
vim.keymap.set('n', '<leader>lc', '<cmd>LazyGitCurrentFile<cr>', { desc = '[L]azygit [C]urrent file' })
vim.keymap.set('n', '<leader>lf', '<cmd>LazyGitFilterCurrentFile<cr>', { desc = '[L]azygit [F]ilter' })
vim.keymap.set('n', '<leader>ll', '<cmd>LazyGitLog<cr>', { desc = '[L]azygit [L]og' })
