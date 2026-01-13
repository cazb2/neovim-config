--
-- ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
-- ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
-- ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
-- ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
-- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
-- ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
--
-- File: plugins/configs/lspconfig.lua
-- Description: LSP setup and config
-- Author: Kien Nguyen-Tuan <kiennt2609@gmail.com>
local merge_tables = require("utils").merge_tables

local hover_opts = {
  border = { " ", " ", " ", " ", " ", " ", " ", " " },
  max_width = 80,
  max_height = 20,
}
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, hover_opts)
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, hover_opts)

local exist, custom = pcall(require, "custom")
local custom_formatting_servers = exist and type(custom) == "table" and custom.formatting_servers or {}
local formatting_servers = {
  pyright = {},
  jsonls = {},
  dockerls = {},
  bashls = {},
  rust_analyzer = {},
  clangd = {},
  jdtls = {},
  ruff_lsp = {},
  vimls = {},
  yamlls = {},
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          library = vim.api.nvim_get_runtime_file("", true),
          checkThirdParty = false,
        },
        telemetry = {
          enable = false,
        },
      },
    },
  },
}

-- Merge
merge_tables(formatting_servers, custom_formatting_servers)

local opts = {
  -- Automatically format on save
  autoformat = true,
  -- options for vim.lsp.buf.format
  -- `bufnr` and `filter` is handled by the LazyVim formatter,
  -- but can be also overridden when specified
  format = {
    formatting_options = nil,
    timeout_ms = nil,
  },
  -- LSP Server Settings
  servers = formatting_servers,
  -- you can do any additional lsp server setup here
  -- return true if you don"t want this server to be setup with lspconfig
  setup = {
    -- example to setup with typescript.nvim
    -- tsserver = function(_, opts)
    --   require("typescript").setup({ server = opts })
    --   return true
    -- end,
    -- Specify * to use this function as a fallback for any server
    -- ["*"] = function(server, opts) end,
  },
}

local servers = opts.servers
local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

local function enable_inlay_hints(bufnr)
  if not vim.lsp.inlay_hint or type(vim.lsp.inlay_hint.enable) ~= "function" then return end
  pcall(vim.lsp.inlay_hint.enable, true, { bufnr = bufnr })
end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args) enable_inlay_hints(args.buf) end,
})

local function setup(server)
  local server_opts = vim.tbl_deep_extend("force", {
    capabilities = vim.deepcopy(capabilities),
  }, servers[server] or {})

  if opts.setup[server] then
    if opts.setup[server](server, server_opts) then return end
  elseif opts.setup["*"] then
    if opts.setup["*"](server, server_opts) then return end
  end
  require("lspconfig")[server].setup(server_opts)
end

for server, server_opts in pairs(servers) do
  if server_opts then
    setup(server)
  end
end

-- run :lua vim.lsp.inlay_hint.enable(true)
