--------------------------------
-- Author: Gregor Best        --
-- Copyright 2009 Gregor Best --
-- github.com/hoelzro/obvious --
--
-- ********************************************
-- Modified to remove mixer popup on rightclick
-- Display Mute, not level, when muted
-----------------------------------------------

local setmetatable = setmetatable
local tonumber = tonumber
local pairs = pairs
local io = {
  popen = io.popen
}
local string = {
  match  = string.match,
  find   = string.find,
  format = string.format
}
local table = {
  insert = table.insert
}
local awful = require("awful")
local wibox = require("wibox")

local volume_alsa = {}

local objects = { }

function volume_alsa.get_data(cardid, channel)
  local rv = { }
  local fd = io.popen("amixer -c " .. cardid .. " -- sget " .. channel)
  if not fd then return end
  local status = fd:read("*all")
  fd:close()

  rv.volume = tonumber(string.match(status, "(%d?%d?%d)%%"))
  if not rv.volume then
    rv.volume = ""
  end

  status = string.match(status, "%[(o[^%]]*)%]")
  if not status then status = "on" end
  if string.find(status, "on", 1, true) then
    rv.mute = false
  else
    rv.mute = true
  end

  return rv
end

local function update(obj)
  local status = volume_alsa.get_data(obj.cardid, obj.channel) or { mute = true, volume = 0 }

  local color = "#900000"
  if not status.mute then
    color = "#aaaaaa"
  end

  local text = " Mute "
  if not status.mute then
    text = " " .. status.volume..'% '
  end

  --
  --
  -- What gets displayed in panel
  --
  --
    obj.widget:set_markup('<span foreground="' .. tostring(color) .. '">' .. tostring(text) .. '</span>')
end

local function update_by_values(cardid, channel)
  for i, v in pairs(objects) do
    if v.channel == channel and v.cardid == cardid then
      update(v)
    end
  end
end

function volume_alsa.raise(cardid, channel, v)
  v = v or 1
  awful.util.spawn("amixer -q -c " .. cardid .. " sset " .. channel .. " " .. v .. "+", false)
  update_by_values(cardid, channel)
end

function volume_alsa.lower(cardid, channel, v)
  v = v or 1
  awful.util.spawn("amixer -q -c " .. cardid .. " sset " .. channel .. " " .. v .. "-", false)
  update_by_values(cardid, channel)
end

function volume_alsa.mute(cardid, channel)
  awful.util.spawn("amixer -c " .. cardid .. " sset " .. channel .. " toggle", false)
  update_by_values(cardid, channel)
end

local function create(_, cardid, channel)
  local cardid = cardid or 0
  local channel = channel or "Master"

  local obj = {
    cardid = cardid,
    channel = channel,
    term = "x-terminal-emulator -T Mixer"
  }

  local widget = wibox.widget.textbox()
  obj.widget = widget
  obj[1] = widget
  obj.update = function() update(obj) end

  widget:buttons(awful.util.table.join(
    awful.button({ }, 1, function () volume_alsa.mute(obj.cardid, obj.channel) obj.update() end)
  ))

  obj.raise = function(obj, v) volume_alsa.raise(obj.cardid, obj.channel, v) return obj end
  obj.lower = function(obj, v) volume_alsa.lower(obj.cardid, obj.channel, v) return obj end
  obj.mute  = function(obj, v) volume_alsa.mute(obj.cardid, obj.channel, v)  return obj end

  obj.update()

  table.insert(objects, obj)
  return widget
end

local volume_alsa = setmetatable(volume_alsa, { __call = create })
return volume_alsa

