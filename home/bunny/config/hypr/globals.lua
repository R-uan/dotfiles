local M      = {}
-- Programs
M.programs   = {
  terminal     = "kitty",
  fileManager  = "dolphin",
  appLauncher  = "rofi -show run",
  appLauncher2 = "vicinae toggle",
}

-- Appearance
M.appearance = {
  active_opacity   = "0.95",
  inactive_opacity = M.active_opacity,

  active_border    = "6e6e6e",
  inactive_border  = "2e2e2e",

  gap_in           = 2,
  gap_out          = 2,
  border_size      = 2,
  rounding         = 12,
}

return M;
