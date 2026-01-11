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
  jsonls = {},
  dockerls = {},
  bashls = {},
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

local mlsp = require "mason-lspconfig"
local available = {}
do
  local ok, result = pcall(mlsp.get_available_servers)
  if ok then
    available = result
  else
    vim.schedule(
      function()
        vim.notify(
          "[mason-lspconfig] Failed to get available servers: " .. tostring(result),
          vim.log.levels.WARN
        )
      end
    )
    available = {}
  end
end

local ensure_installed = {} ---@type string[]
for server, server_opts in pairs(servers) do
  if server_opts then
    server_opts = server_opts == true and {} or server_opts
    -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
    if server_opts.mason == false or not vim.tbl_contains(available, server) then
      setup(server)
    else
      ensure_installed[#ensure_installed + 1] = server
    end
  end
end

require("mason").setup()
local has_lsp_enable = type(vim.lsp.enable) == "function"
require("mason-lspconfig").setup {
  ensure_installed = ensure_installed,
  automatic_installation = true,
  -- `vim.lsp.enable()` is only available on newer Neovim versions.
  automatic_enable = has_lsp_enable,
}

local ok_ft_map, ft_map = pcall(require, "mason-lspconfig.mappings.filetype")
local ok_srv_map, srv_map = pcall(require, "mason-lspconfig.mappings.server")
local ok_registry, registry = pcall(require, "mason-registry")
local attempted_installs = {}

local function ensure_server_installed(server)
  if attempted_installs[server] then return end
  attempted_installs[server] = true

  if not ok_registry or not ok_srv_map then return end
  local pkg_name = srv_map.lspconfig_to_package[server]
  if not pkg_name or not registry.has_package(pkg_name) then return end

  local ok_pkg, pkg = pcall(registry.get_package, pkg_name)
  if not ok_pkg or pkg:is_installed() or pkg:is_installing() then return end
  pkg:install()
end

if ok_ft_map then
  vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
      local ft = args.match
      local ft_servers = ft_map.filetype_to_server[ft]
      if type(ft_servers) == "string" then
        ft_servers = { ft_servers }
      end
      if type(ft_servers) ~= "table" then return end

      for _, server in ipairs(ft_servers) do
        if servers[server] ~= nil then
          ensure_server_installed(server)
        end
      end
    end,
  })
end

-- run :lua vim.lsp.inlay_hint.enable(true)
