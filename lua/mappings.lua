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

local function call_trouble(mode)
    return function()
        local ok, trouble = pcall(require, "trouble")
        if not ok then
            vim.notify("Trouble is not available", vim.log.levels.ERROR)
            return
        end
        trouble.toggle(mode)
    end
end

local function with_dap(callback)
    return function()
        local ok, dap = pcall(require, "dap")
        if not ok then
            vim.notify("nvim-dap is not available", vim.log.levels.ERROR)
            return
        end
        callback(dap)
    end
end

local function with_dapui(callback)
    return function()
        local ok, dapui = pcall(require, "dapui")
        if not ok then
            vim.notify("nvim-dap-ui is not available", vim.log.levels.ERROR)
            return
        end
        callback(dapui)
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
local function prompt_search_dir()
  local default_dir = vim.fn.expand("%:p:h")
  if default_dir == "" then
    default_dir = vim.fn.getcwd()
  end
  local dir = vim.fn.input("Search dir: ", default_dir, "dir")
  if dir == "" then
    return nil
  end
  return dir
end

local function telescope_in_dir(builtin_fn, opts)
  return function()
    local dir = prompt_search_dir()
    if not dir then
      return
    end
    builtin_fn(vim.tbl_extend("force", { cwd = dir }, opts or {}))
  end
end

map("n", "<leader>ff", builtin.find_files, { desc = "Open Telescope to find files" })
map("n", "<leader>fg", builtin.live_grep, { desc = "Open Telescope to do live grep" })
map("n", "<leader>fF", telescope_in_dir(builtin.find_files), { desc = "Find files in directory" })
map("n", "<leader>fG", telescope_in_dir(builtin.live_grep), { desc = "Live grep in directory" })
map("n", "<leader>fb", builtin.buffers, { desc = "Open Telescope to list buffers" })
map("n", "<leader>fh", builtin.help_tags, { desc = "Open Telescope to show help" })
map("n", "<leader>fo", builtin.oldfiles, { desc = "Open Telescope to list recent files" })
map("n", "<leader>gc", builtin.git_commits, { desc = "Open Telescope to list git commits" })
map("n", "<leader>gS", builtin.git_status, { desc = "Open Telescope git status" })
map("n", "<leader>gL", "<cmd>LazyGit<CR>", { desc = "Open LazyGit interface" })
map("n", "<leader>gd", "<cmd>DiffviewOpen<CR>", { desc = "Open Diffview" })
map("n", "<leader>gD", "<cmd>DiffviewClose<CR>", { desc = "Close Diffview" })
map("n", "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", { desc = "Diffview file history" })
map("n", "<leader>gH", "<cmd>DiffviewFileHistory<CR>", { desc = "Diffview project history" })
map("n", "<leader>gw", call_telescope_ext("git_worktree", "git_worktrees"), { desc = "Browse git worktrees" })
map("n", "<leader>gW", call_telescope_ext("git_worktree", "create_git_worktree"), { desc = "Create git worktree" })
-- LSP
map("n", "gd", builtin.lsp_definitions, { desc = "LSP definitions" })
map("n", "gD", vim.lsp.buf.declaration, { desc = "LSP declaration" })
map("n", "gI", builtin.lsp_implementations, { desc = "LSP implementations" })
map("n", "gr", builtin.lsp_references, { desc = "LSP references" })
map(
  "n",
  "<leader>gm",
  function() require("conform").format { lsp_fallback = true } end,
  { desc = "General Format file" }
)
map("n", "<leader>lc", builtin.lsp_incoming_calls, { desc = "LSP incoming calls" })
map("n", "<leader>lC", builtin.lsp_outgoing_calls, { desc = "LSP outgoing calls" })
map("n", "<leader>ld", builtin.lsp_definitions, { desc = "LSP definitions" })
map("n", "<leader>lD", builtin.lsp_type_definitions, { desc = "LSP type definitions" })
map("n", "<leader>li", builtin.lsp_implementations, { desc = "LSP implementations" })
map("n", "<leader>lr", builtin.lsp_references, { desc = "LSP references" })
map("n", "<leader>ls", builtin.lsp_document_symbols, { desc = "LSP document symbols" })
map("n", "<leader>lS", builtin.lsp_workspace_symbols, { desc = "LSP workspace symbols" })
map("n", "<leader>lo", "<cmd>AerialToggle<CR>", { desc = "LSP outline" })

