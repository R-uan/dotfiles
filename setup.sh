set -e

echo "Proceeding with the deletion of root"

echo "Software"
sudo pacman -S --noconfirm \
    discord steam obsidian \
    nautilus btop \
    thunderbird

echo "Programming"
sudo pacman -S --noconfirm \
    git make cmake curl wget base-devel zed \
    rust go gcc gdb npm dotnet-runtime dotnet-sdk aspnet-runtime dotnet-sdk-8.0  \

yay -S visual-studio-code-bin

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash
\. "$HOME/.nvm/nvm.sh"
nvm install 22

echo "Desktop Enviroment"
source ./scripts/hyprland.sh
sudo pacman -S --noconfirm \
    kitty fastfetch \
    mako rofi-wayland waybar \
    starship ewww zsh \
    hyprshot swww \

echo "Miscellaneous"
sudo pacman -S --noconfirm \
    polkit-gnome sddm  \

yay -S nbfc-linux