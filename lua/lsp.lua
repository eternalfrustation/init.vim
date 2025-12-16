local vue_language_server_path = '/home/sandy/.local/bin/vue-language-server'
local vue_plugin = {
  name = '@vue/typescript-plugin',
  location = vue_language_server_path,
  languages = { 'vue' },
  configNamespace = 'typescript',
}
vim.lsp.config('vtsls', {
  settings = {
    vtsls = {
      tsserver = {
        globalPlugins = {
          vue_plugin,
        },
      },
    },
  },
  filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
})

vim.lsp.enable("rust_analyzer")
vim.lsp.enable("ts_ls")
vim.lsp.enable("clangd")
vim.lsp.enable("vtsls")
vim.lsp.enable("gopls")
vim.lsp.enable("ruff")
vim.lsp.enable("html")
vim.lsp.enable("slint_lsp")
vim.lsp.enable("dartls")
vim.lsp.enable("nushell")
vim.lsp.enable("wgsl_analyzer")
vim.lsp.enable("zls")
vim.lsp.enable("templ")
vim.lsp.enable("jsonls")
vim.lsp.enable("gdscript")
vim.lsp.enable("ty")


