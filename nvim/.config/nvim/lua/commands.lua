vim.api.nvim_create_autocmd("CursorMoved", {
	group = vim.api.nvim_create_augroup("auto-hlsearch", { clear = true }),
	callback = function()
		if vim.v.hlsearch == 1 and vim.fn.searchcount().exact_match == 0 then
			vim.schedule(function()
				vim.cmd.nohlsearch()
			end)
		end
	end,
})

vim.api.nvim_create_user_command("FormatDisable", function(args)
	if args.bang then
		-- FormatDisable! will disable formatting just for this buffer
		vim.b.disable_autoformat = true
	else
		vim.g.disable_autoformat = true
	end
end, {
	desc = "Disable autoformat-on-save",
	bang = true,
})

vim.api.nvim_create_user_command("FormatEnable", function()
	vim.b.disable_autoformat = false
	vim.g.disable_autoformat = false
end, {
	desc = "Re-enable autoformat-on-save",
})

vim.api.nvim_create_user_command(
	"RustOpenCargo",
	require("ferris.methods.open_cargo_toml"),
	{ desc = "Open cargo file" }
)

vim.api.nvim_create_user_command(
	"RustOpenDocs",
	require("ferris.methods.open_cargo_toml"),
	{ desc = "Open documentation" }
)

vim.api.nvim_create_user_command(
	"RustReloadWorkspace",
	require("ferris.methods.reload_workspace"),
	{ desc = "Reload workspace" }
)

vim.api.nvim_create_user_command("RustExpandMacro", require("ferris.methods.expand_macro"), { desc = "Expand macro" })
