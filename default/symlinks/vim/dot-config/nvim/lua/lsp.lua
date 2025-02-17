-- Rustaceanvim
vim.g.rustaceanvim = {
  server = {
    on_attach = on_attach,
    default_settings = {
      -- rust-analyzer language server configuration
      ['rust-analyzer'] = {
        rustfmt = {
          extraArgs = {
            "--config-path",
            "/google/src/head/depot/google3/devtools/rust/rustfmt.toml"
          },
        },
      },
    },
  }
}
