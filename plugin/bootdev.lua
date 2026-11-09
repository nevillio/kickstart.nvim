-- Push boot.dev lesson buffers to the local sync daemon on save.
--
-- The daemon (~/bin/bootdev-sync) fans the code out to the boot.dev tab over
-- SSE. Lesson files live in ~/bootdev/<lesson-uuid>/code.<ext>.

local SERVER = vim.env.BOOTDEV_SERVER or 'http://127.0.0.1:8765'

local function abs_path(path)
  return vim.fn.fnamemodify(path, ':p')
end

local function lesson_uuid(path)
  return abs_path(path):match('/bootdev/([0-9a-f%-]+)/')
end

local function push(path)
  local uuid = lesson_uuid(path)
  if not uuid then return end
  path = abs_path(path)
  vim.system({
    'curl', '-sS', '-X', 'POST',
    '--data-binary', '@' .. path,
    SERVER .. '/push?uuid=' .. uuid,
  }, { text = true }, function(res)
    if res.code ~= 0 then
      vim.notify('boot.dev push failed: ' .. (res.stderr or ''), vim.log.levels.WARN)
    end
  end)
end

local augroup = vim.api.nvim_create_augroup('BootdevSync', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  group = augroup,
  pattern = { '*/bootdev/*', 'bootdev/*' },
  callback = function(args) push(args.file) end,
  desc = 'Push boot.dev lesson to the browser',
})

vim.api.nvim_create_user_command('BootdevPull', function()
  -- Flags must come before the code argument; qutebrowser's parser glues
  -- anything after `--world main` onto the code string.
  vim.system({ 'qutebrowser', ':jseval --quiet --world main bootdevPull()' })
end, { desc = 'Pull the browser editor into nvim' })

vim.api.nvim_create_user_command('BootdevRun', function()
  local uuid = lesson_uuid(vim.api.nvim_buf_get_name(0))
  if uuid then vim.cmd('botright split | terminal bootdev run ' .. uuid) end
end, { desc = 'Run the current boot.dev lesson' })

vim.api.nvim_create_user_command('BootdevSubmit', function()
  local uuid = lesson_uuid(vim.api.nvim_buf_get_name(0))
  if uuid then vim.cmd('botright split | terminal bootdev submit ' .. uuid) end
end, { desc = 'Submit the current boot.dev lesson' })
