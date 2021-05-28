---------------------------
--                       --
-- Mouse and Keybindings --
--                       --
---------------------------

-- Import required modules
local gears = require("gears")
local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
local volume_alsa = require("widget-volume")

-- Define global modkey
-- Without this, modkey will work inversely
local modkey = "Mod4"

-- Create output structure
local bindings = {
    modkey = modkey,
}


--[[ MOUSE BINDINGS ]]--

bindings.mouse = {
	-- Middle click activates menu
    global = gears.table.join(
        awful.button({ }, 3, function () main_menu:toggle() end)
    ),
    -- Leftclick, Mod+Leftclick, Mod+Rightclick activates client focus
    client = gears.table.join(
        awful.button({ }, 1, function (c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
        end),
        awful.button({ modkey }, 1, function (c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ modkey }, 3, function (c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )
}

--[[ KEY BINDINGS ]]--

bindings.keyboard = {
	global = gears.table.join(
		-- Show all keybindings
		awful.key({ modkey }, "s", hotkeys_popup.show_help,
				  {description="show help", group="awesome"}),

		-- Focus manipulation
		awful.key({ modkey }, "h", function () awful.client.focus.byidx( 1) end,
				  {description = "focus next window", group = "client"}),
		awful.key({ modkey }, "j", function () awful.client.focus.byidx(-1) end,
				  {description = "focus previous window", group = "client"}),

		-- Layout manipulation
		awful.key({ modkey }, "l", function () awful.client.swap.bydirection("left") end,
				  {description = "swap with client to the left", group = "client"}),
		awful.key({ modkey }, "'", function () awful.client.swap.bydirection("right") end,
				  {description = "swap with client to the right", group = "client"}),
		awful.key({ modkey }, "p", function () awful.client.swap.bydirection("up") end,
				  {description = "swap with client to the top", group = "client"}),
		awful.key({ modkey }, ";", function () awful.client.swap.bydirection("down") end,
				  {description = "swap with client to the bottom", group = "client"}),

		-- Screen manipulation
		--awful.key({}, "Pause", function () awful.client.movetoscreen() end,
		--		  {description = "move client to next screen", group = "client"}),

		-- Standard program
		awful.key({ modkey, "Control" }, "r", awesome.restart,
				  {description = "reload awesome", group = "awesome"}),
		awful.key({ modkey, "Shift"   }, "q", awesome.quit,
				  {description = "quit awesome", group = "awesome"}),
		awful.key({ modkey }, "g", function () awful.layout.inc(1) end,
				  {description = "select next layout", group = "layout"}),
		awful.key({ modkey }, "Page_Up",
				  function ()
					  local c = awful.client.restore()
					  -- Focus restored client
					  if c then
						c:emit_signal(
							"request::activate", "key.unminimize", {raise = true}
						)
					  end
				  end,
				  {description = "restore minimized", group = "client"}),

	-- LAUNCHERS
		-- Terminal
		awful.key({ modkey }, "Return", function () awful.spawn(terminal) end,
				  {description = "open a terminal", group = "launcher"}),
				  
		-- SpaceFM
		awful.key({ modkey }, "e", function () awful.spawn("spacefm") end,
				  {description = "launch spacefm", group = "launcher"}),

		-- Geany
		awful.key({ modkey }, "t", function () awful.spawn("geany") end,
				  {description = "launch geany", group = "launcher"}),

		-- Firefox
		awful.key({ "Mod1", "Control" }, "n", function () awful.spawn("firefox") end,
				  {description = "launch firefox", group = "launcher"}),

		-- Firefox Private
		awful.key({ "Mod1", "Control" }, "p", function () awful.spawn("firefox -private-window") end,
				  {description = "launch firefox private", group = "launcher"}),

		-- Keepass
		awful.key({ modkey }, "k", function () awful.spawn("keepass") end,
				  {description = "launch keepass", group = "launcher"}),

		-- Discord
		awful.key({ modkey }, "d", function () awful.spawn("discord") end,
				  {description = "launch discrod", group = "launcher"}),

		-- Rofi
		awful.key({ "Control" }, "space", function () awful.spawn("rofi -show drun") end,
				  {description = "launch rofi", group = "launcher"}),
				  
    -- HOTKEYS              
		-- Snip
		awful.key({ modkey, "Shift" }, "s", function () awful.util.spawn_with_shell("sleep 0.2 && scrot -s ~/Pictures/'%Y-%m-%d_%H:%M:%S_scrot.png'") end,
				  {description = "snip screenshot", group = "hotkeys"}),

        -- Brightness Up
        awful.key({}, "XF86MonBrightnessUp", function () awful.util.spawn_with_shell("xbacklight -inc 10") end,
                  {description = "Increase Brightness", group = "hotkeys"}),

        -- Brightness Down 
        awful.key({}, "XF86MonBrightnessDown", function () awful.util.spawn_with_shell("xbacklight -dec 10") end,
                  {description = "Decrease Brightness", group = "hotkeys"}),
        
        -- Volume Up
        awful.key({}, "XF86AudioRaiseVolume", function () volume_alsa.raise(0, 'Master', 5) end,
                  {description = "Increase Volume", group = "hotkeys"}),

        -- Volume Down
        awful.key({}, "XF86AudioLowerVolume", function () volume_alsa.lower(0, 'Master', 5) end,
                  {description = "Decrease Volume", group = "hotkeys"}),

        -- Volume Mute
        awful.key({}, "XF86AudioMute", function () volume_alsa.mute(0, 'Master') end,
                  {description = "Mute Volume", group = "hotkeys"})
	),

	-- Focused client manipulation
	client = gears.table.join(
		awful.key({modkey}, "Delete", function (c) c:kill() end,
				  {description = "close window", group = "client"}),

		awful.key({ modkey, }, "Page_Down", function (c) c.minimized = true end,
				  {description = "minimize window", group = "client"})
	)
}

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 2 do
    bindings.keyboard.global = gears.table.join(bindings.keyboard.global,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

return bindings
