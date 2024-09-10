return {
	settings = {
		pylsp = {
			configurationSources = {},
			plugins = {
				autopep8 = { enabled = false },
				yapf = { enabled = false },
				flake8 = { enabled = false },
				preload = { enabled = false },
				pycodestyle = { enabled = false },
				pyflakes = { enabled = false },
				pylint = { enabled = false },

				pydocstyle = { enabled = false },
				mccabe = { enabled = false },
				pylsp_black = { enabled = false },
				pyls_isort = { enabled = false },

				rope = { enabled = false },
				rope_completion = { enabled = false },
				rope_rename = { enabled = false },

				jedi_definition = {
					enabled = true,
					follow_imports = true,
					follow_builtin_imports = true,
					follow_builtin_definitions = true,
				},
				jedi_rename = { enabled = true },
				jedi_completion = {
					enabled = true,
					include_params = true,
					cache_labels_for = {
						"pandas",
						"numpy",
						"pydantic",
						"fastapi",
						"flask",
						"sqlalchemy",
						"dagster",
					},
				},
				jedi_hover = { enabled = true },

				pylsp_mypy = {
					enabled = false,
					live_mode = false,
					dmypy = false,
					report_progress = false,
					-- args = {
					--   "--sqlite-cache", -- Use an SQLite database to store the cache.
					--   "--cache-fine-grained", -- Include fine-grained dependency information in the cache for the mypy daemon.
					-- },
				},
			},
		},
	},
	on_attach = function(client, bufnr)
		if client.name == "pylsp" then
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false
		end
	end,
}
