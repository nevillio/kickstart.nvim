return {
  'nvim-treesitter/nvim-treesitter-textobjects',
  branch = 'main',
  event = { 'BufReadPre', 'BufNewFile' },
  init = function()
    -- Disable entire built-in ftplugin mappings to avoid conflicts.
    -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
    vim.g.no_plugin_maps = true

    -- Or, disable per filetype (add as you like)
    -- vim.g.no_python_maps = true
    -- vim.g.no_ruby_maps = true
    -- vim.g.no_rust_maps = true
    -- vim.g.no_go_maps = true
  end,
  config = function()
    require('nvim-treesitter-textobjects').setup {
      select = {
        enable = true,

        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        include_surrounding_whitespace = function(args)
          local exclude = {
            ['@function.outer'] = true,
            ['@conditional.outer'] = true,
            ['@loop.outer'] = true,
            ['@class.outer'] = true,
          }
          return not exclude[args.query_string]
        end,
        selection_modes = {
          ['@parameter.outer'] = 'v', -- charwise
          ['@function.outer'] = 'V', -- linewise
          ['@conditional.outer'] = 'V', -- linewise
          ['@loop.outer'] = 'V', -- linewise
          ['@class.outer'] = '<c-v>', -- blockwise
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
      },
    }

    -- keymaps = {
    -- You can use the capture groups defined in textobjects.scm
    vim.keymap.set(
      { 'x', 'o' },
      'a=',
      function() require('nvim-treesitter-textobjects.select').select_textobject('@assignment.outer', 'textobjects') end,
      { desc = 'Select outer part of an assignment' }
    )
    vim.keymap.set(
      { 'x', 'o' },
      'i=',
      function() require('nvim-treesitter-textobjects.select').select_textobject('@assignment.inner', 'textobjects') end,
      { desc = 'Select inner part of an assignment' }
    )
    vim.keymap.set(
      { 'x', 'o' },
      'l=',
      function() require('nvim-treesitter-textobjects.select').select_textobject('@assignment.lhs', 'textobjects') end,
      { desc = 'Select left hand side of an assignment' }
    )
    vim.keymap.set(
      { 'x', 'o' },
      'r=',
      function() require('nvim-treesitter-textobjects.select').select_textobject('@assignment.rhs', 'textobjects') end,
      { desc = 'Select right hand side of an assignment' }
    )

    vim.keymap.set(
      { 'x', 'o' },
      'aa',
      function() require('nvim-treesitter-textobjects.select').select_textobject('@parameter.outer', 'textobjects') end,
      { desc = 'Select outer part of a parameter/argument' }
    )
    vim.keymap.set(
      { 'x', 'o' },
      'ia',
      function() require('nvim-treesitter-textobjects.select').select_textobject('@parameter.inner', 'textobjects') end,
      { desc = 'Select inner part of a parameter/argument' }
    )

    vim.keymap.set(
      { 'x', 'o' },
      'ai',
      function() require('nvim-treesitter-textobjects.select').select_textobject('@conditional.outer', 'textobjects') end,
      { desc = 'Select outer part of a conditional' }
    )
    vim.keymap.set(
      { 'x', 'o' },
      'ii',
      function() require('nvim-treesitter-textobjects.select').select_textobject('@conditional.inner', 'textobjects') end,
      { desc = 'Select inner part of a conditional' }
    )

    vim.keymap.set(
      { 'x', 'o' },
      'al',
      function() require('nvim-treesitter-textobjects.select').select_textobject('@loop.outer', 'textobjects') end,
      { desc = 'Select outer part of a loop' }
    )
    vim.keymap.set(
      { 'x', 'o' },
      'il',
      function() require('nvim-treesitter-textobjects.select').select_textobject('@loop.inner', 'textobjects') end,
      { desc = 'Select inner part of a loop' }
    )

    vim.keymap.set(
      { 'x', 'o' },
      'af',
      function() require('nvim-treesitter-textobjects.select').select_textobject('@call.outer', 'textobjects') end,
      { desc = 'Select outer part of a function call' }
    )
    vim.keymap.set(
      { 'x', 'o' },
      'if',
      function() require('nvim-treesitter-textobjects.select').select_textobject('@call.inner', 'textobjects') end,
      { desc = 'Select inner part of a function call' }
    )

    vim.keymap.set(
      { 'x', 'o' },
      'am',
      function() require('nvim-treesitter-textobjects.select').select_textobject('@function.outer', 'textobjects') end,
      { desc = 'Select outer part of a method/function definition' }
    )
    vim.keymap.set(
      { 'x', 'o' },
      'im',
      function() require('nvim-treesitter-textobjects.select').select_textobject('@function.inner', 'textobjects') end,
      { desc = 'Select inner part of a method/function definition' }
    )

    vim.keymap.set(
      { 'x', 'o' },
      'ac',
      function() require('nvim-treesitter-textobjects.select').select_textobject('@class.outer', 'textobjects') end,
      { desc = 'Select outer part of a class' }
    )
    vim.keymap.set(
      { 'x', 'o' },
      'ic',
      function() require('nvim-treesitter-textobjects.select').select_textobject('@class.inner', 'textobjects') end,
      { desc = 'Select inner part of a class' }
    )
    -- goto_next_start = {
    vim.keymap.set(
      { 'n', 'x', 'o' },
      ']f',
      function() require('nvim-treesitter-textobjects.move').goto_next_start('@call.outer', 'textobjects') end,
      { desc = 'Next function call start' }
    )
    vim.keymap.set(
      { 'n', 'x', 'o' },
      ']m',
      function() require('nvim-treesitter-textobjects.move').goto_next_start('@function.outer', 'textobjects') end,
      { desc = 'Next method/function def start' }
    )
    vim.keymap.set(
      { 'n', 'x', 'o' },
      ']c',
      function() require('nvim-treesitter-textobjects.move').goto_next_start('@class.outer', 'textobjects') end,
      { desc = 'Next class start' }
    )
    vim.keymap.set(
      { 'n', 'x', 'o' },
      ']i',
      function() require('nvim-treesitter-textobjects.move').goto_next_start('@conditional.outer', 'textobjects') end,
      { desc = 'Next conditional start' }
    )
    vim.keymap.set(
      { 'n', 'x', 'o' },
      ']l',
      function() require('nvim-treesitter-textobjects.move').goto_next_start('@loop.outer', 'textobjects') end,
      { desc = 'Next loop start' }
    )
    vim.keymap.set(
      { 'n', 'x', 'o' },
      ']a',
      function() require('nvim-treesitter-textobjects.move').goto_next_start('@parameter.outer', 'textobjects') end,
      { desc = 'Next parameter start' }
    )

    -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
    -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
    vim.keymap.set(
      { 'n', 'x', 'o' },
      ']s',
      function() require('nvim-treesitter-textobjects.move').goto_next_start('@local.scopes', 'textobjects') end,
      { desc = 'Next scope' }
    )
    vim.keymap.set(
      { 'n', 'x', 'o' },
      ']z',
      function() require('nvim-treesitter-textobjects.move').goto_next_start('@fold', 'textobjects') end,
      { desc = 'Next fold' }
    )

    -- goto_next_end = {
    vim.keymap.set(
      { 'n', 'x', 'o' },
      ']F',
      function() require('nvim-treesitter-textobjects.move').goto_next_end('@call.outer', 'textobjects') end,
      { desc = 'Next function call end' }
    )
    vim.keymap.set(
      { 'n', 'x', 'o' },
      ']M',
      function() require('nvim-treesitter-textobjects.move').goto_next_end('@function.outer', 'textobjects') end,
      { desc = 'Next method/function def end' }
    )
    vim.keymap.set(
      { 'n', 'x', 'o' },
      ']C',
      function() require('nvim-treesitter-textobjects.move').goto_next_end('@class.outer', 'textobjects') end,
      { desc = 'Next class end' }
    )
    vim.keymap.set(
      { 'n', 'x', 'o' },
      ']I',
      function() require('nvim-treesitter-textobjects.move').goto_next_end('@conditional.outer', 'textobjects') end,
      { desc = 'Next conditional end' }
    )
    vim.keymap.set(
      { 'n', 'x', 'o' },
      ']L',
      function() require('nvim-treesitter-textobjects.move').goto_next_end('@loop.outer', 'textobjects') end,
      { desc = 'Next loop end' }
    )
    vim.keymap.set(
      { 'n', 'x', 'o' },
      ']A',
      function() require('nvim-treesitter-textobjects.move').goto_next_end('@parameter.outer', 'textobjects') end,
      { desc = 'Next parameter end' }
    )

    -- goto_previous_start = {
    vim.keymap.set(
      { 'n', 'x', 'o' },
      '[f',
      function() require('nvim-treesitter-textobjects.move').goto_previous_start('@call.outer', 'textobjects') end,
      { desc = 'Prev function call start' }
    )
    vim.keymap.set(
      { 'n', 'x', 'o' },
      '[m',
      function() require('nvim-treesitter-textobjects.move').goto_previous_start('@function.outer', 'textobjects') end,
      { desc = 'Prev method/function def start' }
    )
    vim.keymap.set(
      { 'n', 'x', 'o' },
      '[c',
      function() require('nvim-treesitter-textobjects.move').goto_previous_start('@class.outer', 'textobjects') end,
      { desc = 'Prev class start' }
    )
    vim.keymap.set(
      { 'n', 'x', 'o' },
      '[i',
      function() require('nvim-treesitter-textobjects.move').goto_previous_start('@conditional.outer', 'textobjects') end,
      { desc = 'Prev conditional start' }
    )
    vim.keymap.set(
      { 'n', 'x', 'o' },
      '[l',
      function() require('nvim-treesitter-textobjects.move').goto_previous_start('@loop.outer', 'textobjects') end,
      { desc = 'Prev loop start' }
    )
    vim.keymap.set(
      { 'n', 'x', 'o' },
      '[a',
      function() require('nvim-treesitter-textobjects.move').goto_previous_start('@parameter.outer', 'textobjects') end,
      { desc = 'Prev parameter start' }
    )

    -- goto_previous_end = {
    vim.keymap.set(
      { 'n', 'x', 'o' },
      '[F',
      function() require('nvim-treesitter-textobjects.move').goto_previous_end('@call.outer', 'textobjects') end,
      { desc = 'Prev function call end' }
    )
    vim.keymap.set(
      { 'n', 'x', 'o' },
      '[M',
      function() require('nvim-treesitter-textobjects.move').goto_previous_end('@function.outer', 'textobjects') end,
      { desc = 'Prev method/function def end' }
    )
    vim.keymap.set(
      { 'n', 'x', 'o' },
      '[C',
      function() require('nvim-treesitter-textobjects.move').goto_previous_end('@class.outer', 'textobjects') end,
      { desc = 'Prev class end' }
    )
    vim.keymap.set(
      { 'n', 'x', 'o' },
      '[I',
      function() require('nvim-treesitter-textobjects.move').goto_previous_end('@conditional.outer', 'textobjects') end,
      { desc = 'Prev conditional end' }
    )
    vim.keymap.set(
      { 'n', 'x', 'o' },
      '[L',
      function() require('nvim-treesitter-textobjects.move').goto_previous_end('@loop.outer', 'textobjects') end,
      { desc = 'Prev loop end' }
    )
    vim.keymap.set(
      { 'n', 'x', 'o' },
      '[A',
      function() require('nvim-treesitter-textobjects.move').goto_previous_end('@parameter.outer', 'textobjects') end,
      { desc = 'Prev parameter end' }
    )

    -- Go to either the start or the end, whichever is closer.
    -- Use if you want more granular movements
    vim.keymap.set({ 'n', 'x', 'o' }, ']d', function() require('nvim-treesitter-textobjects.move').goto_next('@conditional.outer', 'textobjects') end)
    vim.keymap.set({ 'n', 'x', 'o' }, '[d', function() require('nvim-treesitter-textobjects.move').goto_previous('@conditional.outer', 'textobjects') end)

    -- keymaps
    vim.keymap.set('n', '<leader>a', function() require('nvim-treesitter-textobjects.swap').swap_next '@parameter.inner' end)
    vim.keymap.set('n', '<leader>A', function() require('nvim-treesitter-textobjects.swap').swap_previous '@parameter.outer' end)

    local ts_repeat_move = require 'nvim-treesitter-textobjects.repeatable_move'
    -- ensure ; goes forward and , goes backward regardless of the last direction
    vim.keymap.set({ 'n', 'x', 'o' }, ';', ts_repeat_move.repeat_last_move_next)
    vim.keymap.set({ 'n', 'x', 'o' }, ',', ts_repeat_move.repeat_last_move_previous)

    -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
    vim.keymap.set({ 'n', 'x', 'o' }, 'f', ts_repeat_move.builtin_f_expr, { expr = true })
    vim.keymap.set({ 'n', 'x', 'o' }, 'F', ts_repeat_move.builtin_F_expr, { expr = true })
    vim.keymap.set({ 'n', 'x', 'o' }, 't', ts_repeat_move.builtin_t_expr, { expr = true })
    vim.keymap.set({ 'n', 'x', 'o' }, 'T', ts_repeat_move.builtin_T_expr, { expr = true })

    -- This repeats the last query with always previous direction and to the start of the range.
    vim.keymap.set({ 'n', 'x', 'o' }, '<home>', function() ts_repeat_move.repeat_last_move { forward = false, start = true } end)

    -- This repeats the last query with always next direction and to the end of the range.
    vim.keymap.set({ 'n', 'x', 'o' }, '<end>', function() ts_repeat_move.repeat_last_move { forward = true, start = false } end)
  end,
}
