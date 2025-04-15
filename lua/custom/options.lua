local g = vim.g
local o = vim.opt

-- disable some default providers
g.loaded_node_provider = 0
g.loaded_python3_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0

g.rust_recommended_style = 0

-- Map the leader
g.mapleader = ' '
g.maplocalleader = ' '

-- Have Nerd Fonts?
g.have_nerd_font = true

-- General
o.number = false
-- o.relativenumber = true
o.mouse = 'a'
o.showmode = false

-- Clipboard
vim.schedule(function()
  o.clipboard = 'unnamedplus'
end)

o.splitbelow = true
o.splitright = true
o.ruler = false
o.breakindent = true
o.undofile = true
o.ignorecase = true
o.smartcase = true
o.signcolumn = 'yes'
o.updatetime = 250
o.timeoutlen = 300
o.splitright = true
o.splitbelow = true
-- o.list = true
-- o.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
o.inccommand = 'split'
o.cursorline = true
o.scrolloff = 10
o.confirm = true
vim.opt.hlsearch = true

vim.wo.foldlevel = 99
vim.wo.conceallevel = 2

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
