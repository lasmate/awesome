---@diagnostic disable: need-check-nil, undefined-global
--[[
   Awesome WM Widget Helper
   Distopico Vegan <distopico [at] riseup [dot] net>
   Licensed under GPL3
   Original from: https://github.com/mrzapp/awesomerc

--]]

local wibox = require("wibox")
local helpers = {}

function helpers:set_draw_method(imagebox, scale)
   local wmargin = wibox.layout.margin()
   wmargin:set_margins(4)
   wmargin:set_widget(imagebox)
   return wmargin
end

function helpers:run(command)
   local prog = io.popen(command)
   local result = prog:read('*all')
   prog:close()
   return result
end

function helpers:delay(func, time)
   local timer = timer({timeout = time or 0})

   timer:connect_signal("timeout", function()
                           func()
                           timer:stop()
   end)

   timer:start()
end

function helpers:listen(widget, interval)
   widget:update()

   if widget._timer ~= nil then
      widget._timer:stop()
   end

   -- Timer
   local timer = timer({timeout = interval or 30})
   widget._timer = timer

   timer:connect_signal("timeout", function()
                           widget:update()
   end)

   timer:start()
end

function helpers:test(cmd)
   local test = io.popen(cmd)
   local result = test:read() ~= nil

   test:close()

   return result
end

function helpers:exists(path)
   if path == nil then
     return false
   end

   local content = io.open(path, "rb")
   if content then
      content:close()
   end
   return content ~= nil
end

-- {{{ Expose path as a Lua table
function helpers:pathtotable(dir)
   return setmetatable({ _path = dir },
      { __index = function(table, index)
           local path = table._path .. '/' .. index
           local f = io.open(path)
           if f then
              local s = f:read("*all")
              f:close()
              if s then
                 return s
              else
                 local o = { _path = path }
                 setmetatable(o, getmetatable(table))
                 return o
              end
           end
      end
   })
end
-- }}}

return helpers
