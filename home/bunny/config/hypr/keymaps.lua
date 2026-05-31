local globals = require "globals".programs
local mainMod = "SUPER"

-- Screenshots
hl.bind("SUPER + SHIFT + Print", hl.dsp.exec_cmd "hyprshot --freeze -m region --clipboard-only", { locked = true })
hl.bind("Print", hl.dsp.exec_cmd "hyprshot -m window --clipboard-only", { locked = true })

-- Apps
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(globals.fileManager))
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(globals.terminal))
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd(globals.appLauncher))

-- Window management
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + J", hl.dsp.layout "togglesplit")
hl.bind(mainMod .. " + V", hl.dsp.window.float { action = "toggle" })

-- Move focus (WASD)
hl.bind(mainMod .. " + A", hl.dsp.focus { direction = "left" })
hl.bind(mainMod .. " + D", hl.dsp.focus { direction = "right" })
hl.bind(mainMod .. " + W", hl.dsp.focus { direction = "up" })
hl.bind(mainMod .. " + S", hl.dsp.focus { direction = "down" })

-- Move windows (arrow keys)
hl.bind(mainMod .. " + left", hl.dsp.window.move { direction = "left" })
hl.bind(mainMod .. " + right", hl.dsp.window.move { direction = "right" })
hl.bind(mainMod .. " + up", hl.dsp.window.move { direction = "up" })
hl.bind(mainMod .. " + down", hl.dsp.window.move { direction = "down" })

-- Switch / move to workspaces
for i = 1, 10 do
  local key = i % 10 -- 10 maps to key 0
  hl.bind(mainMod .. " + " .. key, hl.dsp.focus { workspace = i })
  hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move { workspace = i })
end

-- Scroll through workspaces
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus { workspace = "e+1" })
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus { workspace = "e-1" })

-- Move/resize with mouse
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Lid switch
hl.bind("switch:Lid Switch", hl.dsp.exec_cmd "", { locked = true })
