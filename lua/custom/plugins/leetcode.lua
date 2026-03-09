local plugins = {
  'https://github.com/kawre/leetcode.nvim',
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
}

vim.pack.add(plugins);

require('leetcode').setup({
  lang = 'typescript'
})

-- return {
--   'kawre/leetcode.nvim',
--   build = ':TSUpdate html', -- if you have `nvim-treesitter` installed
--   dependencies = {
--     -- include a picker of your choice, see picker section for more details
--     'nvim-lua/plenary.nvim',
--     'MunifTanjim/nui.nvim',
--   },
--   opts = {
--     lang = 'javascript',
--   },
-- }
