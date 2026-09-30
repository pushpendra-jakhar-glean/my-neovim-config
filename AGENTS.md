# Repository Notes

## Neovim Java / JDTLS

- This config is based on LazyVim with the Snacks picker extra. For Java in the Scio monorepo, do not assume a failed `gd` or `gr` means JDTLS is broken. First validate raw LSP requests with `textDocument/definition` and `textDocument/references`.
- In `~/glean/scio`, JDTLS should not be rooted at the monorepo root for Java files. Root Java buffers under `~/glean/scio/java` and test buffers under `~/glean/scio/javatests`; rooting at `~/glean/scio` causes JDTLS to import/refresh unrelated projects such as `/android`.
- Use a workspace directory derived from the full root path, not just the final directory name, because there can be multiple Scio worktrees under `~/glean`.
- If Java `gd` or `gr` shows Snacks messages such as "no lsp references found" but raw JDTLS requests return locations, the broken layer is the LazyVim/Snacks picker integration. Keep the override scoped to `servers.jdtls.keys`; do not globally change Go/Python/JS mappings.
- Current intended Java-specific LazyVim override:

```lua
servers = {
  jdtls = {
    keys = {
      { "gd", vim.lsp.buf.definition, desc = "Goto Definition" },
      { "gr", vim.lsp.buf.references, desc = "References", nowait = true },
    },
  },
}
```

- Avoid custom semantic hacks for `gd`/`gr`. Prefer Neovim's built-in LSP handlers when the raw JDTLS response is valid and only the picker is failing.
