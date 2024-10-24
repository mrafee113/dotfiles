-- ignore case in searches unless an uppercase letter is used
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- show matching brackets and parentheses
vim.opt.showmatch = true

-- show line numbers and relative line numbers in the status line
vim.opt.number = true
vim.opt.relativenumber = true
vim.api.nvim_set_keymap("n", "<leader>n", ":set relativenumber!<CR>", { noremap = true, silent = true })

-- set the maximum width for automatic line breaking to 100
-- vim.opt.textwidth = 100

-- do not show the mode, since it's already in the status line
-- vim.opt.showmode = false

vim.opt.cmdheight = 1

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

---- indentation
-- use tabs instead of spaces for indentation
-- vim.opt.expandtab = false
-- set the width of a tab to 4 spaces
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.breakindent = true

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- clear searches
vim.keymap.set("n", "<leader>hh", function()
	vim.fn.clearmatches()
	vim.cmd("noh")
end, { noremap = true, silent = true })

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
--   group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- disable code folding
vim.opt.foldenable = false
