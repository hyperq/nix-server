-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

vim.g.mapleader = " "

vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 0
vim.opt.cursorline = true
vim.opt.mouse = "a"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"

-- Neovide settings
if vim.g.neovide then
  vim.o.guifont = "Maple Mono NF CN:h14:w1:#e2"
  vim.opt.linespace = 6

  -- Transparency
  vim.g.neovide_opacity = 0.9
  vim.g.neovide_normal_opacity = 0.9

  -- Padding
  vim.g.neovide_padding_top = 4
  vim.g.neovide_padding_bottom = 0
  vim.g.neovide_padding_right = 4
  vim.g.neovide_padding_left = 4

  -- Input
  vim.g.neovide_input_macos_option_key_is_meta = "only_left"

  -- VSCode-like cursor (bar, minimal animation)
  vim.g.neovide_cursor_animation_length = 0.02
  vim.g.neovide_cursor_trail_size = 0.1
  vim.g.neovide_cursor_animate_in_insert_mode = true

  -- Smooth scroll like VSCode
  vim.g.neovide_scroll_animation_length = 0.15
  vim.g.neovide_scroll_animation_far_lines = 1

  -- Confirm before quit (like VSCode unsaved changes)
  vim.g.neovide_confirm_quit = true

  -- Hide mouse when typing
  vim.g.neovide_hide_mouse_when_typing = true

  -- Remember window size
  vim.g.neovide_remember_window_size = true

  -- Theme follows system
  vim.g.neovide_theme = "auto"
end

-- Only show Error and Warning diagnostics, hide Info/Hint
vim.diagnostic.config({
  severity_sort = true,
  virtual_text = {
    severity = { min = vim.diagnostic.severity.WARN },
  },
  signs = {
    severity = { min = vim.diagnostic.severity.WARN },
  },
  underline = {
    severity = { min = vim.diagnostic.severity.WARN },
  },
})
