-- setting options `:help vim.opt`, `:help vim.option-list`

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- leader key and mapping
-- `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "

-- set to true if the terminal's font is set to a nerd font
vim.g.have_nerd_font = true

-- enable mouse mode
vim.opt.mouse = "a"

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
-- vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- remove error sound effect
vim.opt.errorbells = false

-- open vimrc
-- vim.api.nvim_set_keymap("n", "<leader>v", ":e ~/.vimrc<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>V", ":tabnew ~/.vimrc<CR>", { noremap = true, silent = true })
