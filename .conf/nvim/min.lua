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
-- Clear search highlight
vim.keymap.set("n", "<esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" } )

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h>", { desc = "Go to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j>", { desc = "Go to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k>", { desc = "Go to upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l>", { desc = "Go to right window" })

-- Resize window
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Tab navigation
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev. Tab" })
vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Tab" })
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Close Tab" })

-- File explorer (netrw)
vim.keymap.set("n", "<leader>e", vim.cmd.Ex, { desc = "Files explorer" } )


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
            vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
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
        event = { "BufWritePre "},
        cmd = { "ConformInfo" },
        opts = {
            formatter_by_ft = {
                python = { "black" },
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
                return { vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn,getregtype("") }
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
