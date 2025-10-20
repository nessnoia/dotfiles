local theme = require("alpha.themes.startify")
theme.section.header.val = {
	"                                         ███",
	"                                         ░░░",
	"████████    ██████   ██████  █████ █████ ████  █████████████",
	"░███░░███  ███░░███ ███░░███░░███ ░░███ ░░███ ░░███░░███░░███ ",
	"░███ ░███ ░███████ ░███ ░███ ░███  ░███  ░███  ░███ ░███ ░███ ",
	"░███ ░███ ░███░░░  ░███ ░███ ░░███ ███   ░███  ░███ ░███ ░███ ",
	"████ █████░░██████ ░░██████   ░░█████    █████ █████░███ █████",
	"░░░ ░░░░░  ░░░░░░   ░░░░░░     ░░░░░    ░░░░░ ░░░░░ ░░░ ░░░░░",
	t,
}
require("alpha").setup(theme.config)

require("telescope").setup({
	extensions = {
		["ui-select"] = {
			require("telescope.themes").get_dropdown(),
		},
	},
	pickers = {
		live_grep = {
			file_ignore_patterns = { "node_modules", ".git", ".venv", "*.lock" },
			additional_args = function(_)
				return { "--hidden" }
			end,
			path_display = { "filename_first" },
		},
		find_files = {
			file_ignore_patterns = { "node_modules", ".git", ".venv" },
			hidden = true,
			no_ignore = true,
		},
		colorscheme = {
			enable_preview = true,
		},
	},
})

-- Enable Telescope extensions if they are installed
pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension, "ui-select")

-- Add/delete/replace surroundings (brackets, quotes, etc.)
-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
-- - sd'   - [S]urround [D]elete [']quotes
-- - sr)'  - [S]urround [R]eplace [)] [']
require("mini.surround").setup()

-- Comment lines
require("mini.comment").setup()

-- Autopairs
require("mini.pairs").setup()

require("lualine").setup({
	options = {
		theme = "onedark",
	},
	sections = {
		lualine_c = {
			{
				"filename",
				path = 1,
			},
		},
	},
})
require("bufferline").setup({})

-- require("gitlinker").setup({
-- 	opts = {
-- 		remote = "upstream",
-- 		action_callback = require("gitlinker.actions").open_in_browser,
-- 		print_url = true,
-- 	},
-- 	mappings = nil,
-- })
--
-- require("blame").setup({
-- 	opts = {
-- 		blame_options = { "-w" },
-- 	},
-- })

require("gitsigns").setup({
	signs = {
		add = { text = "+" },
		change = { text = "~" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
	},
})

require("nvim-treesitter.configs").setup({
	-- Autoinstall languages that are not installed
	auto_install = true,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	indent = { enable = true },
})

require("onedark").setup({
	colors = {
		bg0 = "#050505",
	},
})
require("onedark").load()

require("nvim-ts-autotag").setup()

-- require("neotest").setup({
-- 	adapters = {
-- 		require("rustaceanvim.neotest"),
-- 	},
-- })
