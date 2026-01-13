-- File: plugins/configs/nvim-tree.lua
-- Description: nvim-tree configuration
local function float_config()
    local columns = vim.o.columns
    local lines = vim.o.lines
    local width = math.min(60, math.floor(columns * 0.6))
    local height = math.min(28, math.floor(lines * 0.6))
    local row = math.floor((lines - height) / 2 - 1)
    local col = math.floor((columns - width) / 2)

    if row < 0 then row = 0 end
    if col < 0 then col = 0 end

    return {
        relative = "editor",
        border = "rounded",
        width = width,
        height = height,
        row = row,
        col = col,
    }
end

return {
    disable_netrw = true,
    hijack_netrw = true,
    sort_by = "case_sensitive",
    view = {
        float = {
            enable = true,
            open_win_config = float_config,
        },
    },
    renderer = {
        root_folder_label = false,
        add_trailing = false,
        highlight_git = false,
        indent_markers = { enable = false },
        icons = {
            show = {
                file = true,
                folder = true,
                folder_arrow = false,
                git = false,
            },
        },
    },
    update_focused_file = {
        enable = true,
        update_root = false,
    },
    git = {
        enable = true,
        ignore = false,
    },
    diagnostics = { enable = false },
    actions = {
        open_file = {
            quit_on_open = true,
            resize_window = true,
        },
    },
    filters = {
        dotfiles = false,
    },
}
