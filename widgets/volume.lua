---@diagnostic disable: param-type-mismatch
local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")
local helpers = require("widgets/helpers")

local config = awful.util.getdir("config")
local widget = {}
local popup = nil
local volumetext = "--"
local volumecurrent = nil
local iconpath = ""

-- Define subwidgets
widget.text = wibox.widget.textbox()
widget._icon = wibox.widget.imagebox()

-- {{{ Define interactive behaviour
widget._icon:buttons(gears.table.join(
      awful.button({ }, 1, function ()
         awful.spawn("pavucontrol -t 4", {
            floating  = true,
            tag       = mouse.screen.selected_tag,
            placement = awful.placement.centered,
         })
      end)
))
-- }}}

-- {{{ Update method
function widget:update()
   -- TODO: change amixer to pactl
   -- see: https://unix.stackexchange.com/questions/132230/read-out-pulseaudio-volume-from-commandline-i-want-pactl-get-sink-volume
   -- https://gist.github.com/Ropid/3a08d70a807e35c7e8c688d54b725e8e
   local status = helpers:run("amixer sget Master")
   local volume = tonumber(string.match(status, "(%d?%d?%d)%%")) or 0
   volumetext = volume .. "% Volume"
   widget.text:set_markup(volumetext)

   iconpath = config.."/theme/icons/status/audio-volume"

   if string.find(status, "[off]", 1, true) or volume <= 0.0 then
      iconpath = iconpath .. "-muted"
   elseif volume < 25 then
      iconpath = iconpath .. "-low"
   elseif volume > 75 then
      iconpath = iconpath .. "-high"
   else
      iconpath = iconpath .. "-medium"
   end
   iconpath = iconpath .. "-symbolic.svg"

   if volumecurrent ~= volume and volumecurrent ~= nil then
      widget.showPopup(0.1)
   end
   widget._icon:set_image(iconpath)
   widget.icon = helpers:set_draw_method(widget._icon)

   volumecurrent = volume
end

function widget:showPopup(timeout)
   widget.hidePopup()
   popup = naughty.notify({
         icon = iconpath,
         icon_size = 16,
         text = volumetext,
         timeout = timeout, hover_timeout = 0.5,
         screen = mouse.screen,
         ignore_suspend = true
   })
end

function widget:hidePopup()
   if popup ~= nil then
      naughty.destroy(popup)
      popup = nil
   end
end

function widget:raise()
   awful.spawn("amixer set Master 1%+", false)
   helpers:delay(widget.update, 0.1)
end

function widget:lower()
   awful.spawn("amixer set Master 1%-", false)
   helpers:delay(widget.update, 0.1)
end

function widget:mute()
   awful.spawn("amixer -D pulse set Master 1+ toggle", false)
   helpers:delay(widget.update, 0.1)
end
-- }}}

-- {{{ Listen
helpers:listen(widget, 40)
widget._icon:connect_signal("mouse::enter", function() widget:showPopup() end)
widget._icon:connect_signal("mouse::leave", function() widget:hidePopup() end)
-- }}}
return widget