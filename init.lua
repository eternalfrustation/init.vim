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
		local spaceIterator = vim.gsplit(packagePath, " ")
		local path = spaceIterator()
		local folders = {}
		local packagePathSplit = {}
		for e in spaceIterator do
			folders[#folders + 1] = e
		end

		for e in vim.gsplit(path, "/") do
			packagePathSplit[#packagePathSplit + 1] = e
		end
		local packageName = packagePathSplit[#packagePathSplit]
		local fsPath = vim.fs.joinpath(pluginDir, packageName)

		print(os.execute("git clone --recursive "..path.." "..fsPath))
	end
end

require(".lsp")

vim.g.have_nerd_font = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.background = "dark"
vim.o.shell = "bash"

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
vim.o.completeopt = "menuone,preinsert,noselect,popup"

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
local z_utils = require("telescope._extensions.zoxide.utils")

require('telescope').setup{
	extensions = {
		zoxide = {
			prompt_title = "[ Walking on the shoulders of TJ ]",
			mappings = {
				default = {
					after_action = function(selection)
						print("Update to (" .. selection.z_score .. ") " .. selection.path)
					end
				},
				["<C-s>"] = {
					before_action = function(selection) print("before C-s") end,
					action = function(selection)
						vim.cmd.edit(selection.path)
					end
				},
				-- Opens the selected entry in a new split
				["<C-q>"] = { action = z_utils.create_basic_command("split") },
				["<CR>"] = { action = z_utils.create_basic_command("tcd") },
			},
		}
	}
}



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

local oil = require("oil")
oil.setup({
	watch_for_changes = true,
	constrain_cursor = "name",
})

local telescope = require('telescope')
local telescope_builtin = require('telescope.builtin')

telescope.load_extension('fzy_native')
telescope.load_extension('zoxide')

vim.keymap.set('n', '<leader>ff', telescope_builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', telescope_builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', telescope_builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', telescope_builtin.help_tags, {})
vim.keymap.set('n', '<leader>fa', telescope_builtin.quickfix, {})
vim.keymap.set('n', '<leader>fj', telescope_builtin.jumplist, {})
vim.keymap.set('n', '<leader>fd', telescope_builtin.diagnostics, {})
vim.keymap.set('n', '<leader>fs', telescope_builtin.treesitter, {})
vim.keymap.set("n", "<leader>pp", telescope_builtin.builtin, {})
vim.keymap.set('n', '<leader>fo', "<CMD>Oil --float<Cr>", {})
vim.keymap.set("n", "<leader>cd", telescope.extensions.zoxide.list)
vim.keymap.set("n", "<leader>tt", vim.cmd.tabnew)

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
		lualine_a = {'filename'},
		lualine_b = {'diff', 'diagnostics'},
		lualine_c = {isRecording},
		lualine_x = {'encoding', 'fileformat', 'filetype'},
		lualine_y = {'progress'},
		lualine_z = {'location'}
	},
	tabline = {
		lualine_a = {'mode'},
		lualine_b = {'branch'},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {'tabs'},
	},
})

vim.api.nvim_create_user_command("Time", "pu =strftime('%a %d %b %Y')", {})

vim.keymap.set('n', '<leader>rg', function() 
	vim.ui.input({prompt="Rg: "}, 
		function(input)
			if input then
				vim.cmd.grep{ args = {input}, mods = {silent = true} }
				vim.cmd.cw()
			end
		end
	)
end)

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
vim.o.scrolloff = 7

require('gitsigns').setup()

vim.diagnostic.config({virtual_lines = true})

require'treesitter-context'.setup{
	enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
	multiwindow = true, -- Enable multiwindow support.
	max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
	min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
	line_numbers = true,
	multiline_threshold = 20, -- Maximum number of lines to show for a single context
	trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
	mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
	-- Separator between context and content. Should be a single character string, like '-'.
	-- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
	separator = nil,
	zindex = 20, -- The Z-index of the context window
	on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
}

require'nvim-treesitter.configs'.setup {
	textobjects = {
		select = {
			enable = true,

			-- Automatically jump forward to textobj, similar to targets.vim
			lookahead = true,

			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				-- You can optionally set descriptions to the mappings (used in the desc parameter of
				-- nvim_buf_set_keymap) which plugins like which-key display
				["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
				-- You can also use captures from other query groups like `locals.scm`
				["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
			},

			selection_modes = {
				['@parameter.outer'] = 'v', -- charwise
				['@function.outer'] = 'V', -- linewise
				['@class.outer'] = '<c-v>', -- blockwise
			},
		},
		lsp_interop = {
			enable = true,
			floating_preview_opts = {},
			peek_definition_code = {
				["<leader>df"] = "@function.outer",
				["<leader>dF"] = "@class.outer",
			},
		},
		swap = {
			enable = true,
			swap_previous = {
				["<leader>A"] = "@parameter.inner",
			},
			swap_next = {
				["<leader>a"] = "@parameter.inner",
			},
		},

		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				["]m"] = "@function.outer",
				["]]"] = { query = "@class.outer", desc = "Next class start" },
				["]x"] = { query = "@parameter.inner", desc = "Next parameter" },
				--
				-- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queries.
				["]o"] = "@loop.*",
				-- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
				--
				-- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
				-- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
				["]s"] = { query = "@local.scope", query_group = "locals", desc = "Next scope" },
				["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
			},
			goto_next_end = {
				["]M"] = "@function.outer",
				["]["] = "@class.outer",
			},
			goto_previous_start = {
				["[m"] = "@function.outer",
				["[["] = "@class.outer",
				["[x"] = { query = "@parameter.inner", desc = "Previous parameter start" },
			},
			goto_previous_end = {
				["[M"] = "@function.outer",
				["[]"] = "@class.outer",
			},
			-- Below will go to either the start or the end, whichever is closer.
			-- Use if you want more granular movements
			-- Make it even more gradual by adding multiple queries and regex.
			goto_next = {
				["]d"] = "@conditional.outer",
			},
			goto_previous = {
				["[d"] = "@conditional.outer",
			}
		},
		lsp_interop = {
			enable = true,
			border = 'none',
			floating_preview_opts = {},
			peek_definition_code = {
				["<leader>df"] = "@function.outer",
				["<leader>dF"] = "@class.outer",
			},
		},
		select = {
			enable = true,

			-- Automatically jump forward to textobj, similar to targets.vim
			lookahead = true,

			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["aa"] = "@parameter.outer",
				["ia"] = "@parameter.inner",
				["ac"] = "@class.outer",
				-- You can optionally set descriptions to the mappings (used in the desc parameter of
				-- nvim_buf_set_keymap) which plugins like which-key display
				["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
				-- You can also use captures from other query groups like `locals.scm`
				["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
			},
			-- You can choose the select mode (default is charwise 'v')
			--
			-- Can also be a function which gets passed a table with the keys
			-- * query_string: eg '@function.inner'
			-- * method: eg 'v' or 'o'
			-- and should return the mode ('v', 'V', or '<c-v>') or a table
			-- mapping query_strings to modes.
			selection_modes = {
				['@parameter.outer'] = 'v', -- charwise
				['@function.outer'] = 'V', -- linewise
				['@class.outer'] = '<c-v>', -- blockwise
			},
		},
	},
}

vim.lsp.config('ty', {
  settings = {
    ty = {
      diagnosticMode = 'workspace',
      experimental = {
        autoImport = true,
      },
    },
  },
})

vim.lsp.inlay_hint.enable()

local completion = require("telescope").load_extension("completion")

vim.keymap.set("i", [[<C-z>]], function()
  if vim.fn.pumvisible() == 1 then
	return completion.completion_expr()
  else
	return [[<C-z>]]
  end
end, { expr = true, desc = "List popup-menu completion in Telescope" })

require("gruvbox").setup({
  contrast = "hard", -- can be "hard", "soft" or empty string
})
vim.cmd("colorscheme gruvbox")
vim.keymap.set("n", "<leader>gg", "<cmd>Neogit kind=floating<cr>", { desc = "Open Neogit UI" })
