# Dotfiles — NixOS + Home Manager (Flakes)

Configuracao declarativa do meu sistema NixOS `bunny` (laptop NVIDIA Optimus).

```
dotfiles/
├── flake.nix              # Entry point: inputs, outputs, overlays
├── flake.lock             # Pinned versions of all inputs
├── hosts/bunny/           # NixOS system configuration
│   ├── configuration.nix  # Kernel, boot, hardware, networking, fonts, flatpak, docker
│   └── hardware-configuration.nix
├── home/bunny/            # Home Manager user configuration
│   ├── home.nix           # User packages, env vars, dotfile symlinks
│   ├── programs/          # Per-program modules (zsh, kitty, neovim, rofi, starship, fastfetch)
│   ├── config/            # Dotfile sources (hypr, nvim, btop, mako, yazi, quickshell)
│   └── assets/
├── modules/
│   ├── system/            # System-level modules
│   └── services/          # SDDM theme, NBFC (fan control)
├── packages/              # Custom package definitions (SDDM theme)
└── lib/                   # Helpers (rebuild script, palette loader)
```

## Stack

| Categoria       | Ferramenta                                  |
| --------------- | ------------------------------------------- |
| WM              | Hyprland                                    |
| Barra / Widgets | Quickshell                                  |
| Launcher        | Vicinae (Rofi)                              |
| Terminal        | Kitty                                       |
| Shell           | Zsh + Starship                              |
| Editor          | Neovim (nightly, config via Lazyman)        |
| DM              | SDDM (tema customizado R1999_1)             |
| Navegadores     | Vivaldi, Chromium, Zen Browser, Firefox     |
| Notas           | Siyuan                                      |
| Containers      | Docker (rootless, dados em /mnt/hdd/docker) |
| Input           | fcitx5 (chines), layout ABNT2               |

## Atualizar o sistema

O sistema usa **flakes** com dois canais do nixpkgs:

- `nixpkgs` (`nixos-26.05`) — canais estavel, usado pela maioria dos pacotes
- `nixpkgs-unstable` (`nixos-unstable`) — usado apenas para pacotes especificos que preciso de versoes mais recentes

```bash
# Atualizar TUDO (puxa novos commits de todos os inputs)
nix flake update
rebuild

# Atualizar apenas o canal estavel
nix flake lock --update-input nixpkgs
rebuild

# Atualizar apenas o canal unstable (ex: so atualizar o Siyuan)
nix flake lock --update-input nixpkgs-unstable
rebuild
```

**Importante:** O comando `rebuild` (definido em `lib/default.nix`) equivale a `nixos-rebuild switch --flake ~/dotfiles#bunny`. Rode com `sudo` se necessario.

## GPU (NVIDIA Optimus)

- Intel iGPU + NVIDIA dGPU em modo Prime Sync
- Driver NVIDIA branch 580 (legacy)

## Estrutura de disco

| Montagem  | Dispositivo | Proposito       |
| --------- | ----------- | --------------- |
| `/`       | SSD NVMe    | Sistema         |
| `/mnt/hdd` | HDD SATA   | Dados, Docker, /home/code |
