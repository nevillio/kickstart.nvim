local leetcode_solutions_dir = vim.fn.expand '~/personal/leetcode/solutions/'
vim.keymap.set('n', '<leader>wl', function()
  local name = vim.fn.expand '%:t'
  local extension = vim.fn.expand '%:e'
  local dirnames = vim.fn.readdir(leetcode_solutions_dir .. '/python', function(d) return vim.fn.isdirectory(leetcode_solutions_dir .. '/python/' .. d) end)
  vim.ui.select(dirnames, { prompt = 'Select directory to write to: ' }, function(dir)
    if dir == nil then return end
    local lang = extension == 'ts' and 'typescript' or 'python'
    local final_destination = leetcode_solutions_dir .. lang .. '/' .. dir .. '/' .. name
    vim.cmd('write ' .. final_destination)
    vim.notify('Saved as ' .. final_destination)
  end)
end, { desc = '[W]rite to [L]eetcode directory' })
