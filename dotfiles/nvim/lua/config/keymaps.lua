-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local map = vim.keymap.set

-- =====================================================
-- Cmd key mappings (Neovide GUI — VSCode style)
-- =====================================================
if vim.g.neovide or vim.env.TERM == "xterm-kitty" then
  -- File
  map({ "n", "i", "v" }, "<D-s>", "<cmd>w<cr><esc>", { desc = "Save" })
  map("n", "<D-w>", function() Snacks.bufdelete() end, { desc = "Close buffer" })
  map("n", "<D-n>", "<cmd>enew<cr>", { desc = "New file" })

  -- Clipboard
  map("v", "<D-c>", '"+y', { desc = "Copy" })
  map("n", "<D-c>", '"+yy', { desc = "Copy line" })
  map("n", "<D-v>", '"+p', { desc = "Paste" })
  map("i", "<D-v>", '<C-r>+', { desc = "Paste" })
  map("v", "<D-v>", '"+p', { desc = "Paste" })
  map("v", "<D-x>", '"+d', { desc = "Cut" })
  map("n", "<D-x>", '"+dd', { desc = "Cut line" })

  -- Undo / Redo
  map("n", "<D-z>", "u", { desc = "Undo" })
  map("i", "<D-z>", "<C-o>u", { desc = "Undo" })
  map({ "n", "i" }, "<D-S-z>", "<cmd>redo<cr>", { desc = "Redo" })

  -- Edit
  map("n", "<D-d>", "<cmd>t.<cr>", { desc = "Duplicate line" })
  map("i", "<D-d>", "<esc><cmd>t.<cr>gi", { desc = "Duplicate line" })
  map("v", "<D-d>", "y'>p", { desc = "Duplicate selection" })
  map("n", "<D-BS>", "dd", { desc = "Delete line" })
  map("i", "<D-BS>", "<esc>ddi", { desc = "Delete line" })

  -- Find
  map("n", "<D-f>", "/", { desc = "Find" })
  map("n", "<D-h>", ":%s/", { desc = "Find and replace" })
  map("n", "<D-p>", "<cmd>lua Snacks.picker.files()<cr>", { desc = "Quick open file" })
  map("n", "<D-S-p>", "<cmd>lua Snacks.picker.commands()<cr>", { desc = "Command palette" })
  map("n", "<D-S-f>", "<cmd>lua Snacks.picker.grep()<cr>", { desc = "Search in project" })

  -- Find next/prev match (Cmd+G / Cmd+Shift+G like VSCode)
  map({ "n", "i" }, "<D-g>", "<cmd>normal! n<cr>", { desc = "Next match" })
  map({ "n", "i" }, "<D-S-g>", "<cmd>normal! N<cr>", { desc = "Previous match" })

  -- Toggle sidebar (explorer)
  map("n", "<D-b>", "<cmd>lua Snacks.explorer()<cr>", { desc = "Toggle sidebar" })

  -- Toggle terminal
  map("n", "<D-j>", function() Snacks.terminal() end, { desc = "Toggle terminal" })
  map("t", "<D-j>", "<cmd>close<cr>", { desc = "Hide terminal" })

  -- Cmd+/ → Toggle comment (like VSCode)
  map("n", "<D-/>", "gcc", { remap = true, desc = "Toggle comment" })
  map("v", "<D-/>", "gc", { remap = true, desc = "Toggle comment" })
  map("i", "<D-/>", "<esc>gcca", { remap = true, desc = "Toggle comment" })

  -- Cmd+Shift+K → Delete line (VSCode default)
  map("n", "<D-S-k>", "dd", { desc = "Delete line" })
  map("i", "<D-S-k>", "<esc>ddi", { desc = "Delete line" })

  -- Cmd+L → Select line
  map("n", "<D-l>", "V", { desc = "Select line" })
  map("v", "<D-l>", "j", { desc = "Expand line selection" })

  -- Cmd+Shift+D → Go to definition (like F12 in VSCode)
  map("n", "<D-S-d>", vim.lsp.buf.definition, { desc = "Go to definition" })

  -- Cmd+. → Quick fix (like VSCode)
  map("n", "<D-.>", vim.lsp.buf.code_action, { desc = "Quick fix" })

  -- Cmd+Click → move cursor to click position first, then go to definition
  -- Click same symbol again → show references
  map("n", "<D-LeftMouse>", function()
    -- move cursor to mouse click position
    local pos = vim.fn.getmousepos()
    if pos.winid ~= 0 then
      vim.api.nvim_set_current_win(pos.winid)
      vim.api.nvim_win_set_cursor(pos.winid, { pos.line, pos.column - 1 })
    end
    vim.defer_fn(function()
      local word = vim.fn.expand("<cword>")
      if vim.b._last_cmd_click == word then
        vim.lsp.buf.references()
        vim.b._last_cmd_click = nil
      else
        vim.b._last_cmd_click = word
        vim.lsp.buf.definition()
      end
    end, 50)
  end, { desc = "Go to definition / references" })

  -- Cmd+Shift+O → Go to symbol in file
  map("n", "<D-S-o>", "<cmd>lua Snacks.picker.lsp_symbols()<cr>", { desc = "Go to symbol" })

  -- Ctrl+G → Go to line
  map("n", "<C-g>", ":", { desc = "Go to line" })

  -- Cmd+\ → Split editor right
  map("n", "<D-\\>", "<cmd>vsplit<cr>", { desc = "Split right" })

  -- F2 → Rename symbol
  map("n", "<F2>", vim.lsp.buf.rename, { desc = "Rename symbol" })

  -- Cmd+A → Select all
  map("n", "<D-a>", "ggVG", { desc = "Select all" })

  -- Cmd+[ / Cmd+] → Navigate back/forward (like VSCode)
  map("n", "<D-[>", "<C-o>", { desc = "Go back" })
  map("n", "<D-]>", "<C-i>", { desc = "Go forward" })
