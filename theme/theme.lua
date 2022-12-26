--[[
    Awesome WM Theme 1.0
    Lyalas
]]--
local dom = math.random(2)
local awful =require("awful")
local shape = require("gears.shape")
local xresources = require("beautiful.xresources")

-- theme base --
local theme_path = os.getenv("HOME") .. "/.config/awesome/theme"
local dpi = xresources.apply_dpi
local theme_assets = require("beautiful.theme_assets")

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

base_color  = "#500068"
sec_color   = "#502050"
opacity_hex = "CC"
--theme --           
theme = {}           
theme.theme_path                         =theme_path
theme.wallpaper                          =theme_wallpaper
theme.font                               ="firacode 8"


theme.wallpaper = themes_path.."background/monogatari-series-background-hd-2560x1440-108558.jpg"
--base colors --
theme.bg_normal                          = "#502050"--unfocused windows and desktop
theme.bg_focus                           = "#500068"--focused windows and desktop
theme.bg_urgent                          = "#000000"--urgent windows
theme.bg_minimize                        = "#281030"--minimised windows
theme.bg_systray                         = theme.bg_normal

theme.fg_normal                          = "#E0D0C0"--unfocused test and secondary text
theme.fg_focus                           = "#E0D0C0"--focused text 
theme.fg_urgent                          = "#E0D0C0"--urgent text
theme.fg_minimize                        = "#E0D0C0"--minimised text
-- | Systray | --
theme.bg_systray                         = theme.bg_normal
theme.systray_icon_spacing               = dpi(0)
-- | Borders | --
theme.useless_gap                        = dpi(3)
theme.border_width                       = dpi(0)
theme.border_normal                      = base_color
theme.border_focus                       = base_color
theme.border_marked                      = "#FFFFFF"

-- | Notification | --
theme.notification_fg                    = "#6F6F6F"
theme.notification_bg                    = "#FFFFFF"
theme.notification_border_color          = "#00FFFF"
theme.notification_border_width          = dpi(1)
theme.notification_max_height            = 300
theme.notification_width                 = 300
theme.notification_icon_size             = 30
-- | Menu | --
theme.menu_bg_normal                     = base_color
theme.menu_bg_focus                      = theme.menu_bg_normal
theme.menu_icon                          = theme.theme_path .. "/icons/menu.png"
theme.menu_submenu_icon                  = theme.theme_path .. "/icons/submenu.png"
theme.menu_height                        = dpi(16)
theme.menu_width                         = dpi(100)
-- | Hotkeys help | --
theme.hotkeys_bg                         = base_color
theme.hotkeys_modifiers_fg               = "#B8DFC0"
theme.hotkeys_border_color               = "#00FFFF"
theme.hotkeys_group_margin               = 10
theme.hotkeys_shape                      = shape_info
-- | Calendar | --
theme.calendar_month_bg_color            = base_color
theme.calendar_year_bg_color             = base_color
-- | Tasklist | --
theme.tasklist_bg_normal                 = base_color.."00"
theme.tasklist_bg_focus                  = theme.tasklist_bg_normal
theme.tasklist_fg_normal                 = theme.fg_normal.."CC"
-- | Taglist squares | --
theme.taglist_squares_sel                = theme.theme_path .. "/taglist/square_sel.png"
theme.taglist_squares_unsel              = theme.theme_path .. "/taglist/square_unsel.png"
theme.taglist_fg_focus                   = "#00FFFF"
theme.taglist_font                       = "Arial 9"
-- | Titlebar | --
theme.titlebar_bg_focus                  = base_color
theme.titlebar_close_button_focus        =theme.theme_path .. "/titlebar/close_focus.png"
theme.titlebar_close_button_normal       =theme.theme_path .. "/titlebar/close_normal.png"

theme.titlebar_ontop_button_focus_active =theme.theme_path .. "/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active =theme.theme_path .. "/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive =theme.theme_path .. "/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive =theme.theme_path .. "/titlebar/ontop_normal_inactive.png"

theme.titlebar_sticky_button_focus_active =theme.theme_path .. "/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active =theme.theme_path .. "/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive =theme.theme_path .. "/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive =theme.theme_path .. "/titlebar/sticky_normal_inactive.png"

theme.titlebar_floating_button_focus_active =theme.theme_path .. "/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active =theme.theme_path .. "/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive =theme.theme_path .. "/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive =theme.theme_path .. "/titlebar/floating_normal_inactive.png"

theme.titlebar_maximized_button_focus_active =theme.theme_path .. "/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active =theme.theme_path .. "/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive =theme.theme_path .. "/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive =theme.theme_path .. "/titlebar/maximized_normal_inactive.png"

-- | Separators | --
theme.spr1px         = theme.theme_path .. "/separators/spr1px.png"
theme.spr2px         = theme.theme_path .. "/separators/spr2px.png"
theme.spr4px         = theme.theme_path .. "/separators/spr4px.png"
theme.spr5px         = theme.theme_path .. "/separators/spr5px.png"
theme.spr10px        = theme.theme_path .. "/separators/spr10px.png"

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Generate taglist squares:
local taglist_square_size = dpi(4)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal)

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_path.."default/submenu.png"
theme.menu_height = dpi(15)
theme.menu_width  = dpi(100)

-- Define the image to load
theme.titlebar_close_button_normal          = themes_path.."default/titlebar/close_normal.png"
theme.titlebar_close_button_focus           = themes_path.."default/titlebar/close_focus.png"

theme.titlebar_minimize_button_normal       = themes_path.."default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus        = themes_path.."default/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = themes_path.."default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = themes_path.."default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active   = themes_path.."default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active    = themes_path.."default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive= themes_path.."default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive = themes_path.."default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active  = themes_path.."default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active   = themes_path.."default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = themes_path.."default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = themes_path.."default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active   = themes_path.."default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active    = themes_path.."default/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = themes_path.."default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = themes_path.."default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active   = themes_path.."default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active    = themes_path.."default/titlebar/maximized_focus_active.png"


-- YLayout --
theme.layout_fairh       = themes_path.."default/layouts/fairhw.png"
theme.layout_fairv       = themes_path.."default/layouts/fairvw.png"
theme.layout_floating    = themes_path.."default/layouts/floatingw.png"
theme.layout_magnifier   = themes_path.."default/layouts/magnifierw.png"
theme.layout_max         = themes_path.."default/layouts/maxw.png"
theme.layout_fullscreen  = themes_path.."default/layouts/fullscreenw.png"
theme.layout_tilebottom  = themes_path.."default/layouts/tilebottomw.png"
theme.layout_tileleft    = themes_path.."default/layouts/tileleftw.png"
theme.layout_tile        = themes_path.."default/layouts/tilew.png"
theme.layout_tiletop     = themes_path.."default/layouts/tiletopw.png"
theme.layout_spiral      = themes_path.."default/layouts/spiralw.png"
theme.layout_dwindle     = themes_path.."default/layouts/dwindlew.png"
theme.layout_cornernw    = themes_path.."default/layouts/cornernww.png"
theme.layout_cornerne    = themes_path.."default/layouts/cornernew.png"
theme.layout_cornersw    = themes_path.."default/layouts/cornersww.png"
theme.layout_cornerse    = themes_path.."default/layouts/cornersew.png"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)
-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil
return theme