return {
	-- Neovim development
	"folke/neodev.nvim",

	-- Language support, mainly for indentation because it's more stable than treesitter in Dart
	-- "dart-lang/dart-vim-plugin",

	{
		"nvim-treesitter/nvim-treesitter-context",
		config = function()
			require("treesitter-context").setup({
				enable = false,
			})
		end,
	},

	--Git

	{
		"kdheepak/lazygit.nvim",
		cmd = "LazyGit",
		keys = {
			{ "<leader>gg", "<cmd>LazyGit<cr>", desc = "Open LazyGit" },
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},

	-- Color
	{
		"Shatur/neovim-ayu",
		name = "ayu",
		config = function()
			require("ayu").setup({
				mirage = false, -- Set `true` for Ayu Mirage (softer dark theme)
			})

			local auto_dark_mode = require("auto-dark-mode")

			auto_dark_mode.setup({
				update_interval = 1000,
				set_dark_mode = function()
					vim.api.nvim_set_option("background", "dark")
					vim.api.nvim_command("colorscheme ayu")
				end,
				set_light_mode = function()
					vim.api.nvim_set_option("background", "light")
					vim.api.nvim_command("colorscheme ayu")
				end,
			})

			auto_dark_mode.init()
		end,
		dependencies = {
			"f-person/auto-dark-mode.nvim",
		},
	},

	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup({
				mappings = {
					basic = true, -- Enables default key mappings
					extra = false,
				},
			})

			-- Custom key mappings for commenting
			vim.api.nvim_set_keymap(
				"n",
				"<leader>c",
				'<cmd>lua require("Comment.api").toggle.linewise.current()<CR>',
				{ noremap = true, silent = true }
			)
			vim.api.nvim_set_keymap(
				"v",
				"<leader>c",
				'<ESC><cmd>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>',
				{ noremap = true, silent = true }
			)
		end,
	},

	-- Lualine

	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				sections = {
					lualine_c = { "buffers" },
				},
			})
		end,
	},

	-- Buffer Retirement

	{
		"chrisgrieser/nvim-early-retirement",
		config = function()
			require("early-retirement").setup({
				retirementAgeMins = 10,
			})
		end,
		event = "VeryLazy",
	},
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("oil").setup({
			})
		end,
		keys = {
			{ "<leader>ee", "<cmd>Oil<CR>", desc = "Open parent directory" },
		},
	},
}
