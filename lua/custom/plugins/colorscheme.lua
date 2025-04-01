return {
  {
    'Mofiqul/vscode.nvim',
    version = false,
    lazy = false,
    priority = 1000,
    config = function()
      local c = require('vscode.colors').get_colors()
      require('vscode').setup {
        -- Alternatively set style in setup
        -- style = 'light'

        -- Enable transparent background
        transparent = true,

        -- Enable italic comment
        italic_comments = true,

        -- Underline `@markup.link.*` variants
        underline_links = true,

        -- Disable nvim-tree background color
        disable_nvimtree_bg = true,

        -- Apply theme colors to terminal
        terminal_colors = true,
      }
      vim.opt.background = 'light' -- set this to dark or light
      vim.cmd.colorscheme 'vscode'
    end,
  },
}
