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
  -- Lazygit
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
