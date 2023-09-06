return {
  {
    'shaunsingh/nord.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'nord'
      vim.cmd [[highlight Comment guifg=#4C566A]]         -- comment color
      vim.cmd [[highlight LineNr guifg=#3B4252]]          -- dim line numbers
      vim.cmd [[highlight CursorLineNr guifg=#EBCB8B]]    -- brighter cursorline number
      vim.cmd [[highlight EndOfBuffer guifg=#2E3440]]     -- dim tilde under line number
      vim.cmd [[highlight VertSplit guifg=#EBCB8B gui=None guibg=None]]   -- remove bad split coloring
      vim.cmd [[highlight MsgArea guifg=#EBCB8B]]         -- dim command line/message area
    end,
  },
  {
    'lewis6991/gitsigns.nvim',
    opts = {
        signs = {
          add          = { hl = 'GitSignsAdd'   , text = '│', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'    },
          change       = { hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn' },
          delete       = { hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn' },
          topdelete    = { hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn' },
          changedelete = { hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn' },
          untracked    = { hl = 'GitSignsAdd'   , text = '╎', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'    },
        }
    }
  },
  { 'numToStr/Comment.nvim', opts = {}, event = "VeryLazy" },
  { 'github/copilot.vim' , event = "VeryLazy" },
  { 'rizzatti/dash.vim', cmd = 'DashSearch' },
    -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      }
    },
    opts = {
      defaults = {
        prompt_prefix = '❯❯❯ ',
        selection_caret = '❯ ',
        entry_prefix = ' ',
        initial_mode = 'insert',
        selection_strategy = "reset",
        sorting_strategy = "ascending",
        layout_strategy = 'horizontal',
        layout_config = {
          horizontal = {
              prompt_position = 'top',
              preview_width = 0.55,
              results_width = 0.8,
          },
          vertical = {
              mirror = false,
          },
        },
                file_ignore_patterns = {
            '^.git/',
            '^.cache/',
            '^__pycache__/',
            '^target/',
            '^docs/',
            'Cargo.toml',
            'Library',
            'Documents',
            '^.rustup/',
            '^.cargo/',
            '^.local/',
            '^.Trash/',
            '^pkg/',
            '%.ttf',
            '%.otf',
            '%.svg',
            '%.sqlite3',
            '%.lock',
            '%.pdf',
            '%.zip',
            '%.cache',
        },
        path_display = { 'truncate' },
        winblend = 0,
        results_title = false,
        preview_title = false,
        borderchars = {
            { "▀", "▐", "▄", "▌", "▛", "▜", "▟", "▙" },
            prompt = { "▀", "▐", "▄", "▌", "▛", "▜", "▟", "▙" },
            results = { " ", "▐", "▄", "▌", "▌", "▐", "▟", "▙" },
            preview = { "▀", "▐", "▄", "▌", "▛", "▜", "▟", "▙" },
        }
      }
    }
  },
  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
    opts = {
      ensure_installed = {
        "python",
        "go",
        "sql",
        "rust",
        "json",
        "markdown",
        "lua",
        "dockerfile",
        "cmake",
        "elixir",
        "fish",
        "swift",
        "yaml",
        "html",
        "css",
        "c",
        "cpp"
      },
      sync_install = false, -- async install
      ignore_install = { "" }, -- list of parsers to install
      highlight = {
        enable = true,
        disable = { "" },
        additional_vim_regex_highligting = true,
      },
      indent = { enable = false }
    }
  },
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',
    }
  }
}