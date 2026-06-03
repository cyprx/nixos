-- Set leader key to spacebar
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local keymap = vim.keymap.set

-- General Keymaps
-- keymap("n", "<leader>nh", ":nohlsearch<CR>", { desc = "Clear search highlights" })
-- Send all project/buffer diagnostics to the quickfix list
vim.keymap.set('n', '<leader>qd', vim.diagnostic.setqflist, { desc = "Toggle Diagnostic Quickfix" })

-- Navigate quickly through the errors
vim.keymap.set('n', '[c', '<cmd>cprev<cr>', { desc = "Previous Quickfix Item" })
vim.keymap.set('n', ']c', '<cmd>cnext<cr>', { desc = "Next Quickfix Item" })

-- Nvim Tree
keymap("n", "<leader>n", ":NvimTreeToggle<CR>", { desc = "Toggle Nvim Tree" })

-- Telescope
vim.keymap.set('n', '<leader>ff', function() require('telescope.builtin').find_files() end, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', function() require('telescope.builtin').live_grep() end, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', function() require('telescope.builtin').buffers() end, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', function() require('telescope.builtin').help_tags() end, { desc = 'Telescope help tags' })

