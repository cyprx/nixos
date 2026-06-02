local opt = vim.opt

-- Line numbers
opt.number = true          -- Show line numbers
opt.relativenumber = true  -- Show relative numbers

-- Tabs & Indents
opt.tabstop = 4            -- Number of spaces a tab counts for
opt.softtabstop = 4        -- Number of spaces columns for editing
opt.shiftwidth = 4         -- Size of an indent
opt.expandtab = true       -- Use spaces instead of tabs

-- Search UI
opt.ignorecase = true      -- Ignore case in search patterns
opt.smartcase = true       -- Override ignorecase if search contains capitals
opt.hlsearch = true        -- Clear highlights after search matches

-- Clipboard & Windows
opt.clipboard = "unnamedplus" -- Sync with system clipboard
opt.splitbelow = true      -- Horizontal splits open below
opt.splitright = true      -- Vertical splits open to the right
