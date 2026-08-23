return {
  'chentoast/marks.nvim',
  event = 'VeryLazy', -- Loads it after startup to keep nvim fast
  opts = {}, -- Automatically calls require('marks').setup({})
}
