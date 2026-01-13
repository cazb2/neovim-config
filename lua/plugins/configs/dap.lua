-- File: plugins/configs/dap.lua
-- Description: DAP configuration for GDB/LLDB
local dap = require "dap"

local function get_mason_adapter_path(pkg_name, rel_path, win_ext)
    local adapter
    local ok_registry, registry = pcall(require, "mason-registry")
    if ok_registry and registry.has_package and registry.has_package(pkg_name) then
        local ok_pkg, pkg = pcall(registry.get_package, pkg_name)
        if ok_pkg and pkg and type(pkg.get_install_path) == "function" then
            adapter = pkg:get_install_path() .. "/" .. rel_path
        end
    end

    if not adapter then
        adapter = vim.fn.stdpath("data") .. "/mason/packages/" .. pkg_name .. "/" .. rel_path
    end

    if win_ext and vim.fn.has("win32") == 1 then adapter = adapter .. win_ext end
    if vim.fn.executable(adapter) ~= 1 then return nil end

    return adapter
end

dap.adapters.cppdbg = function(callback, _)
    local adapter = get_mason_adapter_path("cpptools", "extension/debugAdapters/bin/OpenDebugAD7", ".exe")
    if not adapter then
        vim.notify("cpptools package not installed. Install it with :Mason", vim.log.levels.ERROR)
        return
    end

    callback {
        id = "cppdbg",
        type = "executable",
        command = adapter,
        options = { detached = false },
    }
end

dap.adapters.codelldb = function(callback, _)
    local adapter = get_mason_adapter_path("codelldb", "extension/adapter/codelldb", ".exe")
    if not adapter then
        vim.notify("codelldb package not installed. Install it with :Mason", vim.log.levels.ERROR)
        return
    end

    callback {
        type = "server",
        port = "${port}",
        executable = {
            command = adapter,
            args = { "--port", "${port}" },
        },
    }
end

local function pick_program()
    return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
end

local function lldb_config()
    return {
        name = "Launch (LLDB)",
        type = "codelldb",
        request = "launch",
        program = pick_program,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        terminal = "console",
    }
end

local function gdb_config()
    return {
        name = "Launch (GDB)",
        type = "cppdbg",
        request = "launch",
        program = pick_program,
        cwd = "${workspaceFolder}",
        stopAtEntry = false,
        MIMode = "gdb",
        miDebuggerPath = "gdb",
        setupCommands = {
            {
                text = "-enable-pretty-printing",
                description = "Enable pretty printing",
                ignoreFailures = true,
            },
        },
    }
end

dap.configurations.c = { lldb_config(), gdb_config() }
dap.configurations.cpp = { lldb_config(), gdb_config() }
dap.configurations.rust = { lldb_config(), gdb_config() }

vim.fn.sign_define("DapBreakpoint", { text = "B", texthl = "DiagnosticError" })
vim.fn.sign_define("DapStopped", { text = ">", texthl = "DiagnosticInfo" })

local ok_dapui, dapui = pcall(require, "dapui")
if ok_dapui then
    dapui.setup {
        expand_lines = true,
        floating = { border = "single" },
        layouts = {
            {
                elements = { "scopes", "breakpoints", "stacks", "watches" },
                size = 40,
                position = "left",
            },
            {
                elements = {
                    { id = "console", size = 0.6 },
                    { id = "repl", size = 0.4 },
                },
                size = 0.33,
                position = "bottom",
            },
        },
        render = {
            max_type_length = 80,
            max_value_lines = 20,
        },
    }

    dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
    dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
    dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
end

local ok_virtual, virtual_text = pcall(require, "nvim-dap-virtual-text")
if ok_virtual then
    virtual_text.setup {
        highlight_changed_variables = true,
        show_stop_reason = true,
    }
end
