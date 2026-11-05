{pkgs, ...}: {
  home.packages = with pkgs; [
    ## Nix
    nil       # Language Server
    deadnix   # Finds unused code (dead let bindings, arguments)
    alejandra # Code Formatter

    ## Lua
    lua-language-server # Language Server
    (lua52Packages.lua.withPackages (ps: with ps; [luafilesystem]))

    ## Rust
    rustc         # Compiler
    cargo         # Build tool / package manager
    clippy        # Linter (cargo clippy)
    rustfmt       # Code Formatter (cargo fmt)
    rust-analyzer # Language Server

    ## C / C++
    gcc         # Compiler (gcc / g++)
    gnumake     # make
    cmake       # Build system generator
    pkg-config  # Finds library flags for builds
    gdb         # Debugger
    clang-tools # clangd (Language Server), clang-format, clang-tidy

    ## PHP
    php

    ## JavaScript
    nodejs

    ## AI agents
    opencode    # Open Source AI Agent (Deepseek)
    claude-code # Claude

    ## Tools
    bruno       # API Client
    chromium    # For testing web apps
    dbeaver-bin # Database Manager

    ## Code Editors
    vscode-fhs
  ];
}
