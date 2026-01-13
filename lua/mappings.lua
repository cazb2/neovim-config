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
local session = require "utils.session"

map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

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

local function with_gitsigns(callback)
    return function()
        local ok, gitsigns = pcall(require, "gitsigns")
        if not ok then
            vim.notify("gitsigns is not available", vim.log.levels.ERROR)
            return
        end
        callback(gitsigns)
    end
end

local function with_lsp_capability(capability, label, callback, fallback)
    local function echo_warn(msg)
        vim.api.nvim_echo({ { msg, "WarningMsg" } }, true, {})
    end

    local function get_clients(bufnr)
        if type(vim.lsp.get_clients) == "function" then
            return vim.lsp.get_clients { bufnr = bufnr }
        end
        return vim.lsp.get_active_clients { bufnr = bufnr }
    end

    return function()
        local bufnr = vim.api.nvim_get_current_buf()
        local clients = get_clients(bufnr)
        if not clients or vim.tbl_isempty(clients) then
            echo_warn("No LSP attached to this buffer")
            return
        end
        for _, client in ipairs(clients) do
            if client.server_capabilities and client.server_capabilities[capability] then
                callback()
                return
            end
        end
        echo_warn((label or "LSP action") .. " not supported by server")
        if fallback then
            fallback()
        end
    end
end

map("n", "<leader>q", ":qa!<CR>", {})
-- Fast saving with <leader> and s
map("n", "<leader>sw", ":w<CR>", { desc = "Save file" })
map("n", "<leader>sW", ":wa<CR>", { desc = "Save all files" })
map("n", "<leader>ss", function() session.save() end, { desc = "Save session" })
map("n", "<leader>sl", function() session.load() end, { desc = "Load session" })
map("n", "<leader>sd", function() session.delete() end, { desc = "Delete session" })
map("n", "<leader>sL", function() session.list() end, { desc = "List sessions" })
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file tree" })
map("n", "<leader>?", function() require("keymaps.cheatsheet").toggle() end, { desc = "Show key hints" })
-- Move around splits
map("n", "<leader>wh", "<C-w>h", { desc = "switch window left" })
map("n", "<leader>wj", "<C-w>j", { desc = "switch window down" })
map("n", "<leader>wk", "<C-w>k", { desc = "switch window up" })
map("n", "<leader>wl", "<C-w>l", { desc = "switch window right" })
map("n", "<leader>ww", "<C-w>w", { desc = "cycle windows" })
map("n", "<leader>wW", "<C-w>W", { desc = "cycle windows reverse" })
map("n", "<leader>wp", "<C-w>p", { desc = "previous window" })
map("n", "<leader>wt", "<C-w>t", { desc = "top-left window" })
map("n", "<leader>wb", "<C-w>b", { desc = "bottom-right window" })
map("n", "<leader>wc", "<C-w>c", { desc = "close window" })
map("n", "<leader>wq", "<C-w>q", { desc = "quit window" })
map("n", "<leader>wo", "<C-w>o", { desc = "close other windows" })
map("n", "<leader>ws", "<C-w>s", { desc = "split" })
map("n", "<leader>wv", "<C-w>v", { desc = "vsplit" })
map("n", "<leader>w=", "<C-w>=", { desc = "balance windows" })
map("n", "<leader>w_", "<C-w>_", { desc = "max height" })
map("n", "<leader>w|", "<C-w>|", { desc = "max width" })
map("n", "<leader>w+", "<C-w>+", { desc = "increase height" })
map("n", "<leader>w-", "<C-w>-", { desc = "decrease height" })
map("n", "<leader>w>", "<C-w>>", { desc = "increase width" })
map("n", "<leader>w<", "<C-w><", { desc = "decrease width" })
map("n", "<leader>wr", "<C-w>r", { desc = "rotate down" })
map("n", "<leader>wR", "<C-w>R", { desc = "rotate up" })
map("n", "<leader>wx", "<C-w>x", { desc = "swap windows" })
map("n", "<leader>wH", "<C-w>H", { desc = "move window far left" })
map("n", "<leader>wJ", "<C-w>J", { desc = "move window far down" })
map("n", "<leader>wK", "<C-w>K", { desc = "move window far up" })
map("n", "<leader>wL", "<C-w>L", { desc = "move window far right" })
map("n", "<leader>wT", "<C-w>T", { desc = "move window to new tab" })

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
local function search_shell_history()
  local histfile = vim.env.HISTFILE or vim.fn.expand "~/.zsh_history"
  if vim.fn.filereadable(histfile) == 0 then
    vim.notify("Shell history file not found: " .. histfile, vim.log.levels.WARN)
    return
  end
  builtin.live_grep {
    prompt_title = "Zsh History",
    search_dirs = { histfile },
    additional_args = function() return { "--no-ignore", "--hidden" } end,
  }
