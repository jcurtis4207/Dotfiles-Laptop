------------------
--              --
-- Client Rules --
--              --
------------------

-- Import required modules
local awful = require("awful")
local gears = require("gears")
local bindings = require("bindings")
local beautiful = require("beautiful")

-- Apply theme to new clients
beautiful.init(gears.filesystem.get_configuration_dir() .. "/themes/default/theme.lua")

-- Rules to apply to new clients (through the "manage" signal).
local rules = {
    -- All clients will match this rule.
    { 
		rule = { },
		properties = { 
					border_width = beautiful.border_width,
                    border_color = beautiful.border_normal,
                    focus = awful.client.focus.filter,
                    raise = true,
                    maximized = false,
                    keys = bindings.keyboard.client,
                    buttons = bindings.mouse.client,
                    screen = awful.screen.preferred,
                    placement = awful.placement.no_overlap+awful.placement.no_offscreen
		}
    },

    -- Don't add titlebars to normal clients and dialogs
    {
		rule_any = {
			type = { "normal", "dialog" }
		}, 
		properties = { titlebars_enabled = false }
    },
}

return rules
