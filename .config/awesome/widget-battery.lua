-------------------------------------------------
-- Battery Widget for Awesome Window Manager
-- Shows the battery status using the ACPI tool
-- More details could be found here:
-- https://github.com/streetturtle/awesome-wm-widgets/tree/master/battery-widget

-- @author Pavel Makhov
-- @copyright 2017 Pavel Makhov

-- **********************************************
-- Modified so all arguments are simply hardcoded, not passed when widget is created
-- Level widget has been removed, using icon only
-- Low battery level warning removed
-------------------------------------------------

local awful = require("awful")
local naughty = require("naughty")
local watch = require("awful.widget.watch")
local wibox = require("wibox")
local dpi = require('beautiful').xresources.apply_dpi

local battery_widget = {}
local function worker(user_args)
    local args = user_args or {}

    local path_to_icons = "/usr/share/icons/Arc/status/symbolic/"
    local margin_left = 6
    local margin_right = 6

    local display_notification = false
    local display_notification_onClick = true
    local position = "top_right"
    local timeout = 10

    local icon_widget = wibox.widget {
        {
            id = "icon",
            widget = wibox.widget.imagebox,
            resize = false
        },
        valigh = 'center',
        layout = wibox.container.place,
    }

    battery_widget = wibox.widget {
        icon_widget,
        layout = wibox.layout.fixed.horizontal,
    }

    -- Popup with battery info
    local notification
    local function show_battery_status(batteryType)
        awful.spawn.easy_async([[bash -c 'acpi']],
        function(stdout, _, _, _)
            naughty.destroy(notification)
            notification = naughty.notify{
                text =  stdout,
                title = "Battery status",
                icon = path_to_icons .. batteryType .. ".svg",
                icon_size = dpi(16),
                position = position,
                timeout = 5, hover_timeout = 0.5,
                width = 200,
                screen = mouse.screen
            }
        end
        )
    end

    local last_battery_check = os.time()
    local batteryType = "battery-good-symbolic"

    watch("acpi -i", timeout,
    function(widget, stdout)
        local battery_info = {}
        local capacities = {}
        for s in stdout:gmatch("[^\r\n]+") do
            local status, charge_str, _ = string.match(s, '.+: (%a+), (%d?%d?%d)%%,?(.*)')
            if status ~= nil then
                table.insert(battery_info, {status = status, charge = tonumber(charge_str)})
            else
                local cap_str = string.match(s, '.+:.+last full capacity (%d+)')
                table.insert(capacities, tonumber(cap_str))
            end
        end

        local capacity = 0
        for _, cap in ipairs(capacities) do
            capacity = capacity + cap
        end

        local charge = 0
        local status
        for i, batt in ipairs(battery_info) do
            if capacities[i] ~= nil then
                if batt.charge >= charge then
                    status = batt.status -- use most charged battery status
                    -- this is arbitrary, and maybe another metric should be used
                end

                charge = charge + batt.charge * capacities[i]
            end
        end
        charge = charge / capacity

        if (charge >= 0 and charge < 15) then
            batteryType = "battery-empty%s-symbolic"
            if enable_battery_warning and status ~= 'Charging' and os.difftime(os.time(), last_battery_check) > 300 then
                -- if 5 minutes have elapsed since the last warning
                last_battery_check = os.time()

                show_battery_warning()
            end
        elseif (charge >= 15 and charge < 40) then batteryType = "battery-caution%s-symbolic"
        elseif (charge >= 40 and charge < 60) then batteryType = "battery-low%s-symbolic"
        elseif (charge >= 60 and charge < 80) then batteryType = "battery-good%s-symbolic"
        elseif (charge >= 80 and charge <= 100) then batteryType = "battery-full%s-symbolic"
        end

        if status == 'Charging' then
            batteryType = string.format(batteryType, '-charging')
        else
            batteryType = string.format(batteryType, '')
        end

        widget.icon:set_image(path_to_icons .. batteryType .. ".svg")
    end,
    icon_widget)

    
    if display_notification then
        battery_widget:connect_signal("mouse::enter", function() show_battery_status(batteryType) end)
        battery_widget:connect_signal("mouse::leave", function() naughty.destroy(notification) end)
    elseif display_notification_onClick then
        battery_widget:connect_signal("button::press", function(_,_,_,button)
            if (button == 3) then show_battery_status(batteryType) end
        end)
        battery_widget:connect_signal("mouse::leave", function() naughty.destroy(notification) end)
    end
    
    return wibox.container.margin(battery_widget, margin_left, margin_right)
end

return setmetatable(battery_widget, { __call = function(_, ...) return worker(...) end })
