-- File: plugins/configs/toggleterm.lua
-- Description: toggleterm configuration
return {
    size = function(term)
        if term.direction == "horizontal" then
            return math.floor(vim.o.lines * 0.3)
        end
        if term.direction == "vertical" then
            return math.floor(vim.o.columns * 0.4)
        end
    end,
    shade_terminals = true,
    shading_factor = 2,
    start_in_insert = true,
    persist_size = true,
    direction = "float",
    float_opts = {
        border = "single",
        winblend = 0,
    },
}
