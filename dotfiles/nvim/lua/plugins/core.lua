return {
  -- Material Design file icons (like VS Code Material Icon Theme)
  {
    "nvim-mini/mini.icons",
    init = function() end,
  },
  {
    "nvim-tree/nvim-web-devicons",
    lazy = false,
    priority = 100,
    dependencies = { "Allianaab2m/nvim-material-icon-v3" },
    config = function()
      require("nvim-web-devicons").setup({
        override = require("nvim-material-icon").get_icons(),
      })
    end,
  },

  -- Catppuccin theme (pairs well with Ghostty)
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      flavour = "frappe",
      transparent_background = vim.env.TERM == "xterm-kitty",
      custom_highlights = vim.env.TERM == "xterm-kitty" and function()
        return {
          NormalFloat = { bg = "NONE" },
          FloatBorder = { bg = "NONE" },
          SnacksNormal = { bg = "NONE" },
          SnacksNormalNC = { bg = "NONE" },
          SnacksPickerListNormal = { bg = "NONE" },
          SnacksPickerPreviewNormal = { bg = "NONE" },
          SnacksPickerInputNormal = { bg = "NONE" },
          SnacksPickerBoxNormal = { bg = "NONE" },
          SnacksPickerBorder = { bg = "NONE" },
          SnacksDashboardNormal = { bg = "NONE" },
          WinSeparator = { bg = "NONE" },
        }
      end or nil,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-frappe",
    },
  },

  -- outline: click or Enter jumps to symbol, auto-focus on cursor move
  {
    "hedyhli/outline.nvim",
    optional = true,
    opts = {
      outline_window = {
        auto_jump = true,
        focus_on_open = false,
      },
    },
  },

  -- Explorer: no horizontal scroll, wrap long names
  {
    "folke/snacks.nvim",
    opts = {
      lazygit = {
        configure = false,
      },
      notifier = {
        timeout = 5000,
      },
      picker = {
        sources = {
          explorer = {
            win = {
              list = {
                wo = {
                  wrap = true,
                  linebreak = true,
                },
              },
            },
          },
        },
      },
    },
  },

  -- VS Code-like buffer tabs
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        always_show_bufferline = true,
        show_buffer_close_buttons = true,
        show_close_icon = false,
        diagnostics = "nvim_lsp",
        offsets = {
          { filetype = "snacks_layout_box", text = "", padding = 0 },
        },
      },
    },
    keys = {
      { "<D-1>", "<cmd>BufferLineGoToBuffer 1<cr>", desc = "Go to buffer 1" },
      { "<D-2>", "<cmd>BufferLineGoToBuffer 2<cr>", desc = "Go to buffer 2" },
      { "<D-3>", "<cmd>BufferLineGoToBuffer 3<cr>", desc = "Go to buffer 3" },
      { "<D-4>", "<cmd>BufferLineGoToBuffer 4<cr>", desc = "Go to buffer 4" },
      { "<D-5>", "<cmd>BufferLineGoToBuffer 5<cr>", desc = "Go to buffer 5" },
    },
  },

  -- Rainbow bracket pairs (like VS Code)
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "BufReadPost",
  },

  -- Scrollbar with diagnostics & git marks (like VS Code)
  {
    "lewis6991/satellite.nvim",
    event = "VeryLazy",
    opts = {
      current_only = false,
      winblend = 50,
      handlers = {
        cursor = { enable = true },
        search = { enable = true },
        diagnostic = { enable = true },
        gitsigns = { enable = true },
      },
    },
  },

  -- Breadcrumbs navigation (like VS Code)
  {
    "SmiteshP/nvim-navic",
    lazy = true,
    opts = { lsp = { auto_attach = true, preference = { "vtsls" } } },
  },
  {
    "utilyre/barbecue.nvim",
    event = "BufReadPost",
    dependencies = { "SmiteshP/nvim-navic", "nvim-tree/nvim-web-devicons" },
    opts = { attach_navic = false },
  },

  -- Inline color preview for hex/rgb (like VS Code)
  {
    "norcalli/nvim-colorizer.lua",
    event = "BufReadPost",
    opts = { "*" },
  },

  -- Auto close/rename HTML & JSX tags (like VS Code)
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    opts = {},
  },

  -- git blame inline (show author + date at end of each line)
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 300,
      },
    },
  },
}
