vim.keymap.set('n', '<leader>r', ':term python %<CR>', { desc = '[R]un code', buffer = true })

vim.keymap.set('n', '<leader>rn', function()
  vim.system({ 'python', vim.fn.expand '%' }, { text = true }, function(obj)
    vim.schedule(function()
      if obj.code ~= 0 then
        vim.notify(obj.stderr, 'error')
      else
        vim.notify(obj.stdout)
      end
    end)
  end)
end, { desc = '[R]un and [N]otify', buffer = true })

local boot_dev_dir = vim.fn.expand '~/personal/python/boot-dev'
vim.keymap.set('n', '<leader>pb', function()
  local default = vim.fn.expand '%:t:r'
  local name = vim.fn.input('Save as: ', default .. '.py')
  if name ~= '' then
    vim.cmd('write ' .. boot_dev_dir .. '/' .. name)
    vim.notify('Saved to boot-dev/' .. name)
  end
end, { desc = 'Save to [P]ython [B]oot-dev directory', buffer = true })
