local map = vim.keymap.set

-- Git
map("n", "gb", ":Git blame<CR>", { desc = "Toggle git blame" })
map("n", "gU", ":Gitsigns reset_hunk<CR>", { desc = "Reset git hunk" })

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
map("n", "<C-a>", builtin.live_grep, { desc = "Search by Grep" })
map("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
-- Shortcut for searching your Neovim configuration files
vim.keymap.set("n", "<leader>sn", function()
	builtin.find_files({ cwd = vim.fn.stdpath("config") })
end, { desc = "[S]earch [N]eovim files" })

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
		lsp_map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
		lsp_map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
		lsp_map("gi", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
		lsp_map("gR", vim.lsp.buf.rename, "[G]o [R]ename")
		--  For example, in C this would take you to the header.
		lsp_map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
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
		["<C-l>"] = cmp.mapping.confirm({ select = true }),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			else
				fallback()
			end
		end, { "i", "s" }),
		-- Scroll the documentation window [b]ack / [f]orward
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete({}),
	},
})

-- Accept ([y]es) the completion.
--  This will auto-import if your LSP supports it.
--  This will expand snippets if the LSP sent a snippet.
-- ['<C-y>'] = cmp.mapping.confirm { select = true },

-- If you prefer more traditional completion keymaps,
-- you can uncomment the following lines
--
-- Manually trigger a completion from nvim-cmp.
--  Generally you don't need this, because nvim-cmp will display
--  completions whenever it has completion options available.

-- Think of <c-l> as moving to the right of your snippet expansion.
--  So if you have a snippet that's like:
--  function $name($args)
--    $body
--  end
--
-- <c-l> will move you to the right of each of the expansion locations.
-- <c-h> is similar, except moving you backwards.
-- ["<C-l>"] = cmp.mapping(function()
-- 	if luasnip.expand_or_locally_jumpable() then
-- 		luasnip.expand_or_jump()
-- 	end
-- end, { "i", "s" }),
-- ["<C-h>"] = cmp.mapping(function()
-- 	if luasnip.locally_jumpable(-1) then
-- 		luasnip.jump(-1)
-- 	end
-- end, { "i", "s" }),

-- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
--    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
