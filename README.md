# Dotfiles — NixOS + Home Manager (Flakes)

Configuracao declarativa do meu sistema NixOS `bunny` (desktop Ryzen 5 7600 + Radeon RX 7600).

## Hardware

| Componente     | Modelo                                          | Driver no NixOS                         |
| -------------- | ----------------------------------------------- | --------------------------------------- |
| Processador    | AMD Ryzen 5 7600 (6 nucleos, 3.8 GHz)           | `kvm-amd` + microcode AMD               |
| Placa-mae      | MSI PRO B840M-P WIFI6E (Micro ATX, AM5)         | Kernel padrao                           |
| ↳ Rede         | Realtek RTL8125D 2.5 GbE                        | `r8169` (kernel 6.13+)                  |
| ↳ Wi-Fi / BT   | Wi-Fi 6E + Bluetooth 5.3                        | Kernel + `hardware.enableAllFirmware`   |
| Memoria        | ADATA XPG Lancer Blade RGB 8 GB DDR5-5600 (1x8) | -                                       |
| Placa de video | ASRock Radeon RX 7600 Challenger 8 GB           | `amdgpu` + Mesa (RADV)                  |
| Fonte          | XPG Core Reactor II VE 750 W (80+ Gold)         | -                                       |
| Gabinete       | Mancer CV100 (Micro ATX)                        | -                                       |
| Monitor        | LG UltraGear 24" 1920x1080 144 Hz               | -                                       |

Problemas conhecidos de hardware e solucoes: [KNOWN_ISSUES.md](KNOWN_ISSUES.md)

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
│   └── services/          # SDDM theme, greetd
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

**Instalacao nova:** `hosts/bunny/hardware-configuration.nix` e um placeholder (labels `nixos` e `boot`). No primeiro uso, `sudo nix run ~/dotfiles#rebuild` copia o `/etc/nixos/hardware-configuration.nix` gerado pelo instalador para o repo (e faz `git add`), depois e so commitar.

## GPU

- Radeon RX 7600 com `amdgpu` + Mesa (RADV para Vulkan, VA-API para video)
- A iGPU do Ryzen usa o mesmo driver, sem config extra. `amdgpu` carrega no initrd (`hardware.amdgpu.initrd.enable`)

## Estrutura de disco

| Montagem  | Dispositivo | Proposito       |
| --------- | ----------- | --------------- |
| `/`       | SSD NVMe    | Sistema         |
| `/mnt/hdd` | HDD SATA   | Dados, Docker, /home/code |
