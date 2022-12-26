--[[
    Awesome WM Config 2.0
    Lyalas
]]--
pcall(require, "luarocks.loader")
--libraries
local gears = require("gears")
local awful = require("awful")
local lain= require("lain")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
--Debian menu entries
local debian = require("debian.menu")
local has_fdo, freedesktop = pcall(require, "freedesktop")
--Widgets
local myvolume = require("widgets/volume")
local cpu = lain.widget.cpu{
    settings = function()
        widget:set_markup("【".. cpu_now.usage .. "%】")
    end
}
local mem = lain.widget.mem{
    settings = function()
        widget:set_markup("【"..mem_now.used .. "MB】")
    end
}
local netD = lain.widget.net{
    notify = "off",
    wifi_state = "on",
    settings = function()
        widget:set_markup("【↓".. net_now.received.."K/s】")
    end
}
local netU = lain.widget.net{
    notify = "off",
    wifi_state = "on",
    settings = function()
        widget:set_markup("【↑".. net_now.sent.."K/s】") 
    end
}
local bat = lain.widget.bat{
    notify = "on",
    timeout = 15,
    settings = function()
        widget:set_markup("【B»" ..bat_now.ac_status .."»".. bat_now.capacity.."】")
    end
}
local vol  = lain.widget.alsa{
    timeout = 2,
    settings = function()
        if volume_now.status == "off" then
            volume_now.level = volume_now.level .. "M"
        end
        widget:set_markup("【∿" .. volume_now.level .. "】")
    end
}
local clock = wibox.widget.textclock("【%a/%b/%d, %H:%M】")
-- Startup error
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end
do -- Runtime errors
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

-- Variables
beautiful.init("/home/lya/.config/awesome/theme/theme.lua")
terminal = "hyper"
editor = os.getenv("EDITOR") or "code"
editor_cmd = terminal .. " -e " .. editor
browser = "chromium"
music = "spotify"
-- Default modifiers.
Mkey = "Mod4"
Fkey = "Mod5"
Skey = "Shift"
Ckey = "Control"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    awful.layout.suit.corner.nw,
}

--launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}
local menu_awesome = { "awesome", myawesomemenu, beautiful.awesome_icon }
local menu_terminal = { "open terminal", terminal }

if has_fdo then
    mymainmenu = freedesktop.menu.build({
        before = { menu_awesome },
        after =  { menu_terminal }
    })
else
    mymainmenu = awful.menu({
        items = {
            menu_awesome,
            { "Debian", debian.menu.Debian_menu.Debian },
            menu_terminal,
    }})
end
mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,menu = mymainmenu })
-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it

-- {{ Wibar
-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({Mkey}, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ Mkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end end),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end))

local tasklist_buttons = gears.table.join(
    awful.button({ }, 1, function (c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal("request::activate","tasklist",{raise = true})
        end end),
    awful.button({ }, 3, function()
        awful.menu.client_list({ theme = { width = 250 } }) end),
    awful.button({ }, 4, function ()
        awful.client.focus.byidx( 1) end),
    awful.button({ }, 5, function ()
        awful.client.focus.byidx(-1) end))

awful.screen.connect_for_each_screen(function(s)
        -- Each screen has its own tag table.
    local names={ "main","dev","stream","anime"}
    local l = awful.layout.suit  -- Just to save some typing: use an alias.
    local layouts = { l.tile,l.tile.left, l.floating, l.fair,l.spiral,l.dwindle}
    awful.tag(names, s, layouts)
    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
        awful.button({ }, 1, function () awful.layout.inc( 1) end),
        awful.button({ }, 3, function () awful.layout.inc(-1) end),
        awful.button({ }, 4, function () awful.layout.inc( 1) end),
        awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons}
    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons}
    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })
    --widget on the left side
    local left_layout = wibox.layout.fixed.horizontal()
      if s.index == 1 then
         left_layout:add(mylauncher)
      end
      left_layout:add(s.mytaglist)
      left_layout:add(s.mypromptbox)
    --widget on the right side
    local right_layout = wibox.layout.fixed.horizontal()
      if s.index == 1 then
        right_layout:add(cpu.widget)
        right_layout:add(mem.widget)
        right_layout:add(netD.widget)
        right_layout:add(netU.widget)
        right_layout:add(bat.widget)
        right_layout:add(vol.widget)
        right_layout:add(clock)
      end
      right_layout:add(s.mylayoutbox)
    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        left_layout,  -- Left widget
        s.mytasklist, -- Middle widget
        right_layout, -- Right widget
     }
end)
-- }}

