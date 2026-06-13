vim.keymap.set('n', '<leader>r', ':term node %<CR>', { desc = '[R]un code', buffer = true })
vim.keymap.set('n', '<leader>rn', function()
  vim.system({ 'node', vim.fn.expand '%' }, { text = true }, function(obj)
    vim.schedule(function()
      if obj.code ~= 0 then
        vim.notify(obj.stderr, 'error')
      else
        vim.notify(obj.stdout)
      end
    end)
  end)
end, { desc = '[R]un and [N]otify', buffer = true })
