--
-- ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
-- ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
-- ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
-- ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
-- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
-- ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
--
-- File: plugins/configs/diffview.lua
-- Description: Diffview configuration
return {
    enhanced_diff_hl = true,
    view = {
        default = { layout = "diff2_horizontal" },
        merge_tool = {
            layout = "diff3_mixed",
            disable_diagnostics = true,
        },
        file_history = { layout = "diff2_horizontal" },
    },
    file_panel = {
        win_config = { position = "left", width = 35 },
        listing_style = "tree",
    },
    file_history_panel = {
        log_options = {
            git = {
                single_file = { diff_merges = "combined" },
                multi_file = { diff_merges = "first-parent" },
            },
        },
    },
    default_args = {
        DiffviewOpen = { "--imply-local" },
        DiffviewFileHistory = { "--max-count=256" },
    },
    hooks = {
        diff_buf_read = function(bufnr)
            -- Improve readability for diff buffers
            vim.api.nvim_buf_call(bufnr, function()
                vim.opt_local.wrap = false
                vim.opt_local.list = false
                vim.opt_local.colorcolumn = ""
            end)
        end,
    },
}
