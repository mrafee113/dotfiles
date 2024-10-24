return {
	settings = {
		cmd = { "echo", "hello" },
		pyright = {
			-- using ruff's organize imports
			disableOrganizeImports = true,
		},
		python = {
			analysis = {
				-- Ignore all files for analysis to exclusively use Ruff for linting
				ignore = { "*" },
				stubPath = vim.fn.stdpath("data") .. "/lazy/python-type-stubs",

				indexing = true,
				typeCheckingMode = "basic",
				diagnosticMode = "openFilesOnly",
				autoImportCompletions = false,
				autoSearchPaths = false,
			},
		},
	},
	on_attach = function(client, bufnr)
		if client.name == "pyright" then
			client.server_capabilities.renameProvider = false
			client.server_capabilities.hoverProvider = false
			client.server_capabilities.signatureHelpProvider = false
			client.server_capabilities.definitionProvider = false
			client.server_capabilities.referencesProvider = false
			client.server_capabilities.completionProvider = {
				resolveProvider = true,
				triggerCharacters = { "." },
			}
		end
	end,
}
