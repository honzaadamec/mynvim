return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup()
		end,
	},
	{
		-- bridges the gap between mason and lspconfig
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		version = "1.29.0",
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local lsp_config = require("lspconfig")
			require("mason-lspconfig").setup({
				ensure_installed = {
					"astro",
					"tailwindcss",
					"tsserver",
					"lua_ls",
					"ansiblels",
					"yamlls",
					"eslint",
				},
			})

			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
			vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
			vim.keymap.set("n", "<leader>dl", vim.diagnostic.setqflist)
			vim.keymap.set("n", "<leader>de", function()
				vim.diagnostic.setqflist({ severity = vim.diagnostic.severity.ERROR })
			end)

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					-- Buffer local mappings.
					-- See `:help vim.lsp.*` for documentation on any of the below functions
					local opts = { buffer = ev.buf }

					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
					vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
				end,
			})

			--vim.keymap.set({ "n", "i" }, "<C-b>", function()
			--	vim.lsp.inlay_hint(0, nil)
			--end)

			vim.api.nvim_create_autocmd("DiagnosticChanged", {
				group = vim.api.nvim_create_augroup("AutoUpdateQuickfix", {}),
				callback = function()
					local diagnostics = vim.diagnostic.get(nil, { severity = vim.diagnostic.severity.ERROR })
					local quickfix_items = {}

					for _, diagnostic in ipairs(diagnostics) do
						table.insert(quickfix_items, {
							bufnr = diagnostic.bufnr,
							lnum = diagnostic.lnum + 1,
							col = diagnostic.col + 1,
							text = diagnostic.message,
						})
					end

					vim.fn.setqflist(quickfix_items, "r")
				end,
			})

			vim.diagnostic.config({
				virtual_text = true,
				signs = false,
			})

			-- local dartExcludedFolders = {
			-- 	vim.fn.expand("$HOME/AppData/Local/Pub/Cache"),
			-- 	vim.fn.expand("$HOME/.pub-cache"),
			-- 	vim.fn.expand("/opt/homebrew/"),
			-- 	vim.fn.expand("$HOME/development/flutter/"),
			-- }

			-- 			lsp_config["dcmls"].setup({
			--         capabilities = capabilities,
			--           cmd = { "dcm", "start-server" },
			--           filetypes = { "dart", "yaml" },
			--           settings = {
			--           dart = {
			--             analysisExcludedFolders = dartExcludedFolders,
			--             },
			--           },
			--           handlers = {
			--             ["workspace/didChangeConfiguration"] = function(_, _, _) return end
			--           },
			--         })
			--
			-- lsp_config["dartls"].setup({
			-- 	capabilities = capabilities,
			-- 	cmd = {
			-- 		"dart",
			-- 		"language-server",
			-- 		"--protocol=lsp",
			-- 		-- "--port=8123",
			-- 		-- "--instrumentation-log-file=/Users/robertbrunhage/Desktop/lsp-log.txt",
			-- 	},
			-- 	filetypes = { "dart" },
			-- 	init_options = {
			-- 		onlyAnalyzeProjectsWithOpenFiles = true,
			-- 		suggestFromUnimportedLibraries = true,
			-- 		closingLabels = true,
			-- 		outline = false,
			-- 		flutterOutline = false,
			-- 	},
			-- 	color = {
			-- 		enabled = true,
			-- 		background = false,
			-- 		foreground = false,
			-- 		virtual_text = true,
			-- 		virtual_text_str = "■",
			-- 	},
			-- 	settings = {
			-- 		dart = {
			-- 			lineLength = 120,
			-- 			analysisExcludedFolders = dartExcludedFolders,
			-- 			updateImportsOnRename = true,
			-- 			completeFunctionCalls = true,
			-- 			showTodos = true,
			-- 			enableSnippets = true,
			-- 		},
			-- 	},
			-- })
			--
			lsp_config.astro.setup({
				capabilities = capabilities,
			})

			lsp_config.tailwindcss.setup({
				capabilities = capabilities,
			})

			lsp_config.ts_ls.setup({
				capabilities = capabilities,
			})

			lsp_config.lua_ls.setup({
				capabilities = capabilities,
				settings = {
					Lua = {
						-- runtime = {
						--   version = "LuaJIT",
						-- },
						diagnostics = {
							globals = { "vim" },
						},
						-- workspace = {
						--   checkThirdParty = false,
						--   library = {
						--     '${3rd}/luv/library',
						--     unpack(vim.api.nvim_get_runtime_rile("", true)),
						--     vim.api.nvim_get_proc,
						--   }
						-- },
					},
				},
			})

			-- Ansible Language Server
			lsp_config.ansiblels.setup({
				capabilities = capabilities,
				settings = {
					ansible = {
						ansible = {
							path = "ansible",
						},
						ansibleLint = {
							enabled = true,
							path = "ansible-lint",
						},
						python = {
							interpreterPath = "python3",
						},
					},
				},
			})

			lsp_config.yamlls.setup({
				capabilities = capabilities,
				settings = {
					yaml = {
						format = { enable = true },
						validate = true,
						completion = true,
						hover = true,
					},
				},
			})

			lsp_config.eslint.setup({
				capabilities = capabilities,
			})

			-- Tooltip for the lsp in bottom right
			require("fidget").setup({})

			-- Hot reload :)
			require("dart-tools")
		end,
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",

			{ "j-hui/fidget.nvim", tag = "legacy" },
			-- support for dart hot reload on save
			"RobertBrunhage/dart-tools.nvim",
		},
	},
}
