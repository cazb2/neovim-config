--
-- ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
-- ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
-- ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
-- ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
-- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
-- ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
--
-- File: autocmds.lua
-- Description: Autocommand functions
-- Author: Kien Nguyen-Tuan <kiennt2609@gmail.com>
-- Define autocommands with Lua APIs
-- See: h:api-autocmd, h:augroup
local autocmd = vim.api.nvim_create_autocmd -- Create autocommand
local session = require "utils.session"

-- General settings

-- Highlight on yank
autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank {
            higroup = "IncSearch",
            timeout = "1000",
        }
    end,
})

-- Remove whitespace on save
autocmd("BufWritePre", {
    pattern = "",
    command = ":%s/\\s\\+$//e",
})

-- Don"t auto commenting new lines
autocmd("BufEnter", {
    pattern = "",
    command = "set fo-=c fo-=r fo-=o",
})

autocmd("Filetype", {
    pattern = { "xml", "html", "xhtml", "css", "scss", "javascript", "typescript", "yaml", "lua" },
    command = "setlocal shiftwidth=2 tabstop=2",
})

-- Set colorcolumn
autocmd("Filetype", {
    pattern = { "python", "rst", "c", "cpp" },
    command = "set colorcolumn=80",
})

autocmd("Filetype", {
    pattern = { "gitcommit", "markdown", "text" },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
    end,
})

autocmd("Filetype", {
    pattern = { "dap-repl", "dapui_console" },
    callback = function(args)
        local buf = args.buf
        vim.bo[buf].buflisted = true
        vim.bo[buf].bufhidden = "hide"
    end,
})

autocmd("TermOpen", {
    callback = function(args)
        vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { buffer = args.buf, desc = "Exit terminal mode" })
    end,
})

autocmd("VimLeavePre", {
    callback = function()
        pcall(session.save)
    end,
})

autocmd("VimEnter", {
    callback = function()
        local ok_session, session_mod = pcall(require, "utils.session")
        if not ok_session then return end
        pcall(session_mod.load)
    end,
})

autocmd({ "ColorScheme" }, {
    callback = function()
        vim.cmd [[hi Lualine_c_normal guibg=none]]
        vim.cmd [[hi StatusLine guibg=none]]
        vim.cmd [[hi StatusLineNC guibg=none]]
    end,
})
