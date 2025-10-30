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
		if vim.b[bufnr].disable_autoformat then
			return false
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
	rust_analyzer = {
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
	},
}
for server_name, opts in pairs(servers) do
	vim.lsp.config(server_name, opts)
end

-- You can add other tools here that you want Mason to install
-- for you, so that they are available from within Neovim.
local ensure_installed = vim.tbl_keys(servers or {})
vim.list_extend(ensure_installed, {
	"stylua", -- Used to format Lua code
})
require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
require("mason-lspconfig").setup()

-- local function log(msg)
-- 	local fp = io.open(vim.fn.stdpath("cache") .. "/debug.log", "a")
-- 	fp:write(msg .. "\n")
-- 	fp:close()
-- end

_G.blink_config = {
	completion = {
		-- keyword = {
		-- 	range = "full",
		-- },
		list = {
			selection = {
				preselect = false,
				auto_insert = true,
			},
		},
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 800,
		},
		menu = {
			draw = {
				columns = { { "label", gap = 1 }, { "kind" } },
			},
		},
		trigger = {
			show_on_backspace = true,
		},
	},
	signature = {
		enabled = true,
		window = {
			show_documentation = false,
		},
	},
	fuzzy = {
		sorts = {
			"exact",
			"score",
			"sort_text",
		},
	},
	sources = {
		transform_items = function(ctx, items)
			local cursor_col = ctx.cursor[2]

			for _, item in ipairs(items) do
				if item.textEdit and item.textEdit.insert then
					-- Both start and end are inclusive indexes
					local s = ctx.bounds.start_col
					local e = s + ctx.bounds.length - 1
					local typed_fragment = ctx.line:sub(s, e)

					-- Plus 2 for lua 1 based indexing, and then for getting the position after the letter the
					-- cursor is technically on (I think that's why.. but determined this by testing prints)
					local cursor_idx = cursor_col + 2 - s
					local word_after_cursor = typed_fragment:sub(cursor_idx)

					-- If the text after the prefix match matches the insertion item, replace it, otherwise insert
					-- before the item.
					if item.textEdit.newText:match(word_after_cursor) then
						local start_replace = item.textEdit.replace.start.character
						item.textEdit.replace["end"].character = start_replace + #typed_fragment
						item.textEdit.range = item.textEdit.replace
					end
				end
			end
			return items
		end,
	},
}

-- -@type rustaceanvim.Opts
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
