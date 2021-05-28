-------------------------
--                     --
-- Main Awesome Config --
--                     --
-------------------------

--[[ IMPORTS ]]--

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Theme
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi
-- Notifications
local naughty = require("naughty")
-- User Modules
local bindings = require("bindings")
local rules = require("rules")
local menu = require("menu")
terminal = menu -- Passes default terminal from menu module


--[[ ERROR HANDLING ]]--

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end


--[[ THEME ]]--
beautiful.init(gears.filesystem.get_configuration_dir() .. "/themes/default/theme.lua")


--[[ SIGNALS ]]--

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)


--[[ Set User Bindings, Rules, and Autostart ]]--

root.buttons(bindings.mouse.global)
root.keys(bindings.keyboard.global)
awful.rules.rules = rules
awful.spawn.with_shell("/home/jacob/.config/awesome/autorun.sh")
