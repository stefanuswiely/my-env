-- Leader character
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.scrolloff = 8
vim.opt.hlsearch = true

-- Tab & space
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.termguicolors = true
vim.opt.smartindent = true

-- Search sensitive
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Key bindings
-- Normal mode
-- Clean search highlight
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Remove search highlight" } )
-- File explorer (netrw)
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Files explorer" } )


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

require("lazy").setup({
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config= function()
            vim.cmd([[colorscheme tokyonight]])
        end,
    },

    {
        "echasnovski/mini.pairs",
        version = false,
        config = function()
            require("mini.pairs").setup()
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function() 
            require("nvim-treesitter").setup({
                ensure_installed = { "lua", "javascript", "typescript", "html", "css", "python" },
                highlight = { 
                    enable = true,
                    disable = { "text", "txt", "plain" }
                },
            })
        end,
    },

    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function() 
            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Search files" })
            vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Search word in files" })
        end,
    },

    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup({
                options = {
                    theme = "tokyonight",
                    section_separators = "",
                    component_separators = "|",
                    globalstatus = true,
                },
            })
        end,
    },

    {
        "stevearc/conform.nvim",
        event = { "BufWritePre"},
        cmd = { "ConformInfo" },
        opts = {
            formatters_by_ft = {
                python = { "black" },
            },

            formatters = {
                black = {
                    command = function()
                        local cwd = vim.fn.getcwd()
                        local venv_black = cwd .."/.venv/bin/black"
                        if vim.fn.executable(venv_black) == 1 then
                            return venv_black
                        end
                        return "black"
                    end,
                },
            },

            format_on_save = {
                timeout_ms = 500,
                lsp_fallback = true,
            },
        },
    },

    {
        "ojroques/nvim-osc52",
        config = function()
            local osc52 = require("osc52")

            local function copy(lines, _)
                osc52.copy(table.concat(lines, "\n"))
            end

            local function paste()
                return { vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") }
            end

            if not os.getenv("DISPLAY") then
                vim.g.clipboard = {
                    name = "OSC 52",
                    copy = { ["+"] = copy, ["*"] = copy },
                    paste = { ["+"] = paste, ["*"] = paste },
                }
            end
	end,
    },
})
