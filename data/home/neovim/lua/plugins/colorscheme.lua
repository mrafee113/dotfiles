-- You can easily change to a different colorscheme.
-- Change the name of the colorscheme plugin below, and then
-- change the command in the config to whatever the name of that colorscheme is.
--
-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
return {
	-- 	{
	-- 		"folke/tokyonight.nvim",
	-- 		priority = 1000, -- Make sure to load this before all the other start plugins.
	-- 		-- 		init = function()
	-- 		-- 			-- Load the colorscheme here.
	-- 		-- 			-- Like many other themes, this one has different styles, and you could load
	-- 		-- 			-- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
	-- 		-- 			vim.cmd.colorscheme("tokyonight-night")
	-- 		--
	-- 		-- 			-- You can configure highlights by doing something like:
	-- 		-- 			vim.cmd.hi("Comment gui=none")
	-- 		-- 		end,
	-- 	},

	-- 	{
	-- 		"0xstepit/flow.nvim",
	-- 		lazy = false,
	-- 		priority = 1000,
	-- 		opts = {},
	-- 		config = function()
	-- 			require("flow").setup({
	-- 				transparent = false, -- Set transparent background.
	-- 				fluo_color = "green", --  Fluo color: pink, yellow, orange, or green.
	-- 				mode = "normal", -- Intensity of the palette: normal, bright, desaturate, or dark. Notice that dark is ugly!
	-- 				aggressive_spell = false, -- Display colors for spell check.
	-- 			})
	-- 		end,
	-- 	},

	{
		"HoNamDuong/hybrid.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
	},

	-- 	{
	-- 		"AlexvZyl/nordic.nvim",
	-- 		lazy = false,
	-- 		priority = 1000,
	-- 	},

	-- 	{ "neanias/everforest-nvim", version = false, lazy = false },

	-- 	{ "EdenEast/nightfox.nvim", lazy = false, priority = 1000 },
}
