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

chown -R 777 ./.config

# desktop environment dotfiles (Compositors, app launchers, status bars)

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

if [ -d "$USER_HOME/.config/rofi/" ]; then
	cp -r "$USER_HOME/.config/rofi" ./.config
	echo "$SUCCESS Rofi updated"
else
	echo "Could not find rofi folder"
fi

# terminal dotfiles (For terminal stuff like kitty, starship, zsh)

if [ -d "$USER_HOME/.config/kitty" ]; then
	cp -r "$USER_HOME/.config/kitty/" ./.config
	echo "$SUCCESS Kitty updated"
else
	echo "Could not find kitty folder"
fi

if [ -f "$USER_HOME/.config/starship.toml" ]; then
	cp "$USER_HOME/.config/starship.toml" ./.config
  	echo "$SUCCESS Starship updated"
else
	echo "Could not find starship file"
fi

if [ -d "$USER_HOME/.config/fastfetch/" ]; then
	cp -r "$USER_HOME/.config/fastfetch/" ./.config
	echo "$SUCCESS Fastfetch updated"
else
	echo "Could not find fastfetch folder"
fi

if [ -f "$USER_HOME/.zshrc" ]; then
	cp "$USER_HOME/.zshrc" .
	echo "$SUCCESS Zshrc updated"
else
	echo "Could not find zshrc file"
fi

if [ -d "$USER_HOME/.config/helix" ]; then
	cp -r "$USER_HOME/.config/helix" "./.config"
	echo "$SUCCESS Helix updated"
else
	echo "Could not find helix folder"
fi

if [ -f "/etc/environment" ]; then
    cp "/etc/environment" ./etc/
    echo "$SUCCESS Environment updated"
fi


# System applications (Mako)

if [ -d "$USER_HOME/.config/mako" ]; then
	cp -r "$USER_HOME/.config/mako" ./.config
	echo "$SUCCESS Mako updated"
else
	echo "Could not find mako folder"
fi

# Changes ownership to YOU. Yes, you. ദ്ദി( • ᴗ - ) ✧

chown -R 777 ./.config
