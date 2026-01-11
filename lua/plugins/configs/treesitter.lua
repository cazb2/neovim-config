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
    refactor = {
        highlight_definitions = {
            enable = true,
        },
        highlight_current_scope = {
            enable = false,
        },
    },
}
