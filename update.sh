if [ "$EUID" -ne 0 ]; then
	echo "Please run as root"
	exit 1
fi

USER_HOME=$(eval echo ~$SUDO_USER)
SUCCESS="(˶ᵔ ᵕ ᵔ˶)"

if [ ! -d "./.config" ]; then
	printf "Where did the repo's .config file go (ó﹏ò｡)\nCreating a new one ദ്ദി( • ᴗ - ) ✧\n"
	mkdir .config
fi

# Hyprland dotfiles (Hyprland itself and widgets/components/utilities)

if [ -d "$USER_HOME/.config/hypr" ]; then
	cp -r "$USER_HOME/.config/hypr/" ./.config
	echo "$SUCCESS Hypr updated"
else
	echo "Could not find hypr folder"
fi

if [ -d "$USER_HOME/.config/waybar" ]; then
	cp -r "$USER_HOME/.config/waybar" ./.config
	echo "$SUCCESS Waybar updated"
fi

# Terminal dotfiles (For terminal stuff like kitty, starship, neofetch)

if [ -d "$USER_HOME/.config/kitty" ]; then
	cp -r "$USER_HOME/.config/kitty/" ./.config
	echo "$SUCCESS Kitty updated"
else
	echo "Could not find kitty folder"
fi

if [ -f "$USER_HOME/.config/starship.toml" ]; then
	cp "$USER_HOME/.config/starship.toml" ./.config
else
	echo "Could not find starship file"
fi

if [ -d "$USER_HOME/.config/fastfetch/" ]; then
	cp -r "$USER_HOME/.config/fastfetch/" ./.config
	echo "$SUCCESS Fastfetch updated"
else
	echo "Could not find fastfetch folder"
fi

if [ -d "$USER_HOME/.config/eww/" ]; then
	cp -r "$USER_HOME/.config/eww" ./.config
	echo "$SUCCESS Eww updated"
else
	echo "Could not find eww folder"
fi

if [ -d "$USER_HOME/.config/rofi/" ]; then
	cp -r "$USER_HOME/.config/rofi" ./.config
	echo "$SUCCESS Rofi updated"
else
	echo "Could not find rofi folder"
fi

# Changes ownership to YOU. Yes, you. ദ്ദി( • ᴗ - ) ✧

chown -R $(whoami):$(whoami) ./.config
chmod -R u+rw ./.config
