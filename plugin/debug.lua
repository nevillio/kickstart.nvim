-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add {
  'https://github.com/mfussenegger/nvim-dap',
  { src = 'https://github.com/igorlfs/nvim-dap-view', version = vim.version.range '1.*' },
  gh 'LiadOz/nvim-dap-repl-highlights',
  gh 'mason-org/mason.nvim',
  gh 'jay-babu/mason-nvim-dap.nvim',
}

-- Basic debugging keymaps, feel free to change to your liking!
vim.keymap.set('n', '<leader>da', function() require('dap').continue() end, { desc = 'Debug: Start/Continue' })
vim.keymap.set('n', '<leader>di', function() require('dap').step_into() end, { desc = '[D]ebug: Step [I]nto' })
vim.keymap.set('n', '<leader>do', function() require('dap').step_over() end, { desc = '[D]ebug: Step [O]ver' })
vim.keymap.set('n', '<leader>dO', function() require('dap').step_out() end, { desc = '[D]ebug: Step [O]ut' })
vim.keymap.set('n', '<leader>b', function() require('dap').toggle_breakpoint() end, { desc = 'Debug: Toggle Breakpoint' })
vim.keymap.set('n', '<leader>B', function() require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ') end, { desc = 'Debug: Set Breakpoint' })
vim.keymap.set({ 'n', 'v' }, '<leader>K', function() require('dap-view').hover() end, { desc = 'Debug: Hover the value' })
vim.keymap.set({ 'n', 'v' }, '<leader>dw', function() require('dap-view').add_expr() end, { desc = 'Debug: Hover the value' })
-- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
vim.keymap.set('n', '<leader>du', function() require('dap-view').open() end, { desc = 'Debug: See last session result.' })

local dap = require 'dap'

require('mason-nvim-dap').setup {
  -- Makes a best effort to setup the various debuggers with
  -- reasonable debug configurations
  automatic_installation = true,

  -- You can provide additional configuration to the handlers,
  -- see mason-nvim-dap README for more information
  handlers = {},

  -- You'll need to check that you have the required things installed
  -- online, please don't ask me how to install them :)
  ensure_installed = {
    -- Update this to ensure that you have the debuggers for the langs you want
    'js-debug-adapter',
  },
}

require('dap-view').setup {
  winbar = {
    default_section = 'repl',
  },
  virtual_text = {
    enabled = true,
  },
  auto_toggle = true,
}

require('nvim-dap-repl-highlights').setup()
require('nvim-treesitter').install { 'dap_repl' }

local exts = {
  'javascript',
  'typescript',
  'javascriptreact',
  'typescriptreact',
  'vue',
  'svelte',
}

dap.adapters['pwa-node'] = {
  type = 'server',
  host = 'localhost',
  port = '${port}',
  executable = {
    command = 'js-debug-adapter',
    args = { '${port}' },
  },
}

dap.adapters['pwa-chrome'] = {
  type = 'server',
  host = 'localhost',
  port = '${port}',
  executable = {
    command = 'js-debug-adapter',
    args = { '${port}' },
  },
}

dap.adapters.nlua = function(callback, config) callback { type = 'server', host = config.host or '127.0.0.1', port = config.port or 8086 } end

dap.configurations.lua = {
  {
    type = 'nlua',
    request = 'attach',
    name = 'Attach to running neovim instance',
  },
}

for _, ext in ipairs(exts) do
  dap.configurations[ext] = {
    {
      type = 'pwa-node',
      request = 'launch',
      name = 'Launch Current File (pwa-node)',
      program = '${file}',
      cwd = vim.fn.getcwd(),
      sourceMaps = true,
      protocol = 'inspector',
      repl_lang = 'javascript',
      console = 'integratedTerminal',
      resolveSourceMapLocations = {
        '${workspaceFolder}/**',
        '!**/node_modules/**',
      },
    },
  }
end

-- Change breakpoint icons
vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
local breakpoint_icons = vim.g.have_nerd_font
    and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
  or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
for type, icon in pairs(breakpoint_icons) do
  local tp = 'Dap' .. type
  local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
  vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
end

-- -- Map K to hover during debugging
-- local api = vim.api
-- local keymap_restore = {}
--
-- local function save_and_replace_keymaps()
--   for _, buf in pairs(api.nvim_list_bufs()) do
--     -- Only process valid, loaded buffers
--     if not api.nvim_buf_is_valid(buf) or not api.nvim_buf_is_loaded(buf) then goto continue end
--
--     -- Check if buffer's filetype matches our extensions
--     local ft = api.nvim_buf_get_option(buf, 'filetype')
--     local is_target_ft = false
--     for _, ext in ipairs(exts) do
--       if ft == ext then
--         is_target_ft = true
--         break
--       end
--     end
--
--     if not is_target_ft then goto continue end
--
--     -- Save existing K mapping for this buffer
--     local keymaps = api.nvim_buf_get_keymap(buf, 'n')
--     for _, keymap in pairs(keymaps) do
--       if keymap.lhs == 'K' then
--         keymap_restore[buf] = keymap
--         api.nvim_buf_del_keymap(buf, 'n', 'K')
--         break
--       end
--     end
--
--     ::continue::
--   end
--
--   -- Set debug mapping globally
--   api.nvim_set_keymap('n', 'K', '<Cmd>lua require("dap.ui.widgets").hover()<CR>', { silent = true })
-- end
--
-- local function restore_keymaps()
--   for buf, keymap in pairs(keymap_restore) do
--     if api.nvim_buf_is_valid(buf) and api.nvim_buf_is_loaded(buf) then
--       if keymap.rhs then
--         api.nvim_buf_set_keymap(buf, keymap.mode, keymap.lhs, keymap.rhs, { silent = true })
--       elseif keymap.callback then
--         vim.keymap.set(keymap.mode, keymap.lhs, keymap.callback, { buffer = buf, silent = true })
--       end
--     end
--   end
--   keymap_restore = {}
-- end
--
-- dap.listeners.after['event_stopped']['hover_keymap'] = save_and_replace_keymaps
--
-- dap.listeners.before.event_continued['hover_keymap'] = restore_keymaps
--
-- dap.listeners.before.event_terminated['hover_keymap'] = restore_keymaps
--
