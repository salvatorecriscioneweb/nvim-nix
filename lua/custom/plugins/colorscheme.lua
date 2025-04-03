return {
  -- {
  --   'slugbyte/lackluster.nvim',
  --   lazy = false,
  --   priority = 1000,
  --   init = function()
  --     vim.cmd.colorscheme 'lackluster'
  --     -- vim.cmd.colorscheme("lackluster-hack") -- my favorite
  --     -- vim.cmd.colorscheme("lackluster-mint")
  --   end,
  -- },
  {
    'jaredgorski/fogbell.vim',
    lazy = false,
    config = function()
      vim.opt.background = 'light'
      vim.cmd.colorscheme 'fogbell_light'
    end,
  },
}
