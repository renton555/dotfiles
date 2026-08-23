return {
  'folke/flash.nvim',
  event = 'VeryLazy',
  ---@type Flash.Config
  opts = {
    modes = {
      char = {
        jump_labels = true, -- Enables labels for f, t, F, T
      },
    },
  },
  keys = {
    { 's', mode = { 'n', 'x', 'o' }, function() require('flash').jump() end, desc = 'Flash' },
    { 'S', mode = { 'n', 'x', 'o' }, function() require('flash').treesitter() end, desc = 'Flash Treesitter' },
    { 'r', mode = 'o', function() require('flash').remote() end, desc = 'Remote Flash' },
    { 'R', mode = { 'o', 'x' }, function() require('flash').treesitter_search() end, desc = 'Treesitter Search' },
    { '<c-s>', mode = { 'c' }, function() require('flash').toggle() end, desc = 'Toggle Flash Search' },

    -- Recommended additions:
    { '*', mode = { 'n', 'x', 'o' }, function() require('flash').jump { pattern = vim.fn.expand '<cword>' } end, desc = 'Flash Word Under Cursor' },
    { '<c-f>', mode = { 'n', 'x', 'o' }, function() require('flash').jump { continue = true } end, desc = 'Continue Last Flash Search' },
  },
}
