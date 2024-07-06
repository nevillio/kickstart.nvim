vim.keymap.set('n', '<C-p>', ':MarkdownPreviewToggle<CR>')
return {
  'iamcco/markdown-preview.nvim',
  config = function()
    vim.g.mkdp_open_to_the_world = 0
    vim.g.mkdp_open_ip = '127.0.0.1'
    vim.g.mkdp_port = 8080
  end,
  cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
  ft = { 'markdown' },
  build = function()
    vim.fn['mkdp#util#install']()
  end,
}
