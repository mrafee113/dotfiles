---- treesitter syntaxes
-- *.rc
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.rc",
	command = "setlocal filetype=bash",
})

-- *.bc beancount
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.bc",
	command = "setlocal filetype=beancount",
})

-- *.i3config
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.i3config",
	command = "setlocal filetype=i3config",
})
