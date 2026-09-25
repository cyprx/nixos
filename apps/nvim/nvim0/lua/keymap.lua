-- Set leader key to spacebar
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local keymap = vim.keymap.set

-- Navigation keybinds mirror Helix (https://docs.helix-editor.com/keymap.html).
-- Editing keybinds stay Vim-native.

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

-- Goto mode (Helix `g`) ------------------------------------------------------
keymap({ "n", "x", "o" }, "gh", "0", { desc = "Goto line start" })
keymap({ "n", "x", "o" }, "gl", "$", { desc = "Goto line end" })
keymap({ "n", "x", "o" }, "gs", "^", { desc = "Goto first non-whitespace" })
-- Normal/visual only so the operator-pending `ge` word motion (e.g. `dge`) survives.
keymap({ "n", "x" }, "ge", "G", { desc = "Goto last line" })
keymap({ "n", "x" }, "g.", "`.", { desc = "Goto last modification" })
keymap("n", "gn", "<cmd>bnext<CR>", { desc = "Goto next buffer" })
keymap("n", "gp", "<cmd>bprevious<CR>", { desc = "Goto previous buffer" })

-- Space mode (Helix `space`) -------------------------------------------------
keymap("n", "<leader>f", ":FzfLua files resume=true<CR>", { desc = "File picker" })
keymap("n", "<leader>F", function()
  require("fzf-lua").files({ cwd = vim.fn.expand("%:p:h") })
end, { desc = "File picker at buffer directory" })
keymap("n", "<leader>b", ":FzfLua buffers resume=true<CR>", { desc = "Buffer picker" })
keymap("n", "<leader>j", ":FzfLua jumps<CR>", { desc = "Jumplist picker" })
keymap("n", "<leader>g", ":FzfLua git_status<CR>", { desc = "Changed file picker" })
keymap("n", "<leader>s", ":FzfLua lsp_document_symbols<CR>", { desc = "Document symbol picker" })
keymap("n", "<leader>S", ":FzfLua lsp_live_workspace_symbols<CR>", { desc = "Workspace symbol picker" })
keymap("n", "<leader>d", ":FzfLua diagnostics_document<CR>", { desc = "Document diagnostics picker" })
keymap("n", "<leader>D", ":FzfLua diagnostics_workspace<CR>", { desc = "Workspace diagnostics picker" })
keymap("n", "<leader>'", ":FzfLua resume<CR>", { desc = "Last picker" })
keymap("n", "<leader>/", ":FzfLua live_grep resume=true<CR>", { desc = "Global search" })
keymap("n", "<leader>?", ":FzfLua commands<CR>", { desc = "Command palette" })
keymap("n", "<leader>w", "<C-w>", { remap = true, desc = "Window mode" })

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
    vim.keymap.set('n', '<leader>k', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)

    -- Diagnostics
    vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
    vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1 }) end)
    vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1 }) end)
    vim.keymap.set('n', '[D', function() vim.diagnostic.jump({ count = -math.huge }) end)
    vim.keymap.set('n', ']D', function() vim.diagnostic.jump({ count = math.huge }) end)
  end,
})
