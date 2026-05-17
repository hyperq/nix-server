return {

  -- Go LSP customization
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          settings = {
            gopls = {
              analyses = {
                -- disable noisy style checks
                ST1000 = false,  -- package comment
                ST1003 = false,  -- naming convention (MixedCaps etc)
                ST1016 = false,  -- method receiver naming
                ST1020 = false,  -- comment on exported type
                ST1021 = false,  -- comment on exported var
                ST1022 = false,  -- comment on exported const
                QF1008 = false,  -- omit embedded field names
                errcheck = false,
                useany = false,
              },
              directoryFilters = { "-.git", "-node_modules", "-vendor" },
              diagnosticsDelay = "500ms",
              vulncheck = "Off",
              codelenses = {
                gc_details = false,
              },
              staticcheck = true,
              gofumpt = true,
              usePlaceholders = false,
              hints = {
                assignVariableTypes = false,
                compositeLiteralFields = false,
                compositeLiteralTypes = false,
                constantValues = false,
                functionTypeParameters = false,
                parameterNames = false,
                rangeVariableTypes = false,
              },
            },
          },
        },
      },
    },
  },

  -- oxfmt formatter for web files
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        vue = { "oxfmt" },
        typescript = { "oxfmt" },
        typescriptreact = { "oxfmt" },
        javascript = { "oxfmt" },
        javascriptreact = { "oxfmt" },
        css = { "oxfmt" },
        html = { "oxfmt" },
        json = { "oxfmt" },
      },
      formatters = {
        oxfmt = {
          command = "oxfmt",
          args = { "--stdin-filepath", "$FILENAME" },
          stdin = true,
        },
      },
    },
  },

  -- Extra treesitter parsers
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "bash",
        "fish",
        "lua",
        "python",
        "dockerfile",
        "html",
        "css",
      })
    end,
  },
}
