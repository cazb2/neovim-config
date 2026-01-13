local M = {}

M.is_mac = vim.fn.has("macunix") == 1
M.is_linux = vim.fn.has("linux") == 1

M.has = function(cmd)
    return vim.fn.executable(cmd) == 1
end

M.has_clipboard = function()
    if vim.fn.has("clipboard") == 0 then
        return false
    end
    if M.is_mac then
        return true
    end
    if M.is_linux then
        return M.has("wl-copy") or M.has("xclip") or M.has("xsel")
    end
    return false
end

return M
