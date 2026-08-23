-- ============================================================================
-- 1.  CORE CONFIGURATION
-- ============================================================================

require 'custom.core.options'
require 'custom.core.keymaps'
require 'custom.core.autocmds'

-- ============================================================================
-- 2.  BOOTSTRAP LAZY.NVIM
-- ============================================================================

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- ============================================================================
-- 3. LOAD PLUGINS
-- ============================================================================

require('lazy').setup {
  {
    'rebelot/kanagawa.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('kanagawa').setup {
        compile = false,
        undercurl = true,
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = true },
        statementStyle = { bold = true },
        typeStyle = {},
        transparent = false,
        dimInactive = false,
        terminalColors = true,

        -- 1. MOVED OUT OF OVERRIDES: Core settings belong in the main table
        theme = 'dragon',
        background = {
          dark = 'dragon',
          light = 'lotus',
        },

        -- 2. MERGED: Combined your two colors tables into one
        colors = {
          palette = {},
          theme = {
            wave = {},
            lotus = {},
            dragon = {},
            all = {
              ui = {
                bg_gutter = 'none',
              },
            },
          },
        },

        overrides = function(colors)
          local theme = colors.theme
          return {
            NormalFloat = { bg = 'none' },
            FloatBorder = { bg = 'none' },
            FloatTitle = { bg = 'none' },

            -- Save an hlgroup with dark background and dimmed foreground
            NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

            -- Popular plugins that open floats will link to NormalFloat by default
            LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
            MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
          }
        end,
      }

      -- 3. MOVED OUT OF SETUP TABLE: This executes after setup is complete
      vim.cmd 'colorscheme kanagawa'
    end,
  },
  require 'kickstart.plugins.debug',
  require 'kickstart.plugins.lint',
  require 'kickstart.plugins.autopairs',
  require 'kickstart.plugins.neo-tree',
  require 'kickstart.plugins.gitsigns',
  { import = 'custom.plugins' },

  ui = {
    icons = vim.g.have_nerd_font and {} or {
      -- cmd = '⌘',
      -- config = '🛠',
      -- event = '📅',
      -- ft = '📂',
      -- init = '⚙',
      -- keys = '🗝',
      -- plugin = '🔌',
      -- runtime = '💻',
      -- require = '🌙',
      -- source = '📄',
      -- start = '🚀',
      -- task = '📌',
      -- lazy = '💤 ',
    },
  },
}

-- vim: ts=2 sts=2 sw=2 et
