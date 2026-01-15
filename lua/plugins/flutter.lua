-- ~/.config/nvim/lua/plugins/flutter.lua
return {
	"akinsho/flutter-tools.nvim",
	ft = { "dart" },
	dependencies = {
		"nvim-lua/plenary.nvim",
		"neovim/nvim-lspconfig",
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		local util = require("lspconfig.util")
		local home = vim.loop.os_homedir()

		local function real(p)
			return (p and vim.loop.fs_realpath(p)) or nil
		end
		local function dbg(msg)
			vim.notify("[flutter-tools] " .. msg, vim.log.levels.INFO, { title = "Dart LSP" })
		end

		-- Root projektu
		local root = util.root_pattern("pubspec.yaml", ".git")(vim.loop.cwd()) or vim.loop.cwd()

		-- Flutter SDK (FVM pokud je)
		local fvm_path = vim.fn.trim(vim.fn.system("fvm flutter --print-path 2>/dev/null"))
		if fvm_path == "" then
			fvm_path = os.getenv("FLUTTER_HOME") or ""
		end
		local flutter_sdk = real(fvm_path)
		local dart_bin = flutter_sdk and (flutter_sdk .. "/bin/dart") or "dart"

		-- Kandidáti na exclude → jen existující složky (realpath)
		local candidates = {
			root and (root .. "/.dart_tool"),
			root and (root .. "/build"),
			root and (root .. "/ios/Pods"),
			root and (root .. "/android/.gradle"),
			root and (root .. "/.fvm"),
			home .. "/.pub-cache",
			home .. "/AppData/Local/Pub/Cache",
			"/opt/homebrew",
			flutter_sdk,
			flutter_sdk and (flutter_sdk .. "/packages"),
			flutter_sdk and (flutter_sdk .. "/.pub-cache"),
		}
		local dartExcludedFolders = {}
		for _, p in ipairs(candidates) do
			local rp = real(p)
			if rp and vim.fn.isdirectory(rp) == 1 then
				table.insert(dartExcludedFolders, rp)
			end
		end

		-- Debug při startu
		dbg("root_dir: " .. (root or "?"))
		dbg("flutter_sdk: " .. (flutter_sdk or "not found"))
		dbg("dart_bin: " .. (dart_bin or "dart"))
		dbg("excluded (" .. #dartExcludedFolders .. "):\n  - " .. table.concat(dartExcludedFolders, "\n  - "))

		-- :DartLspDebug – moderní API
		vim.api.nvim_create_user_command("DartLspDebug", function()
			local clients = vim.lsp.get_clients({ name = "dartls", bufnr = 0 })
			if #clients == 0 then
				vim.notify("[flutter-tools] dartls není aktivní pro tenhle buffer.", vim.log.levels.WARN)
				return
			end
			local c = clients[1]
			vim.notify(
				("[flutter-tools] client id=%s, name=%s, root_dir=%s"):format(c.id, c.name, c.config.root_dir or "?"),
				vim.log.levels.INFO
			)
			vim.notify("[flutter-tools] cmd=" .. table.concat(c.config.cmd or {}, " "), vim.log.levels.INFO)
			print("dartls.settings = " .. vim.inspect(c.config.settings))
			print("log path = " .. vim.lsp.get_log_path())
		end, {})

		require("flutter-tools").setup({
			outline = { auto_open = false, open_cmd = "botright 50vnew" },
			lsp = {
				capabilities = capabilities,
				flags = { allow_incremental_sync = false, debounce_text_changes = 150 },
				init_options = {
					onlyAnalyzeProjectsWithOpenFiles = true,
					suggestFromUnimportedLibraries = true,
					closingLabels = true,
					outline = false,
					flutterOutline = false,
				},
				-- ⬇️ bez "dart = { ... }" — flutter-tools to přidá samo
				settings = {
					lineLength = 120,
					analysisExcludedFolders = dartExcludedFolders,
					updateImportsOnRename = true,
					completeFunctionCalls = true,
					showTodos = true,
					enableSnippets = true,
				},
				on_init = function(client, _)
					dbg("on_init: " .. client.name .. " (root=" .. (client.config.root_dir or "?") .. ")")
					local v = vim.fn.system(dart_bin .. " --version")
					if v and v ~= "" then
						dbg("dart --version: " .. v:gsub("\n", " "))
					end
				end,
				on_attach = function(client, bufnr)
					dbg("on_attach: " .. client.name .. " → buf " .. bufnr)
				end,
			},
		})

		-- Zkratka pro Outline
		vim.keymap.set(
			"n",
			"<leader>ffo",
			"<cmd>FlutterOutlineOpen<CR>",
			{ desc = "Flutter: Toggle Outline", silent = true }
		)

		print("[Dart LSP] Použij :DartLspDebug pro dump nastavení. Log: " .. vim.lsp.get_log_path())
	end,
}
