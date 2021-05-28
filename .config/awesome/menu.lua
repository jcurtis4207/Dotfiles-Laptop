--------------------
--                --
-- Menu and Panel --
--                --
--------------------

--[[ IMPORTS ]]--

-- Standard library
local awful = require("awful")
local gears = require("gears")
-- Theme
local beautiful = require("beautiful")
-- Menu
local menubar = require("menubar")
local freedesktop = require("freedesktop")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Panel
local wibox = require("wibox")

-- Apply theme to panel and menu
beautiful.init(gears.filesystem.get_configuration_dir() .. "/themes/default/theme.lua")

--[[ LAYOUTS ]]--
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.fair,
}

--[[ MENU ]]--

-- Set the terminal for applications that require it
terminal = "alacritty"
menubar.utils.terminal = terminal

-- Menu Entry for Awesome
awesome_submenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

-- Create Main Menu
main_menu = freedesktop.menu.build({
        before = { { "Awesome", awesome_submenu, beautiful.awesome_icon } },
        after = { { "Open terminal", terminal } }
})

-- Create Menu Button
menu_button = awful.widget.launcher({
	image = beautiful.awesome_icon,
	menu = main_menu 
})


--[[ WIDGETS ]]--

-- Text Clock and Date
textclock_widget = wibox.widget.textclock("  %a %b %d, %I:%M   ")
-- Battery
beautiful.tooltip_fg = beautiful.fg_normal
beautiful.tooltip_bg = beautiful.bg_normal
local battery_widget = require("widget-battery")
-- Volume
local volume_alsa = require("widget-volume")
-- Wifi
local wifi_widget = require("widget-wifi")

--[[ PANEL ]]--

-- Leftclick on taglist (workspaces)
local taglist_buttons = gears.table.join(
	awful.button({ }, 1, function(t) t:view_only() end)
)

-- Leftclick on tasklist (taskbar)
local tasklist_buttons = gears.table.join(
	awful.button({ }, 1, function (c)
		if c == client.focus then
			c.minimized = true
		else
			c:emit_signal(
				"request::activate",
				"tasklist",
				{raise = true}
			)
		end
	end)
)

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

-- For each screen, set up panel (wibox)
awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "1", "2" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.prompt_box = awful.widget.prompt()
    
    -- Create an imagebox widget with an icon indicating the layout for each screen
    s.layout_box = awful.widget.layoutbox(s)

    -- Create a taglist widget - workspace selector
    s.tag_list = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create a tasklist widget - taskbar windows
    s.task_list = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }

    -- Create the panel (wibox)
    s.panel = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the panel (wibox)
    s.panel:setup {
        layout = wibox.layout.align.horizontal,
        -- Left Widgets
        {
            layout = wibox.layout.fixed.horizontal,
            menu_button,
            s.tag_list,
            s.prompt_box,
        },
        -- Middle Widget
        s.task_list,
        -- Right Widgets
        {
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
            battery_widget(),
            volume_alsa(),
            wifi_widget,
            textclock_widget,
            s.layout_box,
        },
    }
end)

-- Pass default terminal to other modules
return terminal
