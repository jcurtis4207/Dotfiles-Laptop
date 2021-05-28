--------------------------------
--                            --
--        Wifi Widget         --
--                            --
-- Displays connected network --
--   Runs connection script   --
--                            --
--------------------------------

-- Requirements
local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")

local script_path = os.getenv("HOME") .. "/Scripts/"

-- Arc Icons - https://github.com/horst3180/arc-icon-theme
local icons_path = "/usr/share/icons/Arc/status/symbolic/"

-- Margins for icon
local margin_left = 7
local margin_right = 3
local margin_top = 7

-- Create widget
local wifi_widget = wibox.widget {
    image = icons_path .. "network-wireless-connected-symbolic.svg",
    resize = false,
    widget = wibox.widget.imagebox
}

-- Popup with connected network when left clicked
local notification
local network_name
local function show_popup()
    awful.spawn.easy_async([[bash -c "nmcli -t -f name connection show --active | sed -n '1p'"]],
    function(stdout, _, _, _)
        if stdout == nil then
            network_name = '   Not Connected'
        else
            network_name = stdout
        end
        naughty.destroy(notification)
        notification = naughty.notify{
            title = "Connected Network",
            text = "\n" .. network_name .. "\nRight-click to change",
            position = "top_right",
            width = 200,
            timeout = 3,
            screen = mouse.screen
        }
    end
    )
end

-- Run wifi script when right clicked
local function run_connection_script()
    awful.util.spawn(terminal .. " -e " .. script_path .. "wifi_connect.sh", false)
end

-- Click signals
wifi_widget:connect_signal("button::press", function(_,_,_,button)
        -- Left click 
        if button == 1 then
            show_popup()
        -- Right click
        elseif button == 3 then
            run_connection_script()
        end
end)

-- Return widget with margins
return wibox.container.margin(wifi_widget, margin_left, margin_right, margin_top)
