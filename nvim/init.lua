---@diagnostic disable: missing-fields, undefined-global, deprecated
-- Bootstrap Lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Lazy
local plugins = {
    "neovim/nvim-lspconfig",
    {
        "nvim-tree/nvim-tree.lua",
        config = function()
            require("nvim-tree").setup({
                view = {
                    relativenumber = true,
                    adaptive_size = true
                }
            })
        end
    },
    {
        "hrsh7th/nvim-cmp",
        config = function()
            local cmp = require("cmp")
            cmp.setup({
                snippet = {
                    expand = function(args)
                        vim.fn["vsnip#anonymous"](args.body)
                    end
                },
                mapping = cmp.mapping.preset.insert {
                    ["<c-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<c-f>"] = cmp.mapping.scroll_docs(4),
                    ["<c-j>"] = cmp.mapping.select_next_item(),
                    ["<c-k>"] = cmp.mapping.select_prev_item(),
                    ["<c-Space>"] = cmp.mapping.complete(),
                    ["<c-e>"] = cmp.mapping.abort(),
                    ["<cr>"] = cmp.mapping.confirm({ select = true }),
                },
                sources = cmp.config.sources {
                    { name = "nvim_lsp" },
                    { name = "vsnip" }
                },
                {
                    { name = "buffer" },
                }
            })

            cmp.setup.filetype("gitcommit", {
                sources = cmp.config.sources({
                    { name = "git" },
                }, {
                    { name = "buffer" },
                })
            })
        end
    },
    "nanotee/sqls.nvim",
    "barreiroleo/ltex_extra.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/vim-vsnip",
    "nvim-tree/nvim-web-devicons",
    "ggandor/leap.nvim",
    "chomosuke/typst-preview.nvim",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "nyoom-engineering/oxocarbon.nvim",
    {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup()
        end
    },
    "ibhagwan/fzf-lua",
    "folke/neoconf.nvim",
    {
        "folke/trouble.nvim",
        opts = {},
        cmd = "Trouble"
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "cpp", "c", "lua", "vim", "rust", "javascript" },
                sync_install = false,
                auto_install = false,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false
                }
            })
        end
    },
}
local opts = {}
require("lazy").setup(plugins, opts)

-- Leap
require("leap").create_default_mappings()

-- Neoconf
require("neoconf").setup()

-- Mason
require("mason").setup()
local mason_lspconfig = require("mason-lspconfig")
mason_lspconfig.setup()
local capabilities = require("cmp_nvim_lsp").default_capabilities()
mason_lspconfig.setup_handlers({
    function(server_name)
        require("lspconfig")[server_name].setup({
            capabilities = capabilities
        })
    end,
    ["ltex"] = function()
        local lspconfig = require("lspconfig")
        lspconfig.ltex.setup({
            on_attach = function(_, _)
                require("ltex_extra").setup()
            end,
            settings = {
                ltex = {
                    language = "en-US",
                    enabled = {
                        "gitcommit",
                        "markdown",
                        "norg",
                        "tex",
                        "typst",
                        "latex"
                    },
                    dictionary = {}
                }
            },
            filetypes = {
                "gitcommit",
                "markdown",
                "norg",
                "tex",
                "typst"
            }
        })
    end
})

-- Keymaps
vim.g.mapleader = " "
vim.keymap.set("i", "jk", "<esc>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "k", "(v:count > 1 ? 'm`' . v:count : '') . 'k'",
    { noremap = true, expr = true, silent = true })
vim.keymap.set({ "n", "v" }, "j", "(v:count > 1 ? 'm`' . v:count : '') . 'j'",
    { noremap = true, expr = true, silent = true })
vim.keymap.set({ "n", "v" }, "<c-d>", "m`<c-d>")
vim.keymap.set({ "n", "v" }, "<c-u>", "m`<c-u>")
vim.keymap.set("n", "<leader>t", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>")
vim.keymap.set("n", "<leader>y", "<cmd>NvimTreeFocus<cr>")
vim.keymap.set("n", "<leader>d", vim.lsp.buf.definition)
vim.keymap.set("n", "<leader>D", vim.lsp.buf.declaration)
vim.keymap.set("n", "<leader>k", vim.lsp.buf.format)
vim.keymap.set("n", "<leader>c", vim.lsp.buf.code_action)
vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename)
vim.keymap.set("n", "<leader>h", vim.lsp.buf.hover)
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)

local fzf = require("fzf-lua")
vim.keymap.set("n", "<leader>ff", function() fzf.files({ cmd = "fd" }) end)
vim.keymap.set("n", "<leader>fg", fzf.live_grep)

-- Options
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.clipboard = "unnamedplus"
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.conceallevel = 0

-- File extensions
vim.filetype.add({
    extension = {
        typ = "typst"
    }
})

-- Theme
vim.opt.background = "dark"
vim.cmd.colorscheme("oxocarbon")
vim.api.nvim_set_hl(0, "@text.strong", { bold = true })
vim.api.nvim_set_hl(0, "@text.emphasis", { italic = true })

-- LSP
vim.diagnostic.config({
    virtual_text = false,
})

require("lspconfig")["hls"].setup({
    capabilities = capabilities,
})

-- EditorConfig
vim.g.editorconfig = true
