function installPackages()
	local config_dir = vim.fn['stdpath']('config')
	local packagesFilePath = vim.fs.joinpath(config_dir, "packages.list")
	local packagesFile = io.open(packagesFilePath, "r")
	if not packagesFile then return end
	packagesFile:close()
	local pluginDir = ""
	if jit.os == "Windows" then
		pluginDir = vim.fs.joinpath(vim.env.LOCALAPPDATA, "nvim-data", "site", "pack", "frustrated", "start")
	else
		if vim.env.XDG_DATA_HOME then
			pluginDir = vim.fs.joinpath(vim.env.HOME, vim.env.XDG_DATA_HOME, "nvim", "site", "pack", "frustrated", "start")
		else
			pluginDir = vim.fs.joinpath(vim.env.HOME, ".local", "share", "nvim", "site", "pack", "frustrated", "start")
		end
	end
	for packagePath in io.lines(packagesFilePath) do
		local packagePathSplit = {}
		for e in vim.gsplit(packagePath, "/") do
			packagePathSplit[#packagePathSplit + 1] = e
		end
		local packageName = packagePathSplit[#packagePathSplit]
		print(os.execute("git clone --recursive "..packagePath.." "..vim.fs.joinpath(pluginDir, packageName)))
	end
end
vim.g.have_nerd_font = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.background = "dark"
vim.cmd [[ colorscheme dracula ]]
vim.o.completeopt = "menu"
vim.o.mouse = ""
-- Setup language servers.
local lspconfig = require('lspconfig')
local language_servers = { "gopls", "clangd", "html", "rust_analyzer", "cssls", "zls", "openscad_lsp", "ruff", "svelte", "dartls", "markdown_oxide", "biome", "ruff"}
for _, language_server in ipairs(language_servers) do
	lspconfig[language_server].setup {}
end

function isRecording ()
  local reg = vim.fn.reg_recording()
  if reg == "" then return "" end -- not recording
  return "Macro @" .. reg
end


require'lspconfig'.ts_ls.setup{
  init_options = {
    plugins = {
      {
        name = "@vue/typescript-plugin",
        location = "/home/sandy/.local/share/pnpm/global/5/node_modules/@vue/typescript-plugin",
        languages = {"javascript", "typescript", "vue"},
      },
    },
  },
  filetypes = {
    "javascript",
    "typescript",
    "vue",
  },
}


vim.g.neovide_position_animation_length = 0
vim.g.neovide_cursor_animation_length = 0.00
vim.g.neovide_cursor_trail_size = 0
vim.g.neovide_cursor_animate_in_insert_mode = false
vim.g.neovide_cursor_animate_command_line = false
vim.g.neovide_scroll_animation_far_lines = 0
vim.g.neovide_scroll_animation_length = 0.00


vim.o.guifont = "0xProto Nerd Font Mono,Twemoji:h9"


-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf }
		vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
		vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
		vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
		vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
		vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
		vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
		vim.keymap.set('n', '<space>wl', function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts)
		vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
		vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
		vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
		vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
		vim.keymap.set('n', '<space>f', function()
			vim.lsp.buf.format { async = true }
		end, opts)
	end,
})
require('telescope').setup()

require('telescope').load_extension('fzy_native')

require'nvim-treesitter.configs'.setup {
	ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "go", "rust", "cpp" },

	sync_install = false,

	auto_install = true,

	highlight = {
		enable = true,

		additional_vim_regex_highlighting = false,
	},
	indent = {
		enable = true,
	}
}

require("nvim-surround").setup({})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fa', builtin.quickfix, {})
vim.keymap.set('n', '<leader>fj', builtin.jumplist, {})
vim.keymap.set('n', '<leader>fd', builtin.diagnostics, {})
vim.keymap.set('n', '<leader>fs', builtin.treesitter, {})

require'nvim-web-devicons'.setup {
	color_icons = true;
	default = true;
	strict = true;
	override_by_filename = {
		[".gitignore"] = {
			icon = "",
			color = "#f1502f",
			name = "Gitignore"
		}
	};
	-- same as `override` but specifically for overrides by extension
	-- takes effect when `strict` is true
	override_by_extension = {
		["log"] = {
			icon = "",
			color = "#81e043",
			name = "Log"
		}
	};
}
local npairs = require("nvim-autopairs")
local Rule = require('nvim-autopairs.rule')

npairs.setup({
	check_ts = true,
	ts_config = {
		lua = {'string'},-- it will not add a pair on that treesitter node
		javascript = {'template_string'},
		java = false,-- don't check treesitter on java
	}
})

local ts_conds = require('nvim-autopairs.ts-conds')


