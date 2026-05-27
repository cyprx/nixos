# nix-darwin

Multi-machine Nix configuration (NixOS, nix-darwin, NixOS-WSL) sharing one Home Manager profile.

## Hosts

| Host      | System          | Module                    | HM profile          |
| --------- | --------------- | ------------------------- | ------------------- |
| `cynixos` | `x86_64-linux`  | `hosts/nixos/default.nix` | `home/nixos.nix`    |
| `cymacos` | `aarch64-darwin`| `hosts/mac/default.nix`   | `home/darwin.nix`   |
| `cywsl`   | `x86_64-linux`  | `hosts/wsl/default.nix`   | `home/wsl.nix`      |

Shared HM config: `home/common.nix` (shell, editors, kitty, git, fonts, ...).

## First-time setup

`identity.nix` holds per-host `{ username, homeDirectory }` and is **not committed**.

```sh
cp identity.nix.example identity.nix
# edit identity.nix with your real usernames

# Make the file visible to the flake but invisible to git:
git add --intent-to-add identity.nix
git update-index --skip-worktree identity.nix
```

To intentionally edit and commit it later:

```sh
git update-index --no-skip-worktree identity.nix
# edit + commit, then re-hide:
git update-index --skip-worktree identity.nix
```

## Rebuild

The `nix-re` fish alias auto-selects the right command per platform:

- macOS: `sudo darwin-rebuild switch --flake ~/workplace/nix-darwin#cymacos`
- NixOS / WSL: `sudo nixos-rebuild switch --flake /etc/nixos`

First-time bootstrap on macOS (before the alias exists):

```sh
sudo /run/current-system/sw/bin/darwin-rebuild switch \
  --flake ~/workplace/nix-darwin#cymacos
exec fish
```

## Layout

```
flake.nix              # inputs + per-host outputs, loads identity.nix
identity.nix           # (skip-worktree) per-host usernames
hosts/
  common.nix
  nixos/               # cynixos system config (+ nvidia, vpn, hw)
  mac/                 # cymacos system config
  wsl/                 # cywsl system config
home/
  common.nix           # shared HM config (imported by darwin.nix, wsl.nix)
  nixos.nix            # cynixos HM profile (not yet importing common)
  darwin.nix           # cymacos HM profile
  wsl.nix              # cywsl HM profile
apps/nvim/             # shared neovim module
overlays/              # package overlays (slack, claude, ...)
```

> Note: `home/nixos.nix` is still self-contained and duplicates much of
> `home/common.nix`. Follow-up: import `./common.nix` and use
> `lib.mkForce` to override the kitty font, helix theme, EDITOR, fish
> aliases, etc.

## Notes

- `darwin-rebuild` requires `sudo` for activation in recent nix-darwin.
- The mac hostname (`VNM-CYNGUYEN`) doesn't match the flake key, so `#cymacos` is passed explicitly.
- Do not run `sudo git ...` inside this repo — it creates root-owned objects in `.git/`. If it happens: `sudo chown -R "$USER":staff .git`.
