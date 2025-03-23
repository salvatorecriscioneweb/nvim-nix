local map = vim.keymap.set

map('n', '<Esc>', '<cmd>nohlsearch<CR>')
map('n', '<leader>q', '<cmd>qa<CR>', { desc = 'Quit NeoVim' })
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

map({ 'n', 'v' }, '<LocalLeader>ac', '<cmd>CodeCompanionChat Toggle<cr>', { noremap = true, silent = true })
map('n', '<leader>aa', '<cmd>CodeCompanionActions<CR>', { silent = true, desc = 'Open AI Actions' })

-- buffers
map('n', '<S-h>', '<cmd>bprevious<cr>', { desc = 'Prev Buffer' })
map('n', '<S-l>', '<cmd>bnext<cr>', { desc = 'Next Buffer' })
map('n', '[b', '<cmd>bprevious<cr>', { desc = 'Prev Buffer' })
map('n', ']b', '<cmd>bnext<cr>', { desc = 'Next Buffer' })
map('n', '<leader>bb', '<cmd>e #<cr>', { desc = 'Switch to Other Buffer' })
map('n', '<leader>`', '<cmd>e #<cr>', { desc = 'Switch to Other Buffer' })
map('n', '<leader>bd', '<cmd>bd<cr>', { desc = 'Delete Buffer' })
map('n', '<leader>bo', '<cmd>bo<cr>', { desc = 'Delete Other Buffers' })
map('n', '<leader>bD', '<cmd>:bd<cr>', { desc = 'Delete Buffer and Window' })
map('n', '<leader>bn', '<cmd>enew<CR>', { desc = 'Buffer new' })

map('n', '<C-s>', '<cmd>w<CR>', { desc = 'general save file' })
map('n', '<C-c>', '<cmd>%y+<CR>', { desc = 'general copy whole file' })

-- map('n', '<leader>e', '<cmd>Neotree toggle<CR>', { desc = 'NeoTree toggle window' })
map('n', '<leader>e', '<cmd>NvimTreeToggle<CR>', { desc = 'Nvimtree toggle window' })

map('n', '<leader>ds', vim.diagnostic.setloclist, { desc = 'LSP diagnostic loclist' })
