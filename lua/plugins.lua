local function packer_setup()
  local fn = vim.fn
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
    config = require 'config.nvimtree'.config
  }
  -- Statusline
  use {
    'feline-nvim/feline.nvim',
    config = require 'config.feline'.config
  }
  -- Syntax highlighting
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }
  -- Completion engine
  use {
    "hrsh7th/nvim-cmp",
    config = require("config.cmp").config
  }
  -- Buffer completion source
  use {
    "hrsh7th/cmp-buffer",
  }
  -- Path completion source
  use {
    "hrsh7th/cmp-path",
  }
  -- LSP completion source
  use {
    "hrsh7th/cmp-nvim-lsp",
  }
  -- LSP configurations
  use {
    'neovim/nvim-lspconfig',
    config = require 'config.lspconfig'.config
  }
  -- Git integration
  use {
    'lewis6991/gitsigns.nvim',
    requires = {{'nvim-lua/plenary.nvim'}},
    config = require 'config.gitsigns'.config
  }
  -- Colorscheme
  use 'tomasr/molokai'
end

local ok, packer = pcall(require, "packer")
if not ok then
  packer = packer_setup()
end

packer.startup(plugins)
