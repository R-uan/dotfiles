-- VS Code: slight transparency
hl.window_rule {
  name    = "vscode-opacity",
  match   = { class = "^(code)$" },
  opacity = "0.95",
}

-- Ignore maximize requests from all apps
hl.window_rule {
  name           = "suppress-maximize-events",
  match          = { class = ".*" },
  suppress_event = "maximize",
}

-- Fix XWayland dragging issues
hl.window_rule {
  name     = "fix-xwayland-drags",
  match    = {
    class      = "^$",
    title      = "^$",
    xwayland   = true,
    float      = true,
    fullscreen = false,
    pin        = false,
  },
  no_focus = true,
}

-- Rofi is a layer surface, not a window: blur what shows through its
-- translucent background (themes/theme.rasi uses #151515e6).
hl.layer_rule {
  name         = "rofi-blur",
  match        = { namespace = "^(rofi)$" },
  blur         = true,
  ignore_alpha = 0.2,
}
