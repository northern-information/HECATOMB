local mod = require 'core/mods'

version = "0.0.2"

local state = {
  last_script = nil,
  flag = "..."
}





-- HECATOMB HOOKS

mod.hook.register("system_post_startup", "HECATOMB POST-STARTUP", function()
  print("HECATOMB POST-STARTUP")
  pull_cci()
end)

mod.hook.register("system_pre_shutdown", "HECATOMB PRE-SHUTDOWN", function()
  print("HECATOMB PRE-SHUTDOWN")
end)

mod.hook.register("script_pre_init", "HECATOMB PRE-INIT", function()
  print("HECATOMB PRE-INIT")
  state.last_script = norns.state.script
end)

mod.hook.register("script_post_cleanup", "HECATOMB POST-CLEANUP", function()
  print("HECATOMB POST-CLEANUP")
end)





-- HECATOMB TOOLS
function pull_cci()
  print("pulling cci from github...")
  os.execute("cd /home/we/dust/code/cci/ && git pull https://github.com/northern-information/cci.git")
  print("done.")
end

function screenshot()
  _norns.screen_export_png("/home/we/dust/HECATOMB-screenshot-" .. os.time() .. ".png")
end

function rerun(safe)
  local script = (safe ~= nil) and norns.state.script or state.last_script
  if script ~= nil and script ~= "" then
    norns.script.load(script)
  else
    print("HECATOMB DID NOT FIND SCRIPT TO RELOAD!")
  end
end

function run(script)
  norns.script.load("/home/we/dust/code/" .. script .. "/" .. script .. ".lua")
end

function r(safe)
  rerun(safe)
end

function rage()
  -- the "right" way to restart the whole stack
  _norns.reset()
end


-- HECATOMB SYSTEM MENU

local m = {}

m.key = function(n, z)
  if z == 0 then return end
  if n == 2 then mod.menu.exit() end
  if n == 3 then
    state.flag = "~~~"
    m.redraw()
    pull_cci()
    state.flag = "OK!"
    m.redraw()
  end
end

m.enc = function(n, d)
  print("HECATOMB ENCS UNUSED", n, d)
  mod.menu.redraw()
end

m.redraw = function()
  screen.clear()
  screen.display_png("/home/we/dust/code/hecatomb/hecatomb.png", 0, 0)
  screen.move(72,8)
  screen.text("HECATOMB")
  screen.move(72,16)
  screen.text("v" .. version)
  screen.move(72,24)
  screen.text("CCI.AUTO.UP")
  screen.move(72,32)
  screen.text(state.flag)
  screen.move(72,48)
  screen.text("K2: EXIT ")
  screen.move(72,56)
  screen.text("K3: UPDATE")
  screen.update()
end

m.init = function()
  print("HECATOMB ONLINE.")
end

m.deinit = function()
  print("HECATOMB OFFLINE.")
end

mod.menu.register(mod.this_name, m)