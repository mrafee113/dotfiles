---- backup/persistance settings
vim.opt.undodir = home .. "/.local/state/nvim/undo/"
vim.opt.directory = home .. "/.local/state/nvim/swap/"
vim.opt.backupdir = home .. "/.local/state/nvim/backup/"
-- enable vim to store undo(s)/redo(s) permenantly
vim.opt.undofile = true
vim.opt.backup = true
vim.opt.writebackup = true
vim.opt.swapfile = false

-- Decrease update time
vim.opt.updatetime = 250

-- reload all open buffers
-- vim.api.nvim_set_keymap("n", "<leader>Ra", ":tabdo exec \"windo e!\"<CR>", { noremap = true, silent = true })

-- restore cursor
-- https://github.com/neovim/neovim/issues/16339#issuecomment-1457394370
vim.api.nvim_create_autocmd("BufRead", {
	callback = function(opts)
		vim.api.nvim_create_autocmd("BufWinEnter", {
			once = true,
			buffer = opts.buf,
			callback = function()
				local ft = vim.bo[opts.buf].filetype
				local last_known_line = vim.api.nvim_buf_get_mark(opts.buf, '"')[1]
				if
					not (ft:match("commit") and ft:match("rebase"))
					and last_known_line > 1
					and last_known_line <= vim.api.nvim_buf_line_count(opts.buf)
				then
					vim.api.nvim_feedkeys([[g`"]], "nx", false)
				end
			end,
		})
	end,
})
