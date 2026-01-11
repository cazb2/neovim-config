-- File: plugins/configs/aerial.lua
-- Description: aerial configuration
return {
    backends = { "lsp", "treesitter" },
    layout = {
        min_width = 28,
        default_direction = "right",
    },
    attach_mode = "global",
    show_guides = true,
}
