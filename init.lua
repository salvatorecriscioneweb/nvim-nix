-- [[ NixCats ]]
require('nixCatsUtils').setup {
  non_nix_value = true,
}

-- [[ Options ]]
require 'custom.options'

-- Left out to don't import nixCats under options
vim.g.have_nerd_font = nixCats 'have_nerd_font'

-- [[ Basic Keymaps ]]
require 'custom.keymaps'
require 'custom.autocmds'

-- [[ Basic Autocommands ]]
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- NOTE: nixCats: You might want to move the lazy-lock.json file
local function getlockfilepath()
  if require('nixCatsUtils').isNixCats and type(nixCats.settings.unwrappedCfgPath) == 'string' then
    return nixCats.settings.unwrappedCfgPath .. '/lazy-lock.json'
  else
    return vim.fn.stdpath 'config' .. '/lazy-lock.json'
  end
end

local lazyOptions = {
  lockfile = getlockfilepath(),
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
}

--
-- NOTE: Here is where you install your plugins.
-- NOTE: nixCats: this the lazy wrapper. Use it like require('lazy').setup() but with an extra
-- argument, the path to lazy.nvim as downloaded by nix, or nil, before the normal arguments.
require('nixCatsUtils.lazyCat').setup(nixCats.pawsible { 'allPlugins', 'start', 'lazy.nvim' }, {
  {
    'williamboman/mason.nvim',
    enabled = require('nixCatsUtils').lazyAdd(true, false),
    config = true,
    lazy = false,
  }, -- NOTE: Must be loaded before dependants

  {
    'williamboman/mason-lspconfig.nvim',
    -- NOTE: nixCats: use lazyAdd to only enable mason if nix wasnt involved.
    -- because we will be using nix to download things instead.
    lazy = false,
    enabled = require('nixCatsUtils').lazyAdd(true, false),
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    -- NOTE: nixCats: use lazyAdd to only enable mason if nix wasnt involved.
    -- because we will be using nix to download things instead.
    enabled = require('nixCatsUtils').lazyAdd(true, false),
  },
  { import = 'custom.plugins' },
}, lazyOptions)

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
