return {

  -- Smooth scrolling
  {
    "folke/snacks.nvim",
    opts = {
      scroll = { enabled = true },
    },
  },

  -- Better buffer tabs (top bar like VSCode tabs)
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        mode = "buffers",
        always_show_bufferline = true,
        show_buffer_close_icons = true,
        show_close_icon = false,
        separator_style = "thin",
        diagnostics = "nvim_lsp",
        offsets = {
          {
            filetype = "snacks_layout_box",
            text = "Explorer",
            highlight = "Directory",
            text_align = "center",
          },
        },
      },
    },
  },

  -- Indent guides (like VSCode's indent lines)
  {
    "folke/snacks.nvim",
    opts = {
      indent = {
        enabled = true,
        animate = { enabled = false },
      },
    },
  },

  -- Breadcrumbs / winbar (file path + symbols at top, like VSCode)
  {
    "SmiteshP/nvim-navic",
    lazy = true,
    opts = {
      lsp = { auto_attach = true },
      separator = " > ",
      highlight = true,
    },
  },

  -- Color preview inline (like VSCode shows color swatches)
  {
    "brenoprata10/nvim-highlight-colors",
    event = "BufReadPre",
    opts = {
      render = "virtual",
      virtual_symbol = "●",
    },
  },
}
