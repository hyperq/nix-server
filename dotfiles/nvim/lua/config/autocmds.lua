-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

-- Auto-save on focus lost / buffer leave (like VS Code)
vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave" }, {
  callback = function()
    if vim.bo.modified and vim.bo.buftype == "" and vim.fn.expand("%") ~= "" then
      vim.cmd("silent! write")
    end
  end,
})

-- Prevent nvim from quitting when closing the last buffer (keep explorer alive)
vim.api.nvim_create_autocmd("QuitPre", {
  callback = function()
    local bufs = vim.tbl_filter(function(b)
      return vim.bo[b].buflisted and vim.bo[b].buftype == "" and b ~= vim.api.nvim_get_current_buf()
    end, vim.api.nvim_list_bufs())
    if #bufs == 0 then
      vim.cmd("enew")
    end
  end,
})

-- When nvim is opened with a directory argument:
--   1. cd into the directory
--   2. wait for plugins to load, then restore session
--   Snacks explorer handles the file tree automatically
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local arg = vim.fn.argv(0)
    if arg == "" or vim.fn.isdirectory(arg) ~= 1 then
      return
    end
    vim.cmd.cd(arg)
    -- use UIEnter + defer to ensure all plugins are fully loaded
    vim.api.nvim_create_autocmd("UIEnter", {
      once = true,
      callback = function()
        vim.defer_fn(function()
          local ok, persistence = pcall(require, "persistence")
          if ok then
            persistence.load()
          end
        end, 300)
      end,
    })
  end,
})
