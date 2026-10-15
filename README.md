# Dotfiles — NixOS + Home Manager (Flakes)

Configuracao declarativa das minhas maquinas NixOS:

| Host     | Maquina                                         | Papel                      |
| -------- | ----------------------------------------------- | -------------------------- |
| `bunny`  | Desktop Ryzen 5 7600 (iGPU, Radeon no futuro)   | Dev web + jogos (Hyprland) |
| `server` | Notebook Acer Nitro AN515-51                    | Home-server headless (SSH) |

```
dotfiles/
├── flake.nix              # Entry point: inputs, overlays, mkHost <host> <perfil home>
├── flake.lock             # Pinned versions of all inputs
├── hosts/
│   ├── bunny/             # Desktop: hostname, stateVersion, hardware-configuration.nix
│   └── server/            # Notebook: hostname, tampa, GPU desligada, docker no HDD
├── home/bunny/            # Home Manager (mesmo usuario nas duas maquinas)
│   ├── common.nix         # Terminal: zsh, starship, neovim, fastfetch, CLI tools
│   ├── desktop.nix        # common + Hyprland, apps GUI, dev, jogos
│   ├── server.nix         # common (so terminal)
│   ├── programs/          # Per-program modules (zsh, kitty, neovim, rofi, starship, fastfetch)
│   ├── config/            # Dotfile sources (hypr, nvim, btop, mako, yazi, quickshell)
│   └── assets/
├── modules/
│   ├── common/            # Base de todas as maquinas: nix, usuario, boot, locale, rede, docker
│   ├── desktop/           # Hyprland, greetd, audio, Steam, fcitx5, flatpak, warp, hosts de dev
│   ├── server/            # SSH (so chave), avahi, sem suspensao, nbfc (fan do Acer)
│   └── hardware/          # Drivers por hardware (amd.nix)
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

**Importante:** O comando `rebuild` (definido em `lib/default.nix`) equivale a `nixos-rebuild switch --flake ~/dotfiles#<host>`, com o host em que foi instalado. Rode com `sudo` se necessario.

## Server

Acesso a partir do desktop: `ssh server` (resolve `bunny-home-server.local` via avahi, login so por chave).

```bash
# Aplicar a config do server a partir do desktop
nixos-rebuild switch --flake ~/dotfiles#server --target-host server --sudo --ask-sudo-password
```

## GPU

- **Desktop:** AMD (amdgpu + Mesa/RADV). iGPU agora; uma Radeon dedicada funciona sem mudar a config.
- **Server:** GTX 1050 removida do barramento PCI (sem uso, economiza energia).

## Estrutura de disco

| Host     | Montagem     | Dispositivo | Proposito             |
| -------- | ------------ | ----------- | --------------------- |
| `bunny`  | `/`          | SSD NVMe    | Sistema               |
| `server` | `/`          | SSD NVMe    | Sistema               |
| `server` | `/mnt/hdd`   | HDD (USB)   | Dados, Docker         |
| `server` | `/mnt/exssd` | SSD SATA    | Livre                 |
