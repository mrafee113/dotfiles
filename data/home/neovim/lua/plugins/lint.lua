-- Linting
return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile", "InsertLeave" },
	-- event = { "BufWritePost", "BufReadPost", "InsertLeave" },
	config = function()
		local lint = require("lint")
		local mason_registry = require("mason-registry")
		lint.linters_by_ft = {}

		-- get a list of supported linters here: https://github.com/mfussenegger/nvim-lint#available-linters
		-- Mapping of language to linter-to-mason-package name
		local linter_pkg_map = {
			markdown = { markdownlint = "markdownlint" },
			text = { vale = "vale" },
			rst = { vale = "vale" },
			go = { golangcilint = "golangci-lint" },
			json = { jsonlint = "jsonlint" },
			python = { ruff = "ruff" },
			yaml = { yamllint = "yamllint" },
		}

		for ft, linters in pairs(linter_pkg_map) do
			lint.linters_by_ft[ft] = {}

			for linter, mason_pkg in pairs(linters) do
				-- Add the linter to the appropriate file type in linters_by_ft
				table.insert(lint.linters_by_ft[ft], linter)

				-- Check if the linter's corresponding Mason package is installed
				if not mason_registry.is_installed(mason_pkg) then
					-- Install the linter if it's not installed
					mason_registry.get_package(mason_pkg):install()
				end
			end
		end

		-- You can disable the default linters by setting their filetypes to nil:
		-- lint.linters_by_ft['clojure'] = nil

		-- Create autocommand which carries out the actual linting
		-- on the specified events.
		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}
