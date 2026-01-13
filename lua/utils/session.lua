local M = {}

local function session_dir()
  local dir = vim.fn.stdpath("state") .. "/sessions"
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p")
  end
  return dir
end

local function session_name(cwd)
  local name = cwd:gsub("/$", "")
  name = name:gsub("/", "%%")
  return name
end

local function session_path()
  local cwd = vim.fn.getcwd()
  local dir = session_dir()
  return dir .. "/" .. session_name(cwd) .. ".vim"
end

M.save = function()
  local path = session_path()
  vim.cmd("silent! mksession! " .. vim.fn.fnameescape(path))
  vim.v.this_session = path
end

M.load = function()
  local path = session_path()
  if vim.fn.filereadable(path) == 0 then
    vim.notify("No session found for this directory", vim.log.levels.WARN)
    return
  end
  vim.cmd("silent! source " .. vim.fn.fnameescape(path))
end

M.delete = function()
  local path = session_path()
  if vim.fn.filereadable(path) == 0 then
    vim.notify("No session to delete for this directory", vim.log.levels.WARN)
    return
  end
  vim.fn.delete(path)
  vim.notify("Session deleted", vim.log.levels.INFO)
end

M.list = function()
  local dir = session_dir()
  local files = vim.fn.globpath(dir, "*.vim", false, true)
  if #files == 0 then
    vim.notify("No saved sessions", vim.log.levels.INFO)
    return
  end
  vim.cmd("edit " .. vim.fn.fnameescape(dir))
end

return M
