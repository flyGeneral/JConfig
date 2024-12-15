local lspconfig = require'lspconfig'
lspconfig.kotlin_language_server.setup {
  init_options = {
    compilationDatabaseDirectory = "build";
    index = {
      threads = 0;
    };
  }
}
