ARCHIVE="https://archive.archlinux.org/packages"
HYPRLAND="h/hyprland/hyprland-0.46.2-9-x86_64.pkg.tar.zst"
QTUTILS="h/hyprland-qtutils/hyprland-qtutils-0.1.3-3-x86_64.pkg.tar.zst"
HYPRLANG="h/hyprlang/hyprlang-0.6.0-4-x86_64.pkg.tar.zst"
HYPRUTILS="h/hyprutils/hyprutils-0.4.0-1-x86_64.pkg.tar.zst"
HYPRGRAPH="h/hyprgraphics/hyprgraphics-0.1.1-5-x86_64.pkg.tar.zst"
AQUAMARINE="a/aquamarine/aquamarine-0.7.1-2-x86_64.pkg.tar.zst"

FOLDER_PATH="/tmp/hyprland-0-46-2"

mkdir $FOLDER_PATH
cd $FOLDER_PATH/

echo "Downloading packages from Arch(ive)"
curl -O "$ARCHIVE/$HYPRLAND" \
     -O "$ARCHIVE/$QTUTILS" \
     -O "$ARCHIVE/$HYPRLANG" \
     -O "$ARCHIVE/$HYPRUTILS" \
     -O "$ARCHIVE/$HYPRGRAPH" \
     -O "$ARCHIVE/$AQUAMARINE"

FILES=$(echo $FOLDER_PATH/*)

echo "Installing packages . . ."
sudo pacman -U --noconfirm $FILES

rm -rf $FOLDER_PATH
