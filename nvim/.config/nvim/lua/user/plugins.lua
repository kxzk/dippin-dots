local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

require('packer').startup(function(use)
    -- package manager
    use 'wbthomason/packer.nvim'

    -- faster loads
    use 'lewis6991/impatient.nvim'

    -- git
    use 'lewis6991/gitsigns.nvim'

    -- colorscheme
    use 'shaunsingh/nord.nvim'

    -- syntax highlighting
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
    }

    -- lsp
    use {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'neovim/nvim-lspconfig'
    }
   require('mason').setup()
   local mason_lspconfig = require('mason-lspconfig')
   mason_lspconfig.setup({
     ensure_installed = {
       -- 'gopls',
       -- 'rust_analyzer',
       -- 'pyright'
     }
   })
   mason_lspconfig.setup_handlers({
     function(server_name)
       require('lspconfig')[server_name].setup({
         on_attach = function(client, bufnr)
           require('user.lsp.lsp').on_attach(client, bufnr)
         end
       })
     end
   })

    -- fuzzy finder
    use {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.0',
        requires = {
            {'nvim-lua/plenary.nvim'},
            { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
        }
    }

    -- python
    -- make sure pynvim installed
    -- use { 'psf/black', cmd = 'Black' }

    -- commenting
    use 'scrooloose/nerdcommenter'

    -- docs
    use 'rizzatti/dash.vim'

    if packer_bootstrap then
        require('packer').sync()
    end
end)
