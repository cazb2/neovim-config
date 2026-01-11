--
-- ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
-- ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
-- ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
-- ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
-- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
-- ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
--
-- File: mappings.lua
-- Description: Key mapping configs
-- Author: Kien Nguyen-Tuan <kiennt2609@gmail.com>

-- <leader> is a space now
local map = vim.keymap.set
local function call_telescope_ext(extension, picker)
    return function()
        local ok, telescope = pcall(require, "telescope")
        if not ok then
            vim.notify("Telescope is not available", vim.log.levels.ERROR)
            return
        end
        local ext = telescope.extensions[extension]
        if not ext or type(ext[picker]) ~= "function" then
            vim.notify(("Telescope extension '%s' is not available"):format(extension), vim.log.levels.ERROR)
            return
        end
        ext[picker]()
    end
end

map("n", "<leader>q", ":qa!<CR>", {})
-- Fast saving with <leader> and s
map("n", "<leader>s", ":w<CR>", {})
-- Move around splits
map("n", "<leader>wh", "<C-w>h", { desc = "switch window left" })
map("n", "<leader>wl", "<C-w>j", { desc = "switch window right" })
map("n", "<leader>wk", "<C-w>k", { desc = "switch window up" })
map("n", "<leader>wj", "<C-w>l", { desc = "switch window down" })

-- Reload configuration without restart nvim
-- Or you don't want to use plenary.nvim, you can use this code
-- function _G.reload_config()
-- 	for name, _ in pairs(package.loaded) do
-- 		if name:match("^me") then
-- 			package.loaded[name] = nil
-- 		end
-- 	end

-- 	dofile(vim.env.MYVIMRC)
-- 	vim.notify("Nvim configuration reloaded!", vim.log.levels.INFO)
-- end
function _G.reload_config()
    local reload = require("plenary.reload").reload_module
    reload("me", false)

    dofile(vim.env.MYVIMRC)
    vim.notify("Nvim configuration reloaded!", vim.log.levels.INFO)
end

map("n", "rr", _G.reload_config, { desc = "Reload configuration without restart nvim" })

-- Telescope
local builtin = require "telescope.builtin"
map("n", "<leader>ff", builtin.find_files, { desc = "Open Telescope to find files" })
map("n", "<leader>fg", builtin.live_grep, { desc = "Open Telescope to do live grep" })
map("n", "<leader>fb", builtin.buffers, { desc = "Open Telescope to list buffers" })
map("n", "<leader>fh", builtin.help_tags, { desc = "Open Telescope to show help" })
map("n", "<leader>fo", builtin.oldfiles, { desc = "Open Telescope to list recent files" })
map("n", "<leader>cm", builtin.git_commits, { desc = "Open Telescope to list git commits" })
map("n", "<leader>gc", builtin.git_commits, { desc = "Open Telescope to list git commits" })
map("n", "<leader>gS", builtin.git_status, { desc = "Open Telescope git status" })
map("n", "<leader>gL", "<cmd>LazyGit<CR>", { desc = "Open LazyGit interface" })
map("n", "<leader>gd", "<cmd>DiffviewOpen<CR>", { desc = "Open Diffview" })
map("n", "<leader>gD", "<cmd>DiffviewClose<CR>", { desc = "Close Diffview" })
map("n", "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", { desc = "Diffview file history" })
map("n", "<leader>gH", "<cmd>DiffviewFileHistory<CR>", { desc = "Diffview project history" })
map("n", "<leader>gw", call_telescope_ext("git_worktree", "git_worktrees"), { desc = "Browse git worktrees" })
map("n", "<leader>gW", call_telescope_ext("git_worktree", "create_git_worktree"), { desc = "Create git worktree" })
-- NvimTree
map("n", "<leader>n", ":NvimTreeToggle<CR>", { desc = "Toggle NvimTree sidebar" }) -- open/close
map("n", "<leader>nr", ":NvimTreeRefresh<CR>", { desc = "Refresh NvimTree" }) -- refresh
map("n", "<leader>nf", ":NvimTreeFindFile<CR>", { desc = "Search file in NvimTree" }) -- search file

-- LSP
map(
    "n",
    "<leader>gm",
    function() require("conform").format { lsp_fallback = true } end,
    { desc = "General Format file" }
)

-- global lsp mappings
map("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "LSP Diagnostic loclist" })

-- Comment
map("n", "mm", "gcc", { desc = "Toggle comment", remap = true })
map("v", "mm", "gc", { desc = "Toggle comment", remap = true })

-- Terminal
map("n", "tt", "<cmd>ToggleTerm direction=float<CR>", { desc = "Toggle floating terminal" })
map("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
