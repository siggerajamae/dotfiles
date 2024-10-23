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
    "barreiroleo/ltex_extra.nvim",
    "chomosuke/typst-preview.nvim",
    "folke/neoconf.nvim",
    "ggandor/leap.nvim",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/vim-vsnip",
    "ibhagwan/fzf-lua",
    "nanotee/sqls.nvim",
    "neovim/nvim-lspconfig",
    "nvim-tree/nvim-web-devicons",
    "nyoom-engineering/oxocarbon.nvim",
    {
        "echasnovski/mini.nvim",
        config = function()
            require("mini.icons").setup()
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
                    ["<tab>"] = cmp.mapping.select_next_item(),
                    ["<s-tab>"] = cmp.mapping.select_prev_item(),
                    ["<c-space>"] = cmp.mapping.complete(),
                    ["<c-c>"] = cmp.mapping.abort(),
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
    {
        "nvim-tree/nvim-tree.lua",
        config = function()
            require("nvim-tree").setup({
                view = {
                    relativenumber = true,
                    adaptive_size = true
                },
                on_attach = function(bufnr)
                    local api = require("nvim-tree.api")
                    api.config.mappings.default_on_attach(bufnr)
                    vim.keymap.set("n", "<c-cr>", api.tree.change_root_to_node)
                end
            })
        end
    },
    {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup()
        end
    },
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

-- Keymaps
--- Leader
vim.g.mapleader = " "

--- Exit insert with jk
vim.keymap.set("i", "jk", "<esc>", { noremap = true, silent = true })

--- Enable jump history for j and k movements
vim.keymap.set({ "n", "v" }, "k", "(v:count > 1 ? 'm`' . v:count : '') . 'k'",
    { noremap = true, expr = true, silent = true })
vim.keymap.set({ "n", "v" }, "j", "(v:count > 1 ? 'm`' . v:count : '') . 'j'",
    { noremap = true, expr = true, silent = true })

--- Enable jump history for c-d and c-u movements
vim.keymap.set({ "n", "v" }, "<c-d>", "m`<c-d>")
vim.keymap.set({ "n", "v" }, "<c-u>", "m`<c-u>")

--- Tabs
---- Navigate
vim.keymap.set({ "n", "v" }, "<c-q>", "<cmd>tabclose<cr>")
vim.keymap.set({ "n", "v" }, "<c-j>", "<cmd>tabfirst<cr>")
vim.keymap.set({ "n", "v" }, "<c-k>", "<cmd>tablast<cr>")
vim.keymap.set({ "n", "v" }, "<c-h>", "<cmd>tabp<cr>")
vim.keymap.set({ "n", "v" }, "<c-l>", "<cmd>tabn<cr>")

---- Move
vim.keymap.set({ "n", "v" }, "<c-s-j>", "<cmd>0tabmove<cr>")
vim.keymap.set({ "n", "v" }, "<c-s-k>", "<cmd>$tabmove<cr>")
vim.keymap.set({ "n", "v" }, "<c-s-h>", "<cmd>-tabmove<cr>")
vim.keymap.set({ "n", "v" }, "<c-s-l>", "<cmd>+tabmove<cr>")

--- Windows
---- Navigate
vim.keymap.set({ "n", "v" }, "<a-q>", "<c-w>q")
vim.keymap.set({ "n", "v" }, "<a-j>", "<c-w>j")
vim.keymap.set({ "n", "v" }, "<a-k>", "<c-w>k")
vim.keymap.set({ "n", "v" }, "<a-h>", "<c-w>h")
vim.keymap.set({ "n", "v" }, "<a-l>", "<c-w>l")

---- Move
vim.keymap.set({ "n", "v" }, "<a-s-j>", "<c-w>J")
vim.keymap.set({ "n", "v" }, "<a-s-k>", "<c-w>K")
vim.keymap.set({ "n", "v" }, "<a-s-h>", "<c-w>H")
vim.keymap.set({ "n", "v" }, "<a-s-l>", "<c-w>L")

---- Resize
vim.keymap.set({ "n", "v" }, "<a-c-j>", "<c-w>10-")
vim.keymap.set({ "n", "v" }, "<a-c-k>", "<c-w>10+")
vim.keymap.set({ "n", "v" }, "<a-c-h>", "<c-w>10<")
vim.keymap.set({ "n", "v" }, "<a-c-l>", "<c-w>10>")

--- Deselect
vim.keymap.set({ "n", "v" }, "<c-7>", "<cmd>noh<cr>")

--- Trouble
vim.keymap.set("n", "<leader>t", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>")

--- Nvim-tree
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeFocus<cr>")

--- Lsp
vim.keymap.set("n", "<leader>d", vim.lsp.buf.definition)
vim.keymap.set("n", "<leader>D", vim.lsp.buf.declaration)
vim.keymap.set("n", "<leader>k", vim.lsp.buf.format)
vim.keymap.set("n", "<leader>c", vim.lsp.buf.code_action)
vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename)
vim.keymap.set("n", "<leader>q", vim.lsp.buf.hover)

--- Diagnostics
vim.keymap.set("n", "<leader>w", vim.diagnostic.open_float)

--- Fzf
local fzf = require("fzf-lua")
vim.keymap.set("n", "<leader>ff", function() fzf.files({ cmd = "fd --hidden --ignore-case" }) end)
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

-- Default configuration
local language_servers = {
    "lua_ls",
    "rust_analyzer",
    "svelte",
    "html",
    "ts_ls",
    "jsonls",
    "cssls"
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

for _, ls in ipairs(language_servers) do
    require("lspconfig")[ls].setup({
        capabilities = capabilities,
    })
end

-- EditorConfig
vim.g.editorconfig = true
