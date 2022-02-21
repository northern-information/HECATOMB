local mod = require 'core/mods'

local state = {
  exegesis = "HECATOMB",
  version_major = 0,
  version_minor = 0,
  version_patch = 1,
  last_script = nil
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
  -- TODO: check whether exists first, maybe?
  norns.script.load("/home/we/dust/code/"..script.."/"..script..".lua")
end

function r(safe)
  rerun(safe)
end




-- NORNS SYSTEM MENU

local m = {}

m.key = function(n, z)
  if n == 2 and z == 1 then
    mod.menu.exit()
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
  screen.text("v" .. state.version_major .. "." .. state.version_minor .. "." .. state.version_patch)
  screen.move(72,24)
  screen.text("CCI AUTO")
  screen.move(72,32)
  screen.text("UPDATES ON")
  screen.update()
end

m.init = function()
  print("HECATOMB ONLINE.")
end

m.deinit = function()
  print("HECATOMB OFFLINE.")
end

mod.menu.register(mod.this_name, m)



-- API

local api = {}

api.get_state = function()
  return state
end

return api