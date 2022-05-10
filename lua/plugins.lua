local cmd = vim.cmd
local fn = vim.fn

local function packer_setup()
  local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    print "Cloning packer..."
    fn.system { "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path }
    vim.cmd [[packadd packer.nvim]]
  end
  local _, packer = pcall(require, "packer")
  return packer
end

local function plugins(use)
  -- Plugin manager
  use 'wbthomason/packer.nvim'
  -- Fuzzy finder
  use {
    'nvim-telescope/telescope.nvim',
    requires = {{'nvim-lua/plenary.nvim'}}
  }
  -- File explorer
  use {
    'kyazdani42/nvim-tree.lua',
    config = function() require 'config.nvimtree'.config() end
  }
  -- Statusline
  use {
    'feline-nvim/feline.nvim',
    config = function() require 'config.feline'.config() end,
    after = 'onedark.nvim'
  }
  -- Tabline
  use {
    'akinsho/bufferline.nvim',
    config = function() require 'config.bufferline'.config() end
  }
  -- Syntax highlighting
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function() require 'config.treesitter'.config() end
  }
  -- Completion engine
  use {
    "hrsh7th/nvim-cmp",
    requires = {
      {"hrsh7th/cmp-buffer"},
      {"hrsh7th/cmp-path"},
      {"hrsh7th/cmp-nvim-lsp"},
      {"saadparwaiz1/cmp_luasnip"},
    },
    config = function() require("config.cmp").config() end
  }
  -- Snippet engine
  use {
    "L3MON4D3/LuaSnip"
  }
  -- LSP configurations
  use {
    'neovim/nvim-lspconfig',
    config = function() require 'config.lspconfig'.config() end
  }
  -- LSP signature hints
  use {
    "ray-x/lsp_signature.nvim",
  }
  -- LSP integration with external utilities
  use {
    "jose-elias-alvarez/null-ls.nvim",
  }
  -- Git integration
  use {
    'lewis6991/gitsigns.nvim',
    requires = {{'nvim-lua/plenary.nvim'}},
    config = function() require 'config.gitsigns'.config() end
  }
  -- Git wrapper
  use 'tpope/vim-fugitive'
  -- Project manager
  use {
    'ahmedkhalf/project.nvim',
    config = function() require 'config.project'.config() end
  }
  -- Terminal manager
  use {
    'akinsho/toggleterm.nvim',
    config = function() require 'config.toggleterm'.config() end
  }
  -- Autopairs
  use {
    'windwp/nvim-autopairs',
    config = function() require 'config.autopairs'.config() end
  }
  -- Autotags
  use {
    'windwp/nvim-ts-autotag',
    config = function() require 'config.autotags'.config() end
  }
  -- Surround editing
  use 'tpope/vim-surround'
  -- Buffer option heuristics
  use 'tpope/vim-sleuth'
  -- Colorscheme
  use {
    'navarasu/onedark.nvim',
    config = function() require 'config.onedark'.config() end
  }
end

local luapath = fn.resolve(fn.stdpath("config")) .. "/lua"
cmd(string.format([[
augroup packer_user_config
  autocmd!
  autocmd BufWritePost %s/plugins.lua source <afile> | PackerCompile
augroup end
]], luapath, luapath))

local ok, packer = pcall(require, "packer")
if not ok then
  packer = packer_setup()
end

packer.startup(plugins)
if not ok then
  packer.sync()
end
