local map = vim.keymap.set

-- Git
map("n", "gb", ":Git blame<CR>", { desc = "Toggle git blame" })
require("gitsigns").setup({
	on_attach = function(bufnr)
		local gitsigns = require("gitsigns")

		map("n", "gU", function()
			gitsigns.reset_hunk()
		end)

		-- Navigation
		map("n", "]c", function()
			if vim.wo.diff then
				vim.cmd.normal({ "]c", bang = true })
			else
				gitsigns.nav_hunk("next")
			end
		end)

		map("n", "[c", function()
			if vim.wo.diff then
				vim.cmd.normal({ "[c", bang = true })
			else
				gitsigns.nav_hunk("prev")
			end
		end)
	end,
})

map("n", "gu", ":.GBrowse upstream/main:%<CR>", { desc = "Open link in browser from remote upstream" })
map("v", "gu", ":.GBrowse upstream/main:%<CR>", { desc = "Open link in browser from remote upstream" })
map("n", "gw", ":.GBrowse<CR>", { desc = "Open link in browser from default remote" })
map("v", "gw", ":.GBrowse<CR>", { desc = "Open link in browser from default remote" })
map("n", "gp", ":0,3Git blame<CR>", { desc = "Open [G]it [p]review of commit line" })

-- Buffers
map("n", "<C-h>", ":bprev<Enter>", { desc = "Switch to next buffer" })
map("n", "<C-l>", ":bnext<Enter>", { desc = "Switch to prev buffer" })
map("n", "gB", ":ls<CR>:b<Space>", { desc = "List buffers" })
map("n", "<C-x>", ":bw<CR>", { desc = "Close buffer" })
map("n", "<Leader>x", ":bp<bar>sp<bar>bn<bar>bd<CR>", { desc = "Close buffer without closing window" })

-- Accelerated scrolling
map("n", "J", "5j")
map("n", "K", "5k")
map("n", "H", "5h")
map("n", "L", "5l")

-- map('n', '<leader>h', function()
--   vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
-- end, { desc = 'Toggle inlay hints' })

-- Fuzzy finding
local builtin = require("telescope.builtin")
map("n", "<C-f>", builtin.find_files, { desc = "Search Files" })
map("n", "<C-s>", builtin.grep_string, { desc = "Search current Word" })
map("v", "<C-s>", builtin.grep_string, { desc = "Search current Word" })
map("n", "<C-a>", builtin.live_grep, { desc = "Search by Grep" })
map("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
-- Shortcut for searching your Neovim configuration files
vim.keymap.set("n", "<leader>sn", function()
	builtin.find_files({ cwd = vim.fn.stdpath("config") })
end, { desc = "[S]earch [N]eovim files" })

-- Telescope
require("telescope").setup({
	defaults = {
		mappings = {
			i = {
				["<M-Down>"] = require("telescope.actions").cycle_history_next,
				["<M-Up>"] = require("telescope.actions").cycle_history_prev,
				-- If multiple selected, open all. Else, open as normal.
				["<CR>"] = function(prompt_bufnr)
					local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
					local multi = picker:get_multi_selection()
					if not vim.tbl_isempty(multi) then
						require("telescope.actions").close(prompt_bufnr)
						for _, j in pairs(multi) do
							if j.path ~= nil then
								vim.cmd(string.format("%s %s", "edit", j.path))
							end
						end
					else
						require("telescope.actions").select_default(prompt_bufnr)
					end
				end,
			},
			n = {
				["<M-Down>"] = require("telescope.actions").cycle_history_next,
				["<M-Up>"] = require("telescope.actions").cycle_history_prev,
			},
		},
	},
})

-- LSP
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
	callback = function(event)
		local lsp_map = function(keys, func, desc, mode)
			mode = mode or "n"
			vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end

		-- Jump to the definition of the word under your cursor.
		--  This is where a variable was first declared, or where a function is defined, etc.
		--  To jump back, press <C-t>.
		-- lsp_map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [d]efinition")
		lsp_map("gd", vim.lsp.buf.definition, "[G]oto [d]efinition")
		-- lsp_map("gr", require("telescope.builtin").lsp_references, "[G]oto [r]eferences")
		lsp_map("gr", vim.lsp.buf.references, "[G]oto [r]eferences")
		-- lsp_map("gi", require("telescope.builtin").lsp_implementations, "[G]oto [i]mplementation")
		lsp_map("gi", vim.lsp.buf.implementation, "[G]oto [i]mplementation")
		lsp_map("gR", vim.lsp.buf.rename, "[G]o [R]ename")
		lsp_map("gD", vim.lsp.buf.type_definition, "[G]oto type [D]efinition")
		lsp_map("gh", vim.lsp.buf.hover, "[G]oto [h]over")
		lsp_map("gE", vim.diagnostic.open_float, "Show diagnostics in floating window")
		lsp_map("[E", vim.diagnostic.goto_prev, "Go to previous diagnostic")
		lsp_map("]E", vim.diagnostic.goto_next, "Go to next diagnostic")
	end,
})

-- Testing
-- map("n", "gt", '<cmd>lua require"neotest".run.run()<CR>', { desc = "Run test under cursor" })
-- map("n", "gT", '<cmd>lua require"neotest".run.run(vim.fn.expand("%"))<CR>', { desc = "Run all tests in file" })
-- map("n", "<Leader>t", '<cmd>lua require"neotest".run.run({strategy = "dap"})<CR>', { desc = "Run debugger on test" })
map("n", "gt", ":TestNearest -strategy=neovim<CR>", { desc = "Run test under cursor" })
map("n", "gT", ":TestFile -strategy=neovim<CR>", { desc = "Run all tests in file" })

local cmp = require("cmp")
cmp.setup({
	mapping = {
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = false,
		}),
		["<Tab>"] = cmp.mapping.select_next_item(),
		["<S-Tab"] = cmp.mapping.select_prev_item(),
		-- ["<Tab>"] = cmp.mapping(function(fallback)
		-- 	if cmp.visible() then
		-- 		cmp.select_next_item()
		-- 	else
		-- 		fallback()
		-- 	end
		-- end, { "i", "s" }),
		-- ["<S-Tab>"] = cmp.mapping(function(fallback)
		-- 	if cmp.visible() then
		-- 		cmp.select_prev_item()
		-- 	else
		-- 		fallback()
		-- 	end
		-- end, { "i", "s" }),
		-- Scroll the documentation window [b]ack / [f]orward
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete({}),
	},
})
