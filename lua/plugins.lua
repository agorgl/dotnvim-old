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
  -- Colorscheme
  use 'tomasr/molokai'
end

local ok, packer = pcall(require, "packer")
if not ok then
  packer = packer_setup()
end

packer.startup(plugins)
