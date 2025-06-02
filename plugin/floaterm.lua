local state = {
  floating = {
    buf = -1,
    win = -1,
  },
}

local function create_floating_window(opts)
  opts = opts or {}

  local width = vim.o.columns
  local height = vim.o.lines

  -- Get window size
  local win_width = opts.width or math.floor(0.8 * width)
  local win_height = opts.height or math.floor(0.8 * height)

  -- Calcualte starting points
  local col = math.floor((width - win_width) / 2)
  local row = math.floor((height - win_height) / 2)

  -- Create a buffer
  local buf = nil
  if opts.buf and opts.buf > 0 and vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true) -- no file, scrath buffer
  end

  -- Window configuration
  local win_config = {
    relative = 'editor',
    width = win_width,
    height = win_height,
    col = col,
    row = row,
    style = 'minimal',
    border = 'rounded',
  }
  -- Create floating window
  local win = vim.api.nvim_open_win(buf, true, win_config)

  -- Enter insert mode
  vim.cmd 'startinsert'

  return { buf = buf, win = win }
end

local function toggle_terminal()
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = create_floating_window { buf = state.floating.buf }
    if vim.bo[state.floating.buf].buftype ~= 'terminal' then
      vim.cmd.terminal()
    end
  else
    vim.api.nvim_win_hide(state.floating.win)
  end
end

vim.api.nvim_create_user_command('Floaterm', toggle_terminal, {})
vim.keymap.set({ 'n', 't' }, '<leader>tt', toggle_terminal, { desc = '[T]oggle [T]erminal' })
