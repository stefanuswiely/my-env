-- Lazy plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local out = vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        "https://github.com/folke/lazy.nvim.git",
        lazypath
    })
end

vim.opt.rtp:prepend(lazypath)


local config_path = vim.fn.stdpath("config")

if vim.env.NVIM_MODE == "lazy" then
    dofile(config_path .. "/lazy.lua")
else
    dofile(config_path .. "/min.lua")
end