-- global lsp mappings
map("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "LSP Diagnostic loclist" })
map("n", "<leader>xx", call_trouble("diagnostics"), { desc = "Trouble diagnostics" })
map("n", "<leader>xr", call_trouble("lsp_references"), { desc = "Trouble references" })
map("n", "<leader>xq", call_trouble("quickfix"), { desc = "Trouble quickfix" })
map("n", "<leader>xl", call_trouble("loclist"), { desc = "Trouble loclist" })

-- Comment
map("n", "mm", "gcc", { desc = "Toggle comment", remap = true })
map("v", "mm", "gc", { desc = "Toggle comment", remap = true })

-- Terminal
map("n", "tt", "<cmd>ToggleTerm direction=float<CR>", { desc = "Toggle floating terminal" })
map("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

-- Debugging
map("n", "<leader>dc", with_dap(function(dap) dap.continue() end), { desc = "Debug continue" })
map("n", "<leader>dn", with_dap(function(dap) dap.step_over() end), { desc = "Debug step over" })
map("n", "<leader>di", with_dap(function(dap) dap.step_into() end), { desc = "Debug step into" })
map("n", "<leader>do", with_dap(function(dap) dap.step_out() end), { desc = "Debug step out" })
map("n", "<leader>db", with_dap(function(dap) dap.toggle_breakpoint() end), { desc = "Debug toggle breakpoint" })
map(
    "n",
    "<leader>dB",
    with_dap(function(dap)
        local condition = vim.fn.input("Breakpoint condition: ")
        if condition ~= "" then
            dap.set_breakpoint(condition)
        else
            dap.toggle_breakpoint()
        end
    end),
    { desc = "Debug conditional breakpoint" }
)
map(
    "n",
    "<leader>dr",
    with_dap(function(dap) dap.repl.open({}, "botright split") end),
    { desc = "Debug REPL" }
)
map("n", "<leader>dl", with_dap(function(dap) dap.run_last() end), { desc = "Debug run last" })
map("n", "<leader>dt", with_dap(function(dap) dap.terminate() end), { desc = "Debug terminate" })
map("n", "<leader>du", with_dapui(function(dapui) dapui.toggle() end), { desc = "Debug UI toggle" })
map("n", "<F5>", with_dap(function(dap) dap.continue() end), { desc = "Debug continue" })
map("n", "<F10>", with_dap(function(dap) dap.step_over() end), { desc = "Debug step over" })
map("n", "<F11>", with_dap(function(dap) dap.step_into() end), { desc = "Debug step into" })
map("n", "<F12>", with_dap(function(dap) dap.step_out() end), { desc = "Debug step out" })
map("n", "<F9>", with_dap(function(dap) dap.toggle_breakpoint() end), { desc = "Debug toggle breakpoint" })
map("n", "<S-F5>", with_dap(function(dap) dap.terminate() end), { desc = "Debug terminate" })

vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
        local ok, wk = pcall(require, "which-key")
        if not ok then return end

        wk.add({
            { "<leader>d", group = "debug" },
            { "a", group = "around", mode = { "o", "x" } },
            { "aa", desc = "parameter", mode = { "o", "x" } },
            { "ac", desc = "class", mode = { "o", "x" } },
            { "af", desc = "function", mode = { "o", "x" } },
            { "i", group = "inside", mode = { "o", "x" } },
            { "ia", desc = "parameter", mode = { "o", "x" } },
            { "ic", desc = "class", mode = { "o", "x" } },
            { "if", desc = "function", mode = { "o", "x" } },
            { "[m", desc = "prev function start", mode = "n" },
            { "[M", desc = "prev function end", mode = "n" },
            { "[c", desc = "prev class start", mode = "n" },
            { "[C", desc = "prev class end", mode = "n" },
            { "]m", desc = "next function start", mode = "n" },
            { "]M", desc = "next function end", mode = "n" },
            { "]c", desc = "next class start", mode = "n" },
            { "]C", desc = "next class end", mode = "n" },
        })
    end,
})
