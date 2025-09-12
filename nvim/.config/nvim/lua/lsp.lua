-- NB: conform setup should happen after LSP settings are applied so that
-- lsp fallbacks work the way you'd want/expect.
require("conform").setup({
	notify_on_error = false,
	format_on_save = function(bufnr)
		-- Disable "format_on_save lsp_fallback" for languages that don't
		-- have a well standardized coding style. You can add additional
		-- languages here or re-enable it for the disabled ones.
		local disable_filetypes = { c = true, cpp = true }
		local lsp_format_opt
		if disable_filetypes[vim.bo[bufnr].filetype] then
			lsp_format_opt = "never"
		else
			lsp_format_opt = "fallback"
		end
		return {
			timeout_ms = 500,
			lsp_format = lsp_format_opt,
		}
	end,
	formatters_by_ft = {
		lua = { "stylua" },
		rust = { "cargo", lsp_format = "first" },
		proto = { "buf" },
		toml = { "taplo" },
		-- You can use 'stop_after_first' to run the first available formatter from the list
		javascript = { "prettierd", "prettier", stop_after_first = true },
	},
	format_after_save = function(bufnr)
		if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
			return
		end
		return { lsp_format = "fallback" }
	end,
})

-- Hide all semantic highlights from lsp
for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
	vim.api.nvim_set_hl(0, group, {})
end

require("conform").formatters.taplo = {
	command = "taplo",
	inherit = false,
	args = 'format --option indent_string="    " -',
}

-- require("conform").formatters.rustfmt = {
-- 	command = "rustup",
-- 	args = "run nightly rustfmt",
-- }

require("mason").setup()

local servers = {
	lua_ls = {
		cmd = { ... },
		filetypes = { ... },
		capabilities = {},
		settings = {
			Lua = {
				completion = {
					callSnippet = "Replace",
				},
				-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
				-- diagnostics = { disable = { 'missing-fields' } },
			},
		},
	},
}
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

-- You can add other tools here that you want Mason to install
-- for you, so that they are available from within Neovim.
local ensure_installed = vim.tbl_keys(servers or {})
vim.list_extend(ensure_installed, {
	"stylua", -- Used to format Lua code
})
require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

require("mason-lspconfig").setup({
	handlers = {
		function(server_name)
			local server = servers[server_name] or {}
			-- This handles overriding only values explicitly passed
			-- by the server configuration above. Useful when disabling
			-- certain features of an LSP (for example, turning off formatting for ts_ls)
			server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
			require("lspconfig")[server_name].setup(server)
		end,
	},
})

local cmp = require("cmp")
cmp.setup({
	preselect = cmp.PreselectMode.None,
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	-- window = {
	-- 	documentation = cmp.config.window.bordered(),
	-- },
	performance = { max_view_entries = 15 },
	completion = { completeopt = "menu,menuone,noselect" },
	sources = {
		{
			name = "lazydev",
			-- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
			group_index = 0,
		},
		{ name = "nvim_lsp" },
		{ name = "nvim_lsp_signature_help" },
		{ name = "luasnip" },
		{ name = "path" },
	},
})

require("luasnip").config.setup({})

require("lspconfig").rust_analyzer.setup({
	-- on_attach = on_attach,
	settings = {
		["rust-analyzer"] = {
			imports = {
				granularity = {
					group = "module",
				},
				prefix = "self",
			},
			cargo = {
				buildScripts = {
					enable = true,
				},
				targetDir = true,
				features = "all",
			},
			rustfmt = {
				extraArgs = { "+nightly" },
			},
			procMacro = {
				enable = true,
			},
		},
	},
})

---@type rustaceanvim.Opts
-- vim.g.rustaceanvim = {
-- 	---@type rustaceanvim.lsp.ClientOpts
-- 	server = {
-- 		settings = {
-- 			-- rust-analyzer language server configuration
-- 			["rust-analyzer"] = {
-- 				imports = {
-- 					granularity = {
-- 						group = "module",
-- 					},
-- 					prefix = "self",
-- 				},
-- 				-- files = {},
-- 				cargo = {
-- 					buildScripts = {
-- 						enable = true,
-- 					},
-- 					targetDir = true,
-- 					features = "all",
-- 				},
-- 				rustfmt = {
-- 					extraArgs = { "+nightly" },
-- 				},
-- 				procMacro = {
-- 					enable = true,
-- 				},
-- 			},
-- 		},
-- 	},
-- }
