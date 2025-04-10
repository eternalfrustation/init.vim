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

require(".lsp")

vim.g.have_nerd_font = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.background = "dark"
vim.cmd [[ colorscheme dracula ]]
vim.o.mouse = ""
-- Setup language servers.

function isRecording ()
  local reg = vim.fn.reg_recording()
  if reg == "" then return "" end -- not recording
  return "Macro @" .. reg
end

vim.g.neovide_position_animation_length = 0
vim.g.neovide_cursor_animation_length = 0.00
vim.g.neovide_cursor_trail_size = 0
vim.g.neovide_cursor_animate_in_insert_mode = false
vim.g.neovide_cursor_animate_command_line = false
vim.g.neovide_scroll_animation_far_lines = 0
vim.g.neovide_scroll_animation_length = 0.00
vim.g.neovide_gamma = 0.0
vim.g.neovide_contrast = 0


vim.o.guifont = "0xProto Nerd Font Mono:h10"
vim.o.completeopt = "fuzzy,menu,noinsert,popup"


-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client:supports_method('textDocument/completion') then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
		if client:supports_method('textDocument/formatting') then
			vim.keymap.set('n', '<Space>f', function() vim.lsp.buf.format({ id = client.id }) end, {})
		end
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
		:with_pair(ts_conds.is_not_ts_node({'function'})),
	Rule("~", "~", "markdown")
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


local function parrot_status()
	local status_info = require("parrot.config").get_status_info()
	local status = ""
	if status_info.is_chat then
		status = status_info.prov.chat.name
	else
		status = status_info.prov.command.name
	end
	return string.format("%s(%s)", status, status_info.model)
end

require('lualine').setup({
	extensions = {'oil'},
	sections = {
		lualine_a = {'mode', parrot_status},
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

require'nvim-treesitter.configs'.setup {
	indent = {
		enable = true
	},
}

vim.o.tabstop=4
vim.o.softtabstop=4
vim.o.expandtab = false
vim.o.shiftwidth = 4

require('gitsigns').setup()
require("oil").setup()
vim.o.cmdheight=0

vim.diagnostic.config({virtual_lines = true})

require("pest-vim").setup {}

require("parrot").setup {
	providers = {
		ollama = {},
	}
}

vim.o.shell="bash"