end
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
map("n", "<leader>fH", search_shell_history, { desc = "Search shell history" })
map("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bp", ":bprev<CR>", { desc = "Previous buffer" })
map("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })
map("n", "<leader>gg", "<cmd>Git<CR>", { desc = "Git status (Fugitive)" })
map("n", "<leader>gA", "<cmd>Git add %<CR>", { desc = "Git add file" })
map("n", "<leader>ga", "<cmd>Git add -A<CR>", { desc = "Git add all" })
map("n", "<leader>gC", "<cmd>Git commit<CR>", { desc = "Git commit" })
map("n", "<leader>gM", "<cmd>Git commit --amend<CR>", { desc = "Git commit amend" })
map("n", "<leader>gP", "<cmd>Git push<CR>", { desc = "Git push" })
map("n", "<leader>gL", "<cmd>Git pull<CR>", { desc = "Git pull" })
map("n", "<leader>gl", "<cmd>Git log<CR>", { desc = "Git log" })
map("n", "<leader>gF", "<cmd>Git fetch<CR>", { desc = "Git fetch" })
map("n", "<leader>gd", "<cmd>Gdiffsplit<CR>", { desc = "Git diff (index)" })
map("n", "<leader>gD", "<cmd>Gdiffsplit HEAD<CR>", { desc = "Git diff (HEAD)" })
map("n", "<leader>gv", "<cmd>Gvdiffsplit<CR>", { desc = "Git vdiff" })
map("n", "<leader>gW", "<cmd>Gwrite<CR>", { desc = "Git stage buffer (Gwrite)" })
map("n", "<leader>gR", "<cmd>Gread<CR>", { desc = "Git reset buffer (Gread)" })
map("n", "<leader>gb", with_gitsigns(function(gitsigns) gitsigns.blame_line { full = true } end),
    { desc = "Git blame line" })
map("n", "<leader>gB", with_gitsigns(function(gitsigns) gitsigns.toggle_current_line_blame() end),
    { desc = "Toggle git blame" })
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
map("n", "<leader>lc", with_lsp_capability(
    "callHierarchyProvider",
    "Incoming calls",
    builtin.lsp_incoming_calls,
    builtin.lsp_references
), { desc = "LSP incoming calls" })
map("n", "<leader>lC", with_lsp_capability(
    "callHierarchyProvider",
    "Outgoing calls",
    builtin.lsp_outgoing_calls,
    builtin.lsp_references
), { desc = "LSP outgoing calls" })
map("n", "<leader>ld", builtin.lsp_definitions, { desc = "LSP definitions" })
map("n", "<leader>lD", builtin.lsp_type_definitions, { desc = "LSP type definitions" })
map("n", "<leader>li", builtin.lsp_implementations, { desc = "LSP implementations" })
map("n", "<leader>lr", builtin.lsp_references, { desc = "LSP references" })
map("n", "<leader>ls", builtin.lsp_document_symbols, { desc = "LSP document symbols" })
map("n", "<leader>lS", builtin.lsp_workspace_symbols, { desc = "LSP workspace symbols" })
map("n", "<leader>lo", "<cmd>AerialToggle<CR>", { desc = "LSP outline" })
map("n", "<leader>la", vim.lsp.buf.code_action, { desc = "LSP code action" })
map("n", "<leader>lR", vim.lsp.buf.rename, { desc = "LSP rename" })
map("n", "<leader>lh", vim.lsp.buf.hover, { desc = "LSP hover" })
map("n", "<leader>lH", vim.lsp.buf.signature_help, { desc = "LSP signature help" })
map("n", "<leader>le", vim.diagnostic.open_float, { desc = "LSP line diagnostics" })
map("n", "<leader>lE", "<cmd>Trouble diagnostics toggle<CR>", { desc = "LSP diagnostics list" })
map("n", "<leader>ln", vim.diagnostic.goto_next, { desc = "LSP next diagnostic" })
map("n", "<leader>lp", vim.diagnostic.goto_prev, { desc = "LSP prev diagnostic" })

-- global lsp mappings
map("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "LSP Diagnostic loclist" })
map("n", "<leader>lq", function()
    vim.diagnostic.setqflist()
    vim.cmd "copen"
end, { desc = "LSP diagnostics quickfix" })
map("n", "<leader>ll", function()
    vim.diagnostic.setloclist()
    vim.cmd "lopen"
end, { desc = "LSP diagnostics loclist" })

-- Comment
map("n", "mm", "gcc", { desc = "Toggle comment", remap = true })
map("v", "mm", "gc", { desc = "Toggle comment", remap = true })

-- Terminal
map("n", "tt", "<cmd>ToggleTerm direction=float<CR>", { desc = "Toggle floating terminal" })

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
            { "<leader>w", group = "window" },
            { "<leader>s", group = "session" },
            { "<leader>b", group = "buffer" },
        })

        require("keymaps.treesitter").register_which_key(wk)
    end,
})