-- {{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}

-- {{ Key bindings
globalkeys = gears.table.join(--awesome
    awful.key({Mkey,    },"w",     function () mymainmenu:show()           end,
        {description = "main menu",group ="awesome"}),
    awful.key({Mkey,    },"s",     hotkeys_popup.show_help,
        {description="help",       group="awesome"}),
    awful.key({Mkey,Ckey},"r",     awesome.restart,
        {description="reload A",   group ="awesome"}),
    awful.key({Mkey,Skey},"q",     awesome.quit,
        {description="quit A",     group ="awesome"}),
    awful.key({Mkey},"x",          function () awful.prompt.run {
            prompt       = "Run : ",
            textbox      = awful.screen.focused().mypromptbox.widget,
            exe_callback = awful.util.eval,
            history_path = awful.util.get_cache_dir() .. "/history_eval"
        } end,
        {description= "lua execute prompt", group = "awesome"}),
    -- System volume/brightness
    awful.key({},"XF86AudioRaiseVolume",myvolume.raise,
        {description="raise volume",   group ="awesome"}),
    awful.key({},"XF86AudioLowerVolume",myvolume.lower,
        {description="lower volume",   group ="awesome"}),
    awful.key({},"XF86AudioMute",       myvolume.mute,
        {description="mute volume",    group ="awesome"}),
    awful.key({Mkey}, ";",function () brightness_widget:inc() end,
        {description = "increase brightness", group ="awesome"}),
    awful.key({ Mkey,Ckey},";",function () brightness_widget:dec() end,
        {description = "decrease brightness", group ="awesome"}),
    --tags
    awful.key({Mkey,    },"Left",  awful.tag.viewprev,
        {description = "view previous", group = "tag"}),
    awful.key({Mkey,    },"Right", awful.tag.viewnext,
        {description = "view next", group = "tag"}),
    awful.key({Mkey,    },"Escape",awful.tag.history.restore,
        {description = "go back", group = "tag"}),
    --client
    awful.key({Mkey,    },"j",     function() awful.client.focus.byidx( 1)  end,
        {description = "focus next by index", group ="client"}),
    awful.key({Mkey,    },"k",     function() awful.client.focus.byidx(-1)  end,
        {description = "focus previous by index", group ="client"}),
    awful.key({Mkey,Skey},"j",     function() awful.client.swap.byidx(  1)  end,
        {description = "swap next client by index", group ="client"}),
    awful.key({Mkey,Skey},"k",     function() awful.client.swap.byidx( -1)  end,
        {description = "swap previous client by index", group ="client"}),
    awful.key({ Mkey,   },"Tab",function() awful.client.focus.history.previous()
            if client.focus then client.focus:raise() end end,
        {description = "go back", group = "client"}),
    -- Layout
    awful.key({Mkey,    },"l",    function() awful.tag.incmwfact( 0.05)     end,
        {description="inc master width ", group = "layout"}),
    awful.key({Mkey,    },"h",    function() awful.tag.incmwfact(-0.05)     end,
        {description="dec master width ", group = "layout"}),
    awful.key({Mkey,    },"space",function() awful.layout.inc( 1)           end,
        {description="select next",    group = "layout"}),
    awful.key({Mkey,Skey},"space",function() awful.layout.inc(-1)           end,
        {description="select previous",group = "layout"}),
    -- screen
    awful.key({Mkey,Ckey},"n",    function() local c = awful.client.restore()
            -- Focus restored client
            if c then
            c:emit_signal(
                "request::activate", "key.unminimize", {raise = true})
            end end,
        {description="restore minimized",group = "client"}),
    --launcher
    awful.key({Mkey},"Return",function() awful.spawn(terminal)               end,
        {description="open a terminal",group = "launcher"}),
    awful.key({Mkey},"r",function() awful.screen.focused().mypromptbox:run() end,
        {description= "run prompt", group = "launcher"}),
    awful.key({Mkey},"p",function() menubar.show()                           end,
        {description="show the menubar", group = "launcher"}),
    awful.key({Mkey,Ckey,Skey},"l",function() logout_popup.launch()          end,
         {description = "Show logout screen", group = "launcher"})
    )
clientkeys = gears.table.join( 
    awful.key({Mkey,    },"f", function (c)
            c.fullscreen = not c.fullscreen c:raise() end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({Mkey,Skey},"c",     function(c) c:kill()                      end,
        {description = "close", group = "client"}),
    awful.key({Mkey,Ckey},"space", awful.client.floating.toggle                 ,
        {description = "toggle floating", group = "client"}),
    awful.key({Mkey,    },"o",     function(c) c:move_to_screen()            end,
        {description = "move to screen", group = "client"}),
    awful.key({Mkey,    },"t",     function(c) c.ontop = not c.ontop         end,
        {description = "toggle keep on top", group = "client"}),
    awful.key({Mkey,    },"n",     function(c) c.minimized = true            end,
        {description = "minimize", group = "client"}),
    awful.key({Mkey,    },"m",     function(c) c.maximized = not c.maximized
            c:raise() end,
        {description ="maximize", group = "client"}),
    awful.key({Mkey,Ckey},"m",     function(c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise() end,
        {description ="maximize horizontal", group = "client"}),
    awful.key({Mkey,Skey},"m",     function(c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise() end,
        {description ="maximize vertical", group = "client"})
)
clientbuttons = gears.table.join(
    awful.button({    },1, function (c)
        c:emit_signal("request::activate", "mouse_click",
         {raise = true}) end),
    awful.button({Mkey},1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c) end),
    awful.button({Mkey},3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c) end)
)
-- Set keys
root.keys(globalkeys)
-- }}
-- {{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    {rule = { },
      properties = {
        border_width = beautiful.border_width,
        border_color = beautiful.border_normal,
        focus = awful.client.focus.filter,
        raise = true,
        keys = clientkeys,
        buttons = clientbuttons,
        screen = awful.screen.preferred,
        placement = awful.placement.no_overlap+awful.placement.no_offscreen
        }
    },-- Floating clients.
    {rule_any = {
        instance = {},class = {},name = {"Event Tester"},role = {"pop-up"}
        }, properties = { floating = true }
    },-- Add titlebars to normal clients and dialogs
    {rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = true }
    },
}
-- }}
-- {{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    c.shape = function(cr, w, h)
        gears.shape.rounded_rect(cr, w, h, 4 )
    end
    -- Set the windows at the slave,
    -- if not awesome.startup then awful.client.setslave(c) end
    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c) end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c) end)
    )
    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },{ -- Middle
            { -- Title
                align  = "left",
                widget = awful.titlebar.widget.titlewidget(c)
            },buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },{ -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },layout = wibox.layout.align.horizontal
    }
end)
-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)
client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}
--Autostart apps
awful.spawn.with_shell("compton")
awful.spawn.with_shell("nitrogen --random --set-zoom-fill ~/.config/awesome/theme/background")
awful.spawn.with_shell("hyper")