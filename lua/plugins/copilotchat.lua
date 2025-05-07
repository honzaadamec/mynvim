return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
			{ "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log, and async functions
		},
		build = "make tiktoken", -- Only on MacOS or Linux
		lazy = false,
		opts = {
			-- See Configuration section for options
                        defualt_model = "claude-3.7",
			on_attach = function(client, bufnr)
				-- Attach Copilot to the buffer when it is loaded
				vim.api.nvim_create_autocmd("BufEnter", {
					buffer = bufnr,
					callback = function()
						require("copilot").setup_buffer(bufnr)
					end,
				})
			end,
		},
		-- See Commands section for default commands if you want to lazy load on them
		keys = {
			{ "<leader>cc", ":CopilotChat<CR>", mode = "n", desc = "Chat with Copilot" },
			{ "<leader>cc", ":CopilotChat<CR>", mode = "v", desc = "Chat with Copilot" },
			{ "<leader>ce", ":CopilotChatExplain<CR>", mode = "v", desc = "Explain Code" },
			{ "<leader>cr", ":CopilotChatReview<CR>", mode = "v", desc = "Review Code" },
			{ "<leader>cf", ":CopilotChatFix<CR>", mode = "v", desc = "Fix Code Issues" },
			{ "<leader>co", ":CopilotChatOptimize<CR>", mode = "v", desc = "Optimize Code" },
			{ "<leader>cd", ":CopilotChatDocs<CR>", mode = "v", desc = "Generate Docs" },
			{ "<leader>ct", ":CopilotChatTests<CR>", mode = "v", desc = "Generate Tests" },
			{ "<leader>cm", ":CopilotChatCommit<CR>", mode = "n", desc = "Generate Commit Message" },
			{ "<leader>cs", ":CopilotChatCommit<CR>", mode = "v", desc = "Generate Commit for Selection" },
		},
	},
}
