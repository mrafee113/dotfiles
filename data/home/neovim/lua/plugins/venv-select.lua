return {
	"linux-cultist/venv-selector.nvim",
	dependencies = {
		"neovim/nvim-lspconfig",
		"mfussenegger/nvim-dap",
		"mfussenegger/nvim-dap-python", --optional
		{ "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
	},
	lazy = false,
	branch = "regexp", -- This is the regexp branch, use this for the new version
	config = function()
		local function shorter_name(filename)
			return filename:gsub(os.getenv("HOME") .. "/.venvs/", ""):gsub("/bin/python", "")
		end
		require("venv-selector").setup({
			settings = {
				search = {
					cwd = false,
					workspace = false,
					venvs = {
						command = "find ~/.venvs -type f,l -name '*python' ! -name '*ipython'",
						on_telescope_result_callback = shorter_name,
					},
				},
			},
		})
	end,
	keys = {
		{ "<leader>v", "<cmd>VenvSelect<cr>" },
	},
}
