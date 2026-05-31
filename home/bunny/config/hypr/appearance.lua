local a = require "globals".appearance

hl.config {
  cursor = {
    enable_hyprcursor   = true,
    no_hardware_cursors = true,
  },

  general = {
    gaps_in          = a.gap_in,
    gaps_out         = a.gap_out,
    border_size      = a.border_size,

    col              = {
      active_border   = ("rgb(%s)"):format(a.active_border),
      inactive_border = ("rgb(%s)"):format(a.inactive_border),
    },

    resize_on_border = false,
    allow_tearing    = false,
    layout           = "dwindle",
  },

  decoration = {
    rounding         = a.rounding,
    active_opacity   = 1.0,
    inactive_opacity = 1.0,

    shadow           = {
      enabled      = false,
      range        = 4,
      render_power = 3,
      color        = 0xee1a1a1a,
    },

    blur             = {
      enabled  = true,
      size     = 3,
      passes   = 1,
      vibrancy = 0.1696,
    },
  },

  dwindle = {
    preserve_split = true,
  },

  master = {
    new_status = "master",
  },

  misc = {
    vrr                     = 0,
    force_default_wallpaper = -1,
    disable_hyprland_logo   = false,
  },

  animations = {
    enabled = true,
  },
}

-- Bezier curves
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1.0 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

-- Animations
hl.animation { leaf = "global", enabled = true, speed = 10, bezier = "default" }
hl.animation { leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" }
hl.animation { leaf = "windows", enabled = true, speed = 4.79, bezier = "easeOutQuint" }
hl.animation { leaf = "windowsIn", enabled = true, speed = 4.1, bezier = "easeOutQuint", style = "popin 87%" }
hl.animation { leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" }
hl.animation { leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" }
hl.animation { leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" }
hl.animation { leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" }
hl.animation { leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" }
hl.animation { leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" }
hl.animation { leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" }
hl.animation { leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" }
hl.animation { leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" }
hl.animation { leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" }
hl.animation { leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" }
hl.animation { leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" }