end

-- Ctrl+Click → gd first, if cursor didn't move then show references
map("n", "<C-LeftMouse>", function()
  local pos = vim.fn.getmousepos()
  if pos.winid ~= 0 then
    vim.api.nvim_set_current_win(pos.winid)
    vim.api.nvim_win_set_cursor(pos.winid, { pos.line, pos.column - 1 })
  end
  local buf_before = vim.api.nvim_get_current_buf()
  local cur_before = vim.api.nvim_win_get_cursor(0)
  vim.defer_fn(function()
    local orig_notify = vim.notify
    vim.notify = function(msg, level, opts)
      if type(msg) == "string" and msg:find("No results") then
        return
      end
      orig_notify(msg, level, opts)
    end
    vim.cmd("normal gd")
    vim.defer_fn(function()
      vim.notify = orig_notify
      local buf_after = vim.api.nvim_get_current_buf()
      local cur_after = vim.api.nvim_win_get_cursor(0)
      if buf_after == buf_before and cur_after[1] == cur_before[1] and cur_after[2] == cur_before[2] then
        Snacks.picker.lsp_references()
      end
    end, 300)
  end, 50)
end, { desc = "Go to definition / references" })

-- <leader>R → reload current lua file (keymaps, options, etc.)
map("n", "<leader>R", function()
  local file = vim.fn.expand("%:p")
  if not file:match("%.lua$") then
    vim.notify("Not a lua file", vim.log.levels.WARN)
    return
  end
  local mod = file:match("lua/(.+)%.lua$")
  if mod then
    mod = mod:gsub("/", ".")
    package.loaded[mod] = nil
  end
  dofile(file)
  vim.notify("Reloaded: " .. vim.fn.expand("%:t"), vim.log.levels.INFO)
end, { desc = "Reload current lua file" })

-- Esc → close popups, quickfix, trouble, etc (like VSCode dismisses panels)
map("n", "<Esc>", function()
  -- close quickfix
  if vim.fn.getqflist({ winid = 0 }).winid ~= 0 then
    vim.cmd("cclose")
    return
  end
  -- close location list
  if vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 then
    vim.cmd("lclose")
    return
  end
  -- clear search highlight
  vim.cmd("nohlsearch")
end, { desc = "Close popups / clear highlight" })

-- =====================================================
-- Standard keymaps (work in both terminal and GUI)
-- =====================================================

-- Move lines up/down (Alt+J/K) — same as VSCode Alt+Up/Down
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move line down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- Alt+D → Duplicate line down
map("n", "<A-d>", "<cmd>t.<cr>", { desc = "Duplicate line down" })
map("i", "<A-d>", "<esc><cmd>t.<cr>gi", { desc = "Duplicate line down" })
map("v", "<A-d>", "y'>p", { desc = "Duplicate selection down" })

-- Case transform
map("v", "<leader>cu", "gU", { desc = "UPPERCASE" })
map("v", "<leader>cl", "gu", { desc = "lowercase" })

-- Quick escape
map("i", "jk", "<esc>", { desc = "Exit insert mode" })

-- Tab to indent/unindent in visual (like VSCode)
map("v", "<Tab>", ">gv", { desc = "Indent" })
map("v", "<S-Tab>", "<gv", { desc = "Unindent" })