-- press % => %% only while inside a comment or string
npairs.add_rules({
	Rule("%", "%", "lua")
		:with_pair(ts_conds.is_ts_node({'string','comment'})),
	Rule("$", "$", "lua")
		:with_pair(ts_conds.is_not_ts_node({'function'}))
})

function updatePackages()
	local config_dir = vim.fn['stdpath']('config')
	local packagesFilePath = vim.fs.joinpath(config_dir, "packages.list")
	local packagesFile = io.open(packagesFilePath, "r")
	if not packagesFile then return end
	packagesFile:close()
	local pluginDir = ""
	if jit.os == "Windows" then
		pluginDir = vim.fs.joinpath(vim.env.LOCALAPPDATA, "nvim-data", "site", "pack", "frustrated", "start")
	else
		if vim.env.XDG_DATA_HOME then
			pluginDir = vim.fs.joinpath(vim.env.HOME, vim.env.XDG_DATA_HOME, "nvim", "site", "pack", "frustrated", "start")
		else
			pluginDir = vim.fs.joinpath(vim.env.HOME, ".local", "share", "nvim", "site", "pack", "frustrated", "start")
		end
	end
	for packagePath in io.lines(packagesFilePath) do
		local packagePathSplit = {}
		for e in vim.gsplit(packagePath, "/") do
			packagePathSplit[#packagePathSplit + 1] = e
		end
		local packageName = packagePathSplit[#packagePathSplit]
		print(os.execute("git pull --recursive \""..packagePath.."\" \""..vim.fs.joinpath(pluginDir, packageName).."\""))
	end
end



require('lualine').setup({
	extensions = {'oil'},
	sections = {
		lualine_a = {'mode'},
		lualine_b = {'diff', 'diagnostics'},
		lualine_c = {isRecording},
		lualine_x = {'encoding', 'fileformat', 'filetype'},
		lualine_y = {'progress'},
		lualine_z = {'location'}
	},
	tabline = {
		lualine_a = {'filename'},
		lualine_b = {'branch'},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {'tabs'},
	},
})

vim.api.nvim_create_user_command("Time", "pu =strftime('%a %d %b %Y')", {})


local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

parser_config.nu = {
	install_info = {
		url = "https://github.com/nushell/tree-sitter-nu",
		files = { "src/parser.c" },
		branch = "main",
	},
	filetype = "nu",
}

require('nvim-ts-autotag').setup({
	opts = {
		-- Defaults
		enable_close = true, -- Auto close tags
		enable_rename = true, -- Auto rename pairs of tags
		enable_close_on_slash = true -- Auto close on trailing </
	},
	-- Also override individual filetype configs, these take priority.
	-- Empty by default, useful if one of the "opts" global settings
	-- doesn't work well in a specific filetype
})

vim.keymap.set('n', '<space>y', vim.cmd.UndotreeToggle)
if vim.fn.has("persistent_undo") == 1 then
	local target_path = vim.fn.expand('~/.undodir')

	-- create the directory and any parent directories if it does not exist
	if vim.fn.isdirectory(target_path) == 0 then
		vim.fn.mkdir(target_path, "p", 0700)
	end

	vim.o.undodir = target_path
	vim.o.undofile = true
end

require'nvim-treesitter.configs'.setup {
	indent = {
		enable = true
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "gnn", -- set to `false` to disable one of the mappings
			node_incremental = "grn",
			scope_incremental = "grc",
			node_decremental = "grm",
		},
	},
}

require("typescript-tools").setup {}
vim.o.tabstop=4
vim.o.softtabstop=4
vim.o.expandtab = false
vim.o.shiftwidth = 4

require('gitsigns').setup()
require("oil").setup()
vim.o.cmdheight=0

require("lspconfig").markdown_oxide.setup({
    -- Ensure that dynamicRegistration is enabled! This allows the LS to take into account actions like the
    -- Create Unresolved File code action, resolving completions for unindexed code blocks, ...
    capabilities = vim.tbl_deep_extend(
        'force',
        vim.lsp.protocol.make_client_capabilities(),
        {
            workspace = {
                didChangeWatchedFiles = {
                    dynamicRegistration = true,
                },
            },
        }
    ),
})

local function check_codelens_support()
local clients = vim.lsp.get_active_clients({ bufnr = 0 })
for _, c in ipairs(clients) do
  if c.server_capabilities.codeLensProvider then
    return true
  end
end
return false
end

vim.api.nvim_create_autocmd({ 'TextChanged', 'InsertLeave', 'CursorHold', 'LspAttach', 'BufEnter' }, {
buffer = bufnr,
callback = function ()
  if check_codelens_support() then
    vim.lsp.codelens.refresh({bufnr = 0})
  end
end
})
-- trigger codelens refresh
vim.api.nvim_exec_autocmds('User', { pattern = 'LspAttached' })

