require "appearance"
require "window_rules"
require "keymaps"

-- eDP-1 (laptop screen) disabled, using external monitor only
hl.monitor { output = "eDP-1", disabled = true }
hl.monitor { output = "HDMI-A-1", mode = "1920x1080@60.00Hz", position = "0x0", scale = 1 }

local statusbar = "quickshell -p ~/.config/quickshell"

-- Startup
hl.on("hyprland.start", function()
  hl.exec_cmd "mako"
  hl.exec_cmd "fcitx5 -d"
  hl.exec_cmd "awww-daemon"
  hl.exec_cmd "vicinae server"
  hl.exec_cmd "quickshell -p ~/.config/quickshell"
  hl.exec_cmd "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
end)

hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("HYPRCURSOR_SIZE", "17")
hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("XCURSOR_SIZE", "17")

hl.config {
  input = {
    kb_layout    = "br,cn",
    kb_options   = "grp:alt_space_toggle",
    kb_variant   = "",
    kb_model     = "",
    kb_rules     = "",

    follow_mouse = 1,
    sensitivity  = 0,

    touchpad     = {
      natural_scroll = false,
    },
  },
}

hl.device {
  name        = "epic-mouse-v1",
  sensitivity = -0.5,
}
