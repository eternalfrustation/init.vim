vim.o.guifont = "0xProto Nerd Font Mono:h10"
vim.g.neovide_cursor_animation_length=0.0
vim.g.neovide_cursor_vfx_mode = "railgun"
vim.g.neovide_position_animation_length = 0
vim.g.neovide_scroll_animation_length = 0

vim.pack.add{
	{ src = 'https://github.com/kylechui/nvim-surround' },
	{ src = 'https://github.com/neovim/nvim-lspconfig' },
	{ src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
	{ src = 'https://github.com/nvim-telescope/telescope-fzy-native.nvim' },
	{ src = 'https://github.com/nvim-telescope/telescope.nvim' },
	{ src = 'https://github.com/nvim-lua/plenary.nvim' },
	{ src = 'https://github.com/nvim-tree/nvim-web-devicons' },
	{ src = 'https://github.com/nvim-lualine/lualine.nvim' },
	{ src = 'https://github.com/windwp/nvim-ts-autotag' },
	{ src = 'https://github.com/lewis6991/gitsigns.nvim' },
	{ src = 'https://github.com/stevearc/oil.nvim' },
	{ src = 'https://github.com/MunifTanjim/nui.nvim' },
	{ src = 'https://github.com/nvim-treesitter/nvim-treesitter-context' },
	{ src = 'https://github.com/nvim-lua/popup.nvim' },
	{ src = 'https://github.com/jvgrootveld/telescope-zoxide' },
	{ src = 'https://github.com/mcauley-penney/visual-whitespace.nvim' },
	{ src = 'https://github.com/ellisonleao/gruvbox.nvim' },
	{ src = 'https://github.com/illia-shkroba/telescope-completion.nvim' },
	{ src = 'https://github.com/sindrets/diffview.nvim' },
	{ src = 'https://github.com/mfussenegger/nvim-dap' },
	{ src = 'https://github.com/nvim-neotest/nvim-nio' },
	{ src = 'https://github.com/rcarriga/nvim-dap-ui' },
	{ src = 'https://github.com/theHamsta/nvim-dap-virtual-text' },
	{ src = 'https://github.com/catppuccin/nvim' },
	{ src = 'https://github.com/m4xshen/hardtime.nvim' },
	{ src = 'https://github.com/yetone/avante.nvim' },
	{ src = 'https://github.com/MeanderingProgrammer/render-markdown.nvim' },
	{ src = 'https://github.com/chomosuke/typst-preview.nvim' },
}

require(".lsp")

vim.g.have_nerd_font = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.background = "dark"
vim.o.shell = "bash"

vim.o.mouse = ""

function isRecording ()
	local reg = vim.fn.reg_recording()
	if reg == "" then return "" end -- not recording
	return "Macro @" .. reg
end

vim.o.completeopt = "menu,popup,fuzzy,noinsert"

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
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


local treesitter_lang = { "c", "lua", "vim", "vimdoc", "query", "markdown", "go", "rust", "cpp" }

local treesitter = require'nvim-treesitter'
treesitter.setup {}
treesitter.install(treesitter_lang)

vim.api.nvim_create_autocmd('FileType', {
  pattern = treesitter_lang,
  callback = function() vim.treesitter.start() end,
})

require("nvim-surround").setup({})

-- Declare a global function to retrieve the current directory
function _G.get_oil_winbar()
  local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
  local dir = require("oil").get_current_dir(bufnr)
  if dir then
    return vim.fn.fnamemodify(dir, ":~")
  else
    -- If there is no current directory (e.g. over ssh), just show the buffer name
    return vim.api.nvim_buf_get_name(0)
  end
end

local oil = require("oil")
oil.setup({
  win_options = {
    winbar = "%!v:lua.get_oil_winbar()",
  },
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
vim.keymap.set('n', '<leader>fr', telescope_builtin.resume, {})
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

vim.lsp.inlay_hint.enable()

local completion = require("telescope").load_extension("completion")

require("gruvbox").setup({
  contrast = "hard", -- can be "hard", "soft" or empty string
})

vim.cmd("colorscheme gruvbox")

local ui = require("dapui")

local dap = require("dap")

dap.adapters.gdb = {
  type = "executable",
  command = "gdb",
  args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
}
local dap_virtual_text = require("nvim-dap-virtual-text")

-- Dap Virtual Text
dap_virtual_text.setup()

dap.adapters.lldb = {
  type = 'executable',
  command = 'lldb-dap', -- adjust as needed, must be absolute path
  name = 'lldb'
}

dap.configurations.zig = {
  {
    name = "Debug Project",
    type = "lldb",
    request = "launch",
	program = '${workspaceFolder}/zig-out/bin/${workspaceFolderBasename}',
    args = {}, -- provide arguments if needed
    cwd = "${workspaceFolder}",
    stopAtBeginningOfMainSubprogram = false,
  },
}

dap.adapters.delve = {
  type = 'server',
  port = '${port}',
  executable = {
    command = 'dlv',
    args = {'dap', '-l', '127.0.0.1:${port}', "--log", "--log-output=dap"},
  }
}

dap.configurations.go = {
	{
    type = "delve",
    name = "Debug Current File",
    request = "launch",
    program = "${file}",
  },
  {
    type = "delve",
    name = "Debug Test",
    request = "launch",
    mode = "test",
    program = "${file}",
  },
  {
    type = "delve",
    name = "Debug Entire Package",
    request = "launch",
    program = "${workspaceFolder}",
  }
}

ui.setup()


vim.fn.sign_define("DapBreakpoint", { text = "🔴" })

dap.listeners.before.attach.dapui_config = function()
	ui.open()
end
dap.listeners.before.launch.dapui_config = function()
	ui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
	ui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	ui.close()
end

vim.keymap.set('n', '<leader>dt', function() dap.toggle_breakpoint() end, {})
vim.keymap.set('n', '<leader>dc', function() dap.continue() end, {})
vim.keymap.set('n', '<leader>di', function() dap.step_into() end, {})
vim.keymap.set('n', '<leader>do', function() dap.step_over() end, {})
vim.keymap.set('n', '<leader>du', function() dap.step_out() end, {})
vim.keymap.set('n', '<leader>dr', function() dap.repl.open() end, {})
vim.keymap.set('n', '<leader>dl', function() dap.run_last() end, {})
vim.keymap.set('n', '<leader>dq', function() 
	dap.terminate()
	ui.close()
	dap_virtual_text.toggle()

end, {})
vim.keymap.set('n', '<leader>db', function() dap.list_breakpoints() end, {})
vim.keymap.set('n', '<leader>de', function() dap.set_exception_breakpoints({"all"}) end, {})
vim.keymap.set('n', '<leader>dv', function() ui.elements.watches.add(vim.fn.expand('<cword>')) end, {})

require("hardtime").setup()

require("render-markdown").setup({
	file_types = { "markdown" },
})


vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('my.lsp', {}),
	callback = function(ev)
		local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
		if client:supports_method('textDocument/completion') then
			vim.lsp.completion.enable(true, client.id, ev.buf, {
				autotrigger = true,
			} )
		end
		if not client:supports_method('textDocument/willSaveWaitUntil')
			and client:supports_method('textDocument/formatting') then
			vim.api.nvim_create_autocmd('BufWritePre', {
				group = vim.api.nvim_create_augroup('my.lsp', {clear=false}),
				buffer = ev.buf,
				callback = function()
					vim.lsp.buf.format({ bufnr = ev.buf, id = client.id, timeout_ms = 1000 })
				end,
			})
		end
	end,
})

require("typst-preview").setup()
