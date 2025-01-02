return {
  'supermaven-inc/supermaven-nvim',
  event = 'BufEnter',
  config = function()
    vim.keymap.set('n', '<leader>ts', '<cmd>SupermavenToggle<CR>', { desc = '[T]oggle [S]upermaven' })
    require('supermaven-nvim').setup {
      keymaps = {
        accept_suggestion = '<C-g>',
        clear_suggestion = '<C-z>',
        accept_word = '<C-k>',
      },
      ignore_filetypes = { 'TelescopePrompt', 'codecompanion' },
      color = {
        suggestion_color = '#ffffff',
        cterm = 244,
      },
      condition = function()
        local cwd = vim.fn.getcwd()
        local dirs = { '/home/nevillio/.config/nvim', '/home/nevillio/Projects/lgi/onemw-js/' }
        for _, dir in ipairs(dirs) do
          if cwd:match('^' .. dir) then
            return false
          end
          return true
        end
      end,
    }
    vim.keymap.set('n', '<leader>ts', '<cmd>SupermavenToggle<CR>', { desc = '[T]oggle [S]upermaven' })
  end,
}
