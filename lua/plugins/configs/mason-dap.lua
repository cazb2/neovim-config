-- File: plugins/configs/mason-dap.lua
-- Description: mason-nvim-dap setup
return {
    ensure_installed = { "codelldb", "cpptools" },
    automatic_installation = true,
}
