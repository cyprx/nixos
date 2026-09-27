# Neovim

The shared Home Manager module uses Neovim 0.12+ and its built-in `vim.pack`.
Plugin sources and version ranges live in `nvim0/lua/pack-init.lua`; larger
setup tables live in `nvim0/lua/plugins/`. Navigation mappings are in
`nvim0/lua/keymap.lua`.

After rebuilding Home Manager / nix-darwin, restart Neovim. The first launch
downloads missing plugins using Git and builds Telescope's native fzf dependency
with `make`. Later launches do not check for plugin updates.

- Update plugins: `:lua vim.pack.update()`; review the changes, then `:write`
  to apply or `:quit` to cancel. Restart Neovim after updating.
- Inspect plugins offline: `:lua vim.pack.update(nil, { offline = true })`.
- Install configured external tools: `:MasonToolsInstall`.
- Update external tools: `:MasonToolsUpdate`.

Neovim writes `~/.config/nvim/nvim-pack-lock.json` locally. Home Manager links
the Lua files individually (`recursive = true`), leaving this generated lockfile
writable. Keep a backup of it to preserve exact plugin revisions; it is not
currently tracked by this repository.

Nix supplies Tree-sitter and all its grammars together, so update them with the
Nix configuration rather than `:TSUpdate` or `vim.pack`.

The previous plugin directory (`~/.local/share/nvim/lazy`) and `lazy-lock.json`
are no longer used. They can be removed after verifying the new setup.
