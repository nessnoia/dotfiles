-- LSP
require('mason').setup()
require('mason-lspconfig').setup()
require("mason-lspconfig").setup_handlers {
	-- The first entry (without a key) will be the default handler
	-- and will be called for each installed server that doesn't have
	-- a dedicated handler.
	function(server_name) -- default handler (optional)
		require("lspconfig")[server_name].setup {}
	end,
	-- Next, you can provide a dedicated handler for specific servers.
	-- For example, a handler override for the `rust_analyzer`:
	-- ["rust_analyzer"] = function()
	-- 	require("rust-tools").setup {}
	-- end
}

vim.api.nvim_create_autocmd('LspAttach', {
	desc = 'LSP keybindings',
	callback = function(event)
		local bufmap = function(mode, lhs, rhs)
			local opts = { buffer = event.buf }
			vim.keymap.set(mode, lhs, rhs, opts)
		end

		-- Displays hover information about the symbol under the cursor
		bufmap('n', 'gh', '<cmd>lua vim.lsp.buf.hover()<cr>')

		-- Jump to the definition
		bufmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')

		-- Jump to declaration
		bufmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')

		-- Lists all the implementations for the symbol under the cursor
		bufmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')

		-- Jumps to the definition of the type symbol
		bufmap('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>')

		-- Lists all the references
		bufmap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')

		-- Displays a function's signature information
		bufmap('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>')

		-- Renames all references to the symbol under the cursor
		bufmap('n', 'gR', '<cmd>lua vim.lsp.buf.rename()<cr>')

		-- Format code in current buffer
		bufmap({ 'n', 'x' }, 'gX', '<cmd>lua vim.lsp.buf.format({async = true})<cr>')

		-- Show diagnostics in a floating window
		bufmap('n', 'gE', '<cmd>lua vim.diagnostic.open_float()<cr>')

		-- Move to the previous diagnostic
		bufmap('n', '[E', '<cmd>lua vim.diagnostic.goto_prev()<cr>')

		-- Move to the next diagnostic
		bufmap('n', ']E', '<cmd>lua vim.diagnostic.goto_next()<cr>')
	end
})

vim.diagnostic.config{
	virtual_text = false
}


-- Tree sitting
require('nvim-treesitter.configs').setup { highlight = { enable = true } }


-- Autocomplete
local cmp = require 'cmp'
cmp.setup({
	preselect = cmp.PreselectMode.None,
  completion = {
    completeopt = "menu,menuone,noselect"
  },
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			vim.snippet.expand(args.body)   -- For native neovim snippets (Neovim v0.10+)
		end,
	},
	window = {
		documentation = cmp.config.window.bordered(),
	},
	mapping = {
		['<C-l>'] = cmp.mapping.confirm({ select = true }),
		['<Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			else
				fallback()
			end
		end, { 'i', 's' }),
		['<S-Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			else
				fallback()
			end
		end, { 'i', 's' }),
	},
	sources = cmp.config.sources({
		{ name = 'nvim_lsp',               max_item_count = 15 },
		{ name = 'nvim_lsp_signature_help' },
	})
})


-- Autoclose HTML tags
require('nvim-ts-autotag').setup()


-- Color scheme
require('onedark').setup({
	colors = {
		bg0 = "#050505",
	},
})


-- Status bar
require('lualine').setup {
	options = {
		theme = 'onedark',
		-- ... your lualine config
	},
	sections = {
		lualine_c = {
			{
				'filename',
				path = 1,
			}
		}
	}
}
require("bufferline").setup{}

require("dapui").setup()

-- local neotest = require("neotest")
-- neotest.setup({
--   adapters = {
--     require("rustaceanvim.neotest"),
--   },
--   -- output = {
--   --   open = { open_win = function() vim.cmd("split") end }
--  output = { enabled = false, open_on_run = false },
--  output_panel = { enabled = true, open = "split | resize 15"},
--  consumers = {
--  attach_or_output = function(client)
-- 	 local M = {}
-- 	 function M.open(opts)
-- 	   opts = opts or {}
-- 	   local pos = neotest.run.get_tree_from_args(opts)
-- 	   if pos and client:is_running(pos:data().id) then
-- 	     neotest.run.attach()
-- 	   else
-- 	     neotest.output_panel.open({ enter = true })
-- 	   end
-- 	 end

-- 	 return M
--  end,
--  },
-- })

-- vim.api.nvim_create_user_command("NTestOutput", function()
-- 	neotest.run.run()
-- 	local handle
-- 	handle, _ = vim.loop.spawn(
-- 		"sleep",
-- 		{ args = { "3s" }, stdio = nil },
-- 		vim.schedule_wrap(function(_)
-- 			handle:close()
-- 			neotest.attach_or_output.open()
-- 		end)
-- 	)
-- end, {}) -- }

-- require("dap").adapters.lldb = {
-- 	type = "executable",
-- 	command = "rust-lldb", -- adjust as needed
-- 	name = "rust-lldb",
-- }
-- Rustacean
-- vim.g.rustaceanvim = {
--   -- Plugin configuration
--   tools = {
-- 	  test_executer = "background"
--   },
-- }
  -- LSP configuration
--   -- server = {
--   --   on_attach = function(client, bufnr)
--   --     -- you can also put keymaps in here
--   --   end,
--   --   default_settings = {
--   --     -- rust-analyzer language server configuration
--   --     ['rust-analyzer'] = {
--   --     },
--   --   },
--   -- },
--   -- DAP configuration
  --dap = {
			-----@type DapExecutableConfig
		--adapter = {
				--type = 'executable',
				---- args = {''},
				--name = 'rust-lldb',
				--command = 'rust-lldb',
		--},
	--},
--}
		-- executable = {
		-- type = "lldb",
		-- command = "rust-lldb",
	-- }
-- 		-- args = {},
--   },
-- }
