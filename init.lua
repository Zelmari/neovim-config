-- leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- nerd font for icons
vim.g.have_nerd_font = true

-- line numbers
vim.o.number = true
vim.o.relativenumber = true

-- indentation (4 spaces)
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.smartindent = true

-- show column at 80
vim.o.colorcolumn = "80"

-- not showing mode since its already in lualine
vim.o.showmode = false

-- sync clipboard between neovim and os
vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)

-- enable break indent
vim.o.breakindent = true

-- persistent undo
vim.o.undofile = true

-- search
vim.o.ignorecase = true
vim.o.smartcase = true

-- signcolumn
vim.o.signcolumn = "yes"

-- performance
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- splits
vim.o.splitright = true
vim.o.splitbelow = true

-- substitutions
vim.o.inccommand = "split"

-- cursorline
vim.o.cursorline = true

-- cursor style
vim.o.guicursor =
	"n-v-c:block-blinkwait0-blinkon500-blinkoff500,i-ci-ve:block-blinkwait0-blinkon500-blinkoff500,r-cr-o:block-blinkwait0-blinkon500-blinkoff500"

-- scroll
vim.o.scrolloff = 10

-- confirm
vim.o.confirm = true

-- clear highlights
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- diagnostics
vim.diagnostic.config({
	update_in_insert = false,
	severity_sort = true,
	float = { border = "rounded", source = "if_many" },
	virtual_text = true,
	virtual_lines = false,
	jump = { float = true },
})

-- diagnostic list
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

-- navigate diagnostics
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)

-- highlight yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- install lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({ "git", "clone", "https://github.com/folke/lazy.nvim.git", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- plugins
require("lazy").setup({

	-- colorscheme
	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		config = function()
			vim.o.termguicolors = true
			vim.cmd.colorscheme("gruvbox")

			-- transparent background
			vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
			vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
			vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
			vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })

			-- transparent diagnostic sign backgrounds
			vim.api.nvim_set_hl(0, "DiagnosticSignError", { bg = "none" })
			vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { bg = "none" })
			vim.api.nvim_set_hl(0, "DiagnosticSignInfo", { bg = "none" })
			vim.api.nvim_set_hl(0, "DiagnosticSignHint", { bg = "none" })
			vim.api.nvim_set_hl(0, "DiagnosticSignOk", { bg = "none" })

			-- transparent gitsigns sign backgrounds
			vim.api.nvim_set_hl(0, "GitSignsAdd", { bg = "none" })
			vim.api.nvim_set_hl(0, "GitSignsChange", { bg = "none" })
			vim.api.nvim_set_hl(0, "GitSignsDelete", { bg = "none" })
			vim.api.nvim_set_hl(0, "GitSignsTopdelete", { bg = "none" })
			vim.api.nvim_set_hl(0, "GitSignsChangedelete", { bg = "none" })
			vim.api.nvim_set_hl(0, "GitSignsUntracked", { bg = "none" })
		end,
	},

	-- status line
	{
		"nvim-lualine/lualine.nvim",
		config = function()
			require("lualine").setup()
		end,
	},

	-- file tree
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("nvim-tree").setup({
				view = {
					width = 35,
				},
				renderer = {
					group_empty = true,
				},
				filters = {
					dotfiles = false,
				},
				git = {
					ignore = false,
				},
			})

			vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>")
		end,
	},

	-- treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		main = "nvim-treesitter",
		opts = {
			ensure_installed = {
				"rust",
				"java",
				"javascript",
				"typescript",
				"lua",
				"python",
				"go",
				"html",
				"css",
			},
			highlight = { enable = true },
		},
	},

	-- telescope
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local t = require("telescope.builtin")
			vim.keymap.set("n", "<leader>ff", t.find_files)
			vim.keymap.set("n", "<leader>fg", t.live_grep)
			vim.keymap.set("n", "<leader>fb", t.buffers)
			vim.keymap.set("n", "<leader>fh", t.help_tags)
		end,
	},

	-- mason
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},

	-- lsp
	{
		"neovim/nvim-lspconfig",
		config = function()
			vim.lsp.enable({
				"lua_ls",
				"pyright",
				"ts_ls",
				"html",
				"cssls",
				"gopls",
			})
		end,
	},

	-- java
	{
		"mfussenegger/nvim-jdtls",
		ft = { "java" },
		config = function()
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "java",
				callback = function()
					require("jdtls").start_or_attach({})
				end,
			})
		end,
	},

	-- rust
	{
		"mrcjkb/rustaceanvim",
		version = "^4",
		ft = { "rust" },
	},

	-- completion
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"L3MON4D3/LuaSnip",
			"rafamadriz/friendly-snippets",
			"onsails/lspkind.nvim",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local lspkind = require("lspkind")

			require("luasnip.loaders.from_vscode").lazy_load()

			cmp.setup({
				preselect = cmp.PreselectMode.None,
				completion = {
					completeopt = "menu,menuone,noselect",
				},
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				formatting = {
					format = lspkind.cmp_format(),
				},
				mapping = cmp.mapping.preset.insert({
					["<CR>"] = cmp.mapping.confirm({ select = false }),
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-Space>"] = cmp.mapping.complete(),
					["<Tab>"] = cmp.config.disable,
					["<S-Tab>"] = cmp.config.disable,
				}),
				sources = {
					{ name = "nvim_lsp" },
					{ name = "buffer" },
					{ name = "path" },
				},
			})
		end,
	},

	-- codeium
	{
		"Exafunction/codeium.vim",
		event = "BufEnter",
		config = function()
			-- disable tab mapping
			vim.g.codeium_no_map_tab = true

			-- accept codeium suggestion with ctrl+l
			vim.keymap.set("i", "<C-l>", function()
				return vim.fn["codeium#Accept"]()
			end, { expr = true, silent = true })
		end,
	},

	-- formatting
	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "black" },
					javascript = { "prettier" },
					typescript = { "prettier" },
					html = { "prettier" },
					css = { "prettier" },
				},
				format_on_save = function(bufnr)
					local ft = vim.bo[bufnr].filetype
					if ft == "rust" or ft == "java" or ft == "go" then
						return { lsp_fallback = true }
					end
					return { timeout_ms = 500 }
				end,
			})
		end,
	},

	-- autopairs
	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup()
		end,
	},

	-- surround
	{
		"kylechui/nvim-surround",
		config = function()
			require("nvim-surround").setup()
		end,
	},

	-- comments
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	},

	-- gitsigns
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
	},

	-- crates
	{
		"saecki/crates.nvim",
		ft = { "toml" },
		config = function()
			require("crates").setup()
		end,
	},

	-- lazygit
	{
		"kdheepak/lazygit.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{ "<leader>gg", "<cmd>LazyGit<CR>" },
		},
	},

	-- toggleterm
	{
		"akinsho/toggleterm.nvim",
		config = function()
			require("toggleterm").setup({
				direction = "float",
				float_opts = {
					border = "curved",
					width = function()
						return math.floor(vim.o.columns * 0.9)
					end,
					height = function()
						return math.floor(vim.o.lines * 0.85)
					end,
				},
			})

			vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm direction=float<CR>")
			vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]])
		end,
	},
})

-- lsp keymaps
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		local opts = { buffer = event.buf }

		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
	end,
})
