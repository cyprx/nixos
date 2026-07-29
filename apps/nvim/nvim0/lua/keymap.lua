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
-- keymap("n", "<leader>n", ":NvimTreeToggle<CR>", { desc = "Toggle Nvim Tree" })
keymap("n", "<leader>n", ":lua MiniFiles.open()<CR>", { desc = "Toggle Mini Tree" })

-- Telescope
-- vim.keymap.set('n', '<leader>ff', function() require('telescope.builtin').find_files() end, { desc = 'Telescope find files' })
-- vim.keymap.set('n', '<leader>fg', function() require('telescope.builtin').live_grep() end, { desc = 'Telescope live grep' })
-- vim.keymap.set('n', '<leader>fb', function() require('telescope.builtin').buffers() end, { desc = 'Telescope buffers' })
-- vim.keymap.set('n', '<leader>fh', function() require('telescope.builtin').help_tags() end, { desc = 'Telescope help tags' })

-- Fzf Lua
vim.keymap.set('n', '<leader>ff', ':FzfLua files resume=true<CR>', { desc = 'Fzf find files' })
vim.keymap.set('n', '<leader>fg', ':FzfLua live_grep resume=true<CR>', { desc = 'fzf live grep' })
vim.keymap.set('n', '<leader>fb', ':FzfLua buffers resume=true<CR>', { desc = 'fzf buffers' })

-- LSP
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    local opts = { buffer = ev.buf }
    
    -- Jumps
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, opts)

    -- Information & Actions
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)

    -- Diagnostics
    vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
  end,
})
