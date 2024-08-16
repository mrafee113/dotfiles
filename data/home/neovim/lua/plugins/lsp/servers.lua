-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. Available keys are:
--  - cmd (table): Override the default command used to start the server
--  - filetypes (table): Override the default list of associated filetypes for the server
--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
--  - settings (table): Override the default settings passed when initializing the server.
--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
return {
	clangd = {},
	gopls = require("plugins.lsp.servers.gopls"),
	bashls = {},
	pyright = require("plugins.lsp.servers.pyright"),
	ruff = require("plugins.lsp.servers.ruff"),
	lua_ls = require("plugins.lsp.servers.lua_ls"),
	beancount = require("plugins.lsp.servers.beancount"),
	-- sqls = {},
	-- pylsp = require("plugins.lsp.servers.pylsp"),
	-- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
}
