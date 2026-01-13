local M = {}

local state = { win = nil, buf = nil }

local sections = {
    {
        title = "Basics",
        icon = "󰆾",
        items = {
            { "h j k l", "move cursor" },
            { "w b e", "move by word" },
            { "gg / G", "top / bottom of file" },
            { "0 ^ $", "line start / first non-blank / end" },
            { "%", "jump to matching bracket" },
            { "f{c} / t{c}", "find / to char" },
            { "F{c} / T{c}", "find / to char (back)" },
            { "; / ,", "repeat find / reverse" },
            { "H M L", "top / middle / bottom of screen" },
            { "g_ / g0", "last / first non-blank" },
            { "{ / }", "prev / next paragraph" },
            { "<C-d> / <C-u>", "half-page down / up" },
        },
    },
    {
        title = "Search",
        icon = "",
        items = {
            { "/ ? ", "search forward / backward" },
            { "n / N", "next / previous match" },
            { "* / #", "search word under cursor" },
            { ":%s/old/new/g", "replace in file" },
        },
    },
    {
        title = "Edit",
        icon = "",
        items = {
            { "dd / yy", "delete / yank line" },
            { "p / P", "paste after / before" },
            { "u / <C-r>", "undo / redo" },
            { "ciw / daw", "change / delete inner word" },
            { ".", "repeat last change" },
            { "{count}{op}{motion}", "repeat with count (e.g. 3dw)" },
        },
    },
    {
        title = "Visual",
        icon = "󰈈",
        items = {
            { "v / V / <C-v>", "char / line / block select" },
            { "> / <", "indent / outdent selection" },
            { "~", "toggle case" },
        },
    },
    {
        title = "Macros",
        icon = "󰑋",
        items = {
            { "q{reg}", "start recording into register" },
            { "q", "stop recording" },
            { "@{reg}", "play macro" },
            { "@@", "repeat last macro" },
            { ":reg", "list registers" },
        },
    },
    {
        title = "Windows",
        icon = "",
        items = {
            { "<leader>w", "window menu (which-key)" },
            { "<leader>ws / wv", "split / vsplit" },
            { "<leader>wh/j/k/l", "move focus" },
            { "<leader>wc / wo", "close / only" },
            { "<leader>w=", "balance sizes" },
        },
    },
    {
        title = "Buffers + Tabs",
        icon = "󰓩",
        items = {
            { ":ls", "list buffers" },
            { ":bnext / :bprev", "next / previous buffer" },
            { ":bd", "close buffer" },
            { "gt / gT", "next / previous tab" },
            { ":tabnew / :tabclose", "new / close tab" },
        },
    },
    {
        title = "Project",
        icon = "",
        items = {
            { "<leader>e", "toggle file tree" },
            { "<leader>ff", "find files" },
            { "<leader>fg", "live grep" },
            { "<leader>gg", "Git status (Fugitive)" },
            { "<leader>gA / ga", "Git add file / all" },
            { "<leader>gC / gM", "Git commit / amend" },
            { "<leader>gP / gL", "Git push / pull" },
            { "<leader>gd / gD", "Git diff index / HEAD" },
            { "<leader>gv", "Git vdiff" },
            { "<leader>gW / gR", "Git stage/reset buffer" },
            { "<leader>gl / gF", "Git log / fetch" },
            { "<leader>gb / gB", "git blame line / toggle" },
        },
    },
    {
        title = "Treesitter",
        icon = "",
        items = {
            { "af/if", "function textobjects" },
            { "ac/ic", "class textobjects" },
            { "aa/ia", "parameter textobjects" },
            { "[m ]m", "prev/next function start" },
            { "gnn grn grc grm", "incremental selection" },
            { "]a [a", "swap parameters" },
        },
    },
    {
        title = "LSP + Diagnostics",
        icon = "󰒋",
        items = {
            { "gd / gr", "go to definition / references" },
            { "<leader>ls", "document symbols" },
            { "<leader>ll / lq", "loclist / quickfix" },
            { "<leader>gm", "format file" },
        },
    },
    {
        title = "Terminal",
        icon = "",
        items = {
            { "tt", "toggle terminal" },
            { "<Esc>", "exit terminal mode" },
        },
    },
    {
        title = "Help",
        icon = "󰞋",
        items = {
            { "<leader>?", "toggle this window" },
            { ":help {topic}", "open help" },
        },
    },
}

local function build_lines()
    local max_key = 0
    for _, section in ipairs(sections) do
        for _, item in ipairs(section.items) do
            max_key = math.max(max_key, vim.fn.strdisplaywidth(item[1]))
        end
    end

    local built = { "Vim Quick Hints", "" }
    for _, section in ipairs(sections) do
        local title = section.title
        if section.icon then
            title = section.icon .. "  " .. section.title
        end
        table.insert(built, title)
        table.insert(built, string.rep("-", vim.fn.strdisplaywidth(title)))
        local fmt = string.format("  %%-%ds  %%s", max_key)
        for _, item in ipairs(section.items) do
            table.insert(built, string.format(fmt, item[1], item[2]))
        end
        table.insert(built, "")
    end
    table.insert(built, "Press q to close")

    return built
end

local function open()
    local buf = vim.api.nvim_create_buf(false, true)
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].swapfile = false

    local lines = build_lines()
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    local width = 0
    for _, line in ipairs(lines) do
        width = math.max(width, vim.fn.strdisplaywidth(line))
    end
    width = math.min(width + 2, math.floor(vim.o.columns * 0.85))
    local height = math.min(#lines + 2, math.floor(vim.o.lines * 0.85))
    local row = math.floor((vim.o.lines - height) / 2 - 1)
    local col = math.floor((vim.o.columns - width) / 2)
    if row < 0 then row = 0 end
    if col < 0 then col = 0 end

    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
    })
    vim.wo[win].wrap = false
    vim.wo[win].cursorline = false

    vim.keymap.set("n", "q", function() M.close() end, { buffer = buf, silent = true })

    state.win = win
    state.buf = buf
end

M.close = function()
    if state.win and vim.api.nvim_win_is_valid(state.win) then
        vim.api.nvim_win_close(state.win, true)
    end
    state.win = nil
    state.buf = nil
end

M.toggle = function()
    if state.win and vim.api.nvim_win_is_valid(state.win) then
        M.close()
    else
        open()
    end
end

return M
