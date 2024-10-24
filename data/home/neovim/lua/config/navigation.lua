-- Allows moving to previous/next line at the beginning/end of a line using left/right arrow keys
-- https://superuser.com/questions/35389/in-vim-how-do-i-make-the-left-and-right-arrow-keys-change-line
vim.opt.whichwrap:append("<,>,[,],h,l")

---- move around in insert mode
-- hjkl
vim.api.nvim_set_keymap("i", "<A-h>", "<Left>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<A-j>", "<Down>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<A-k>", "<Up>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<A-l>", "<Right>", { noremap = true, silent = true })

-- delete
vim.api.nvim_set_keymap("i", "<A-d>", "<C-h>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<A-S-d>", "<Del>", { noremap = true, silent = true })

-- Move to the beginning and end of the line
vim.api.nvim_set_keymap("i", "<A-0>", "<C-o>g0", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<A-S-$>", "<C-o>g$", { noremap = true, silent = true })

-- Move one word left and right
vim.api.nvim_set_keymap("i", "<A-b>", "<C-left>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<A-S-b>", "<C-o>B", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<A-w>", "<C-right>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<A-S-w>", "<C-o>W", { noremap = true, silent = true })

-- new lines
vim.api.nvim_set_keymap("i", "<A-o>", "<C-o>o", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<A-S-o>", "<C-o>O", { noremap = true, silent = true })

-- Move through sentences
-- this one didn't work.
vim.api.nvim_set_keymap("i", "<A-S-(>", "<C-o>(", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<A-S-)>", "<C-o>)", { noremap = true, silent = true })
--
-- Move through paragraphs
vim.api.nvim_set_keymap("i", "<A-S-{>", "<C-o>{", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<A-S-}>", "<C-o>}", { noremap = true, silent = true })

-- undo/redo
vim.api.nvim_set_keymap("i", "<A-u>", "<C-o>u", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-A-r>", "<C-o><C-r>", { noremap = true, silent = true })

-- paste
vim.api.nvim_set_keymap("i", "<A-p>", "<C-o>p", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<A-S-p>", "<C-o>P", { noremap = true, silent = true })
----

-- TIP: Disable arrow keys
vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')
vim.keymap.set("i", "<left>", '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set("i", "<right>", '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set("i", "<up>", '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set("i", "<down>", '<cmd>echo "Use j to move!!"<CR>')

---- better scrolling
vim.api.nvim_set_keymap("n", "<C-j>", "<C-d>zz", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-k>", "<C-u>zz", { noremap = true, silent = true })

---- consistent menu navigation
vim.api.nvim_set_keymap("i", "<C-j>", "<C-n>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-k>", "<C-p>", { noremap = true, silent = true })

-- map next-previous jumps
-- vim.api.nvim_set_keymap("n", "<leader>m", "<C-o>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>.", "<C-i>", { noremap = true, silent = true })

-- Keep search matches in the middle of the window.
-- vim.api.nvim_set_keymap("n", "n", "nzzzv", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "N", "Nzzzv", { noremap = true, silent = true })
