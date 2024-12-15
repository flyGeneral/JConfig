local lspconfig = require'lspconfig'
lspconfig.jdtls.setup {
  init_options = {
    compilationDatabaseDirectory = "build";
    index = {
      threads = 0;
    };
  }
}
