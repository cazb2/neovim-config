--
-- ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
-- ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
-- ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
-- ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
-- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
-- ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
--
-- File: plugins/configs/treesitter.lua
-- Description: nvim-treesitter configuration
-- Author: Kien Nguyen-Tuan <kiennt2609@gmail.com>

-- Load custom configurations
local exist, custom = pcall(require, "custom")
local ensure_installed = exist and type(custom) == "table" and custom.ensure_installed or {}
local ts_keymaps = require "keymaps.treesitter"
local parsers = {
    "go",
    "python",
    "dockerfile",
    "json",
    "yaml",
    "markdown",
    "html",
    "scss",
    "css",
    "vim",
    "lua",
}

if type(ensure_installed) == "table" then
    vim.list_extend(parsers, ensure_installed)
end

return {
    -- A list of parser names, or "all"
    ensure_installed = parsers,

    highlight = {
        enable = true,
        use_languagetree = true,
    },
    incremental_selection = {
        enable = true,
        keymaps = ts_keymaps.incremental_selection,
    },
    indent = {
        enable = true,
    },
    autotag = {
        enable = true,
    },
    context_commentstring = {
        enable = true,
        enable_autocmd = false,
    },
    textobjects = {
        select = {
            enable = true,
            lookahead = true,
            keymaps = ts_keymaps.select,
        },
        move = {
            enable = true,
            set_jumps = true,
            goto_next_start = ts_keymaps.move.goto_next_start,
            goto_next_end = ts_keymaps.move.goto_next_end,
            goto_previous_start = ts_keymaps.move.goto_previous_start,
            goto_previous_end = ts_keymaps.move.goto_previous_end,
        },
        swap = {
            enable = true,
            swap_next = ts_keymaps.swap.swap_next,
            swap_previous = ts_keymaps.swap.swap_previous,
        },
    },
    refactor = {
        highlight_definitions = {
            enable = true,
        },
        highlight_current_scope = {
            enable = false,
        },
    },
}
