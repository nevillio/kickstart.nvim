-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

---@module 'lazy'
---@type LazySpec
return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    {
      'igorlfs/nvim-dap-view',
      ---@module 'dapview'
      ---@type dapview.Config
      opts = {
        winbar = {
          default_section = 'repl',
        },
        auto_toggle = true,
      },
    },
    'theHamsta/nvim-dap-virtual-text',

    {
      'LiadOz/nvim-dap-repl-highlights',
      config = true,
      dependencies = {
        'mfussenegger/nvim-dap',
        'nvim-treesitter/nvim-treesitter',
      },
      build = function()
        if not require('nvim-treesitter.parsers').has_parser 'dap_repl' then
          vim.cmd ':TSInstall dap_repl'
        end
      end,
    },

    -- Installs the debug adapters for you
    'mason-org/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
    'jbyuki/one-small-step-for-vimkind',
  },
  keys = {
    -- Basic debugging keymaps, feel free to change to your liking!
    { '<Leader>da', "<CMD>lua require('dap').continue()<CR>", desc = 'Continue' },
    { '<Leader>di', "<CMD>lua require('dap').step_into()<CR>", desc = 'Step Into' },
    { '<Leader>dO', "<CMD>lua require('dap').step_out()<CR>", desc = 'Step Out' },
    { '<Leader>do', "<CMD>lua require('dap').step_over()<CR>", desc = 'Step Over' },
    { '<Leader>db', "<CMD>lua require('dap').toggle_breakpoint()<CR>", desc = 'Toggle Breakpoint' },
    { '<Leader>dt', "<CMD>lua require('dap').terminate()<CR>", desc = 'Terminate' },
    { '<Leader>dl', "<CMD>lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>", desc = 'Add log point' },
    { '<Leader>du', "<CMD>lua require('dap-view').open()<CR>", desc = 'Open UI' },
    { '<Leader>dc', "<CMD>lua require('dap-view').close()<CR>", desc = 'Close UI' },
    { '<Leader>dw', "<CMD>lua require('dap-view').add_expr(expr)", desc = 'Add Watch Expression' },

    {
      '<leader>dB',
      function()
        local dap = require 'dap'

        -- Search for an existing breakpoint on this line in this buffer
        ---@return dap.SourceBreakpoint bp that was either found, or an empty placeholder
        local function find_bp()
          local buf_bps = require('dap.breakpoints').get(vim.fn.bufnr())[vim.fn.bufnr()]
          ---@type dap.SourceBreakpoint
          for _, candidate in ipairs(buf_bps) do
            if candidate.line and candidate.line == vim.fn.line '.' then
              return candidate
            end
          end

          return { condition = '', logMessage = '', hitCondition = '', line = vim.fn.line '.' }
        end

        -- Elicit customization via a UI prompt
        ---@param bp dap.SourceBreakpoint a breakpoint
        local function customize_bp(bp)
          local props = {
            ['Condition'] = {
              value = bp.condition,
              setter = function(v) bp.condition = v end,
            },
            ['Hit Condition'] = {
              value = bp.hitCondition,
              setter = function(v) bp.hitCondition = v end,
            },
            ['Log Message'] = {
              value = bp.logMessage,
              setter = function(v) bp.logMessage = v end,
            },
          }
          local menu_options = {}
          for k, _ in pairs(props) do
            table.insert(menu_options, k)
          end
          vim.ui.select(menu_options, {
            prompt = 'Edit Breakpoint',
            format_item = function(item) return ('%s: %s'):format(item, props[item].value) end,
          }, function(choice)
            if choice == nil then
              -- User cancelled the selection
              return
            end
            props[choice].setter(vim.fn.input {
              prompt = ('[%s] '):format(choice),
              default = props[choice].value,
            })

            -- Set breakpoint for current line, with customizations (see h:dap.set_breakpoint())
            dap.set_breakpoint(bp.condition, bp.hitCondition, bp.logMessage)
          end)
        end

        customize_bp(find_bp())
      end,
      desc = 'Debug: Edit Breakpoint',
    },
  },
  config = function()
    local dap = require 'dap'
    local present_virtual_text, dap_vt = pcall(require, 'nvim-dap-virtual-text')

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
        'delve',
        'js-debug-adapter',
      },
    }

    -- ╭──────────────────────────────────────────────────────────╮
    -- │ DAP Virtual Text Setup                                   │
    -- ╰──────────────────────────────────────────────────────────╯
    dap_vt.setup {
      enabled = true, -- enable this plugin (the default)
      enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
      highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
      highlight_new_as_changed = false, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
      show_stop_reason = true, -- show stop reason when stopped for exceptions
      commented = false, -- prefix virtual text with comment string
      only_first_definition = true, -- only show virtual text at first definition (if there are multiple)
      all_references = false, -- show virtual text on all all references of the variable (not only definitions)
      filter_references_pattern = '<module', -- filter references (not definitions) pattern when all_references is activated (Lua gmatch pattern, default filters out Python modules)
      -- Experimental Features:
      virt_text_pos = 'eol', -- position of virtual text, see `:h nvim_buf_set_extmark()`
      all_frames = true, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
      virt_lines = false, -- show virtual lines instead of virtual text (will flicker!)
      virt_text_win_col = nil, -- position the virtual text at a fixed window column (starting from the first text column) ,
    }

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

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    --Enable virtual text
    vim.g.dap_virtual_text = true

    -- Install golang specific config
    require('dap-go').setup {
      delve = {
        -- On Windows delve must be run attached or it crashes.
        -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
        detached = vim.fn.has 'win32' == 0,
      },
    }

    local exts = {
      'javascript',
      'typescript',
      'javascriptreact',
      'typescriptreact',
      'vue',
      'svelte',
    }
    -- ╭──────────────────────────────────────────────────────────╮
    -- │ Adapters                                                 │
    -- ╰──────────────────────────────────────────────────────────╯
    require('dap').adapters['pwa-node'] = {
      type = 'server',
      host = 'localhost',
      port = '${port}',
      executable = {
        command = 'js-debug-adapter',
        args = { '${port}' },
      },
    }

    require('dap').adapters['pwa-chrome'] = {
      type = 'server',
      host = 'localhost',
      port = '${port}',
      executable = {
        command = 'js-debug-adapter',
        args = { '${port}' },
      },
    }

    -- ╭──────────────────────────────────────────────────────────╮
    -- │ Configurations                                           │
    -- ╰──────────────────────────────────────────────────────────╯
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
        {
          type = 'pwa-node',
          request = 'attach',
          name = 'Attach to STB Node js',
          address = function()
            local stb_ip = ''
            local filepath = vim.fn.expand '~/.config/onemw/config'
            local file = io.open(filepath, 'r')

            if not file then
              error('Could not open file' .. filepath)
            end

            for line in file:lines() do
              if line:match '^%s*$' or line:match '^%s*#' then
                goto continue
              end
              local value = line:match '^%s*STB_IP=(.+)%s*$'
              if value then
                stb_ip = value
                break
              end
              -- Remove quotes with value = value:match('^"(.*)"$') or value
              ::continue::
            end

            file:close()
            return stb_ip
          end,
          port = 9229,
          localRoot = vim.fn.getcwd() .. '/src',
          remoteRoot = '/usr/share/lgioui/app',
          sourceMaps = true,
          restart = true,
          repl_lang = 'javascript',
          skipFiles = {
            'module.js',
            'fs.js',
            'next_tick.js',
            'node_modules/**/*',
            'Request.js',
            'Cache.js',
          },
          timeout = 5000,
        },
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Run mocha',
          program = vim.fn.getcwd() .. '/node_modules/mocha/bin/_mocha',
          stopOnEntry = false,
          args = { '-r', './test/setup.js', '--no-timeouts', '--', '${file}' },
          cwd = vim.fn.getcwd(),
          repl_lang = 'javascript',
          console = 'integratedTerminal',
          internalConsoleOptions = 'neverOpen',
          runtimeExecutable = nil,
        },
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Launch Test Current File (pwa-node with jest)',
          cwd = vim.fn.getcwd(),
          runtimeArgs = { '--experimental-vm-modules', '${workspaceFolder}/node_modules/jest/bin/jest.js', '--runInBand', '--no-coverage', '--no-cache' },
          runtimeExecutable = 'node',
          args = { '${file}' },
          rootPath = '${workspaceFolder}',
          sourceMaps = true,
          console = 'integratedTerminal',
          internalConsoleOptions = 'neverOpen',
          skipFiles = { '<node_internals>/**', 'node_modules/**' },
        },
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Launch Current File (pwa-node) with package manager',
          cwd = vim.fn.getcwd(),
          sourceMaps = true,
          trace = true,
          protocol = 'inspector',
          runtimeExecutable = vim.fn.executable 'pnpm' == 1 and 'pnpm' or 'npm',
          runtimeArgs = {
            'run',
            'test:unit:file',
            '${file}',
          },
          resolveSourceMapLocations = {
            '${workspaceFolder}/**',
            '!**/node_modules/**',
          },
        },
        {
          type = 'pwa-node',
          request = 'attach',
          name = 'Attach Program (pwa-node, select pid)',
          cwd = vim.fn.getcwd(),
          processId = require('dap.utils').pick_process,
          skipFiles = { '<node_internals>/**' },
        },
        {
          type = 'pwa-chrome',
          request = 'launch',
          name = 'Launch Chrome with "localhost"',
          url = function()
            local co = coroutine.running()
            return coroutine.create(function()
              vim.ui.input({ prompt = 'Enter URL: ', default = 'http://localhost:3000' }, function(url)
                if url == nil or url == '' then
                  return
                else
                  coroutine.resume(co, url)
                end
              end)
            end)
          end,
          webRoot = '${workspaceFolder}',
          protocol = 'inspector',
          sourceMaps = true,
          userDataDir = false,
          skipFiles = { '<node_internals>/**', 'node_modules/**', '${workspaceFolder}/node_modules/**' },
          resolveSourceMapLocations = {
            '${webRoot}/*',
            '${webRoot}/apps/**/**',
            '${workspaceFolder}/apps/**/**',
            '${webRoot}/packages/**/**',
            '${workspaceFolder}/packages/**/**',
            '${workspaceFolder}/*',
            '!**/node_modules/**',
          },
        },
        {
          type = 'pwa-chrome',
          request = 'attach',
          name = 'Attach Program (pwa-chrome, select port)',
          program = '${file}',
          cwd = vim.fn.getcwd(),
          sourceMaps = true,
          protocol = 'inspector',
          port = function() return vim.fn.input('Select port: ', '9229') end,
          trace = true,
          webRoot = '${workspaceFolder}',
          skipFiles = { '<node_internals>/**', 'node_modules/**', '${workspaceFolder}/node_modules/**' },
          resolveSourceMapLocations = {
            '${webRoot}/*',
            '${webRoot}/apps/**/**',
            '${workspaceFolder}/apps/**/**',
            '${webRoot}/packages/**/**',
            '${workspaceFolder}/packages/**/**',
            '${workspaceFolder}/*',
            '!**/node_modules/**',
          },
        },
      }
    end
  end,
}
