return {
  -- Projects
  {
    'ahmedkhalf/project.nvim',
    opts = {
      patterns = { 'mix.exs', '.git', '_darcs', '.hg', '.bzr', '.svn', 'Makefile', 'package.json' },
    },
    config = function()
      require('telescope').load_extension 'projects'
    end,
  },
  -- file managing , picker etc
  {
    'nvim-tree/nvim-tree.lua',
    cmd = { 'NvimTreeToggle', 'NvimTreeFocus' },
    opts = {
      filters = { dotfiles = false },
      disable_netrw = true,
      hijack_cursor = true,
      sync_root_with_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = false,
      },
      view = {
        width = 30,
        preserve_window_proportions = true,
      },
      renderer = {
        root_folder_label = false,
        highlight_git = true,
        indent_markers = { enable = true },
        icons = {
          glyphs = {
            default = '󰈚',
            folder = {
              default = '',
              empty = '',
              empty_open = '',
              open = '',
              symlink = '',
            },
            git = { unmerged = '' },
          },
        },
      },
    },
  },
  {
    'kdheepak/lazygit.nvim',
    lazy = true,
    cmd = {
      'LazyGit',
      'LazyGitConfig',
      'LazyGitCurrentFile',
      'LazyGitFilter',
      'LazyGitFilterCurrentFile',
    },
    -- optional for floating window border decoration
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    keys = {
      { '<leader>lg', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
    },
  },
}
