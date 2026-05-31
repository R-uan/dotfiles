local M      = {}
-- Programs
M.programs   = {
  terminal    = "kitty",
  fileManager = "dolphin",
  appLauncher = "vicinae toggle",
}

-- Appearance
M.appearance = {
  active_opacity   = "0.95",
  inactive_opacity = M.active_opacity,

  active_border    = "7a9b7f",
  inactive_border  = "3d4a34",

  gap_in           = 4,
  gap_out          = 4,
  border_size      = 1,
  rounding         = 12,
}

return M;
