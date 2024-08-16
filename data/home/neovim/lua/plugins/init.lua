return {
	{ "tpope/vim-sleuth" }, -- Detect tabstop and shiftwidth automatically
	require("plugins.gitsigns"),
	require("plugins.which-key"),
	require("plugins.telescope"),

	-- lsp plugins
	require("plugins.lazydev"),
	{ "Bilal2453/luvit-meta", lazy = true },
	require("plugins.lsp.init"),
	require("plugins.conform"),
	require("plugins.cmp"),
	require("plugins.colorscheme"),

	-- Highlight todo, notes, etc in comments
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},

	require("plugins.mini"),
	require("plugins.treesitter"),
	require("plugins.debug"),
	require("plugins.indent-blankline"),
	require("plugins.lint"),
	require("plugins.autopairs"),
	require("plugins.neo-tree"),
	require("plugins.trouble"),
	{ "numToStr/Comment.nvim" },
	require("plugins.lualine"),
	require("plugins.venv-select"),
}
