local M = {}

M.select = {
    ["af"] = "@function.outer",
    ["if"] = "@function.inner",
    ["ac"] = "@class.outer",
    ["ic"] = "@class.inner",
    ["aa"] = "@parameter.outer",
    ["ia"] = "@parameter.inner",
}

M.incremental_selection = {
    init_selection = "gnn",
    node_incremental = "grn",
    scope_incremental = "grc",
    node_decremental = "grm",
}

M.move = {
    goto_next_start = {
        ["]m"] = "@function.outer",
        ["]c"] = "@class.outer",
    },
    goto_next_end = {
        ["]M"] = "@function.outer",
        ["]C"] = "@class.outer",
    },
    goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[c"] = "@class.outer",
    },
    goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[C"] = "@class.outer",
    },
}

M.swap = {
    swap_next = {
        ["]a"] = "@parameter.inner",
        ["]f"] = "@function.outer",
    },
    swap_previous = {
        ["[a"] = "@parameter.inner",
        ["[f"] = "@function.outer",
    },
}

M.register_which_key = function(wk)
    if not wk then
        local ok, which_key = pcall(require, "which-key")
        if not ok then
            return
        end
        wk = which_key
    end

        wk.add({
            { "a", group = "around", mode = { "o", "x" } },
            { "aa", desc = "parameter", mode = { "o", "x" } },
            { "ac", desc = "class", mode = { "o", "x" } },
            { "af", desc = "function", mode = { "o", "x" } },
            { "i", group = "inside", mode = { "o", "x" } },
            { "ia", desc = "parameter", mode = { "o", "x" } },
            { "ic", desc = "class", mode = { "o", "x" } },
            { "if", desc = "function", mode = { "o", "x" } },
            { "gnn", desc = "TS init selection", mode = "n" },
            { "grn", desc = "TS expand node", mode = "n" },
            { "grc", desc = "TS expand scope", mode = "n" },
            { "grm", desc = "TS shrink node", mode = "n" },
            { "]a", desc = "swap next param", mode = "n" },
            { "[a", desc = "swap prev param", mode = "n" },
            { "]f", desc = "swap next function", mode = "n" },
            { "[f", desc = "swap prev function", mode = "n" },
            { "[m", desc = "prev function start", mode = "n" },
            { "[M", desc = "prev function end", mode = "n" },
            { "[c", desc = "prev class start", mode = "n" },
            { "[C", desc = "prev class end", mode = "n" },
            { "]m", desc = "next function start", mode = "n" },
            { "]M", desc = "next function end", mode = "n" },
            { "]c", desc = "next class start", mode = "n" },
            { "]C", desc = "next class end", mode = "n" },
        })
    end

return M
