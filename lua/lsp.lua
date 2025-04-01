local lspconfig = require("lspconfig")

lspconfig.rust_analyzer.setup{}
lspconfig.ts_ls.setup{}
lspconfig.vuels.setup{}
lspconfig.clangd.setup{}
lspconfig.gopls.setup{}
lspconfig.biome.setup{}
lspconfig.ruff.setup{}

return lspconfig
