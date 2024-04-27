-- https://github.com/Exafunction/codeium.vim
return {
  'Exafunction/codeium.vim',
  event = 'BufEnter',
  config = function()
    vim.g.codeium_no_map_tab = true
    vim.api.nvim_call_function('codeium#GetStatusString', {})
    vim.keymap.set('i', '<C-g>', function()
      return vim.fn['codeium#Accept']()
    end, { expr = true, silent = true })
  end,
}
