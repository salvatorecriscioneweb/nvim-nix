return {
  {
    'slugbyte/lackluster.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      local lackluster = require 'lackluster'

      lackluster.setup {
        tweak_syntax = {
          comment = lackluster.color.gray4, -- or gray5
        },
        tweak_background = {
          normal = 'none',
          telescope = 'none',
          menu = lackluster.color.gray3,
          popup = 'default',
        },
      }
      vim.cmd.colorscheme 'lackluster'
      -- vim.cmd.colorscheme 'lackluster-hack' -- my favorite
      -- vim.cmd.colorscheme("lackluster-mint")
    end,
  },
  -- {
  --   'bluz71/vim-moonfly-colors',
  --   name = 'moonfly',
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     vim.cmd.colorscheme 'moonfly'
  --     -- Lua initialization file
  --     vim.g.moonflyTransparent = true
  --   end,
  -- },
  -- {
  --   'jaredgorski/fogbell.vim',
  --   lazy = false,
  --   config = function()
  --     vim.opt.background = 'light'
  --     vim.cmd.colorscheme 'fogbell_light'
  --     vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#d0d0d0' })
  --     vim.api.nvim_set_hl(0, 'CursorLineNr', { bg = '#262626', fg = '#d0d0d0' })
  --     vim.api.nvim_set_hl(0, 'MsgArea', { bg = '#262626', fg = '#d0d0d0' })
  --   end,
  -- },
}
