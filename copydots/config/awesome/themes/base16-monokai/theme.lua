---------------------------------

-- Alternative icon sets and widget icons:
--  * http://awesome.naquadah.org/wiki/Nice_Icons

-- {{{ Main
theme = {}
theme.default_themes_path = "/usr/share/awesome/themes"
-- dbg_file = debug.getinfo(1)
-- dbg_file_source = ""
-- if dbg_file then
-- 	dbg_file_source = db_file.source
-- end
--
-- if dbg_file_source:sub(1,1) == "@" then
-- 	theme.icon_path = dbg_file_source:sub(2):gsub("/.-$", "").."/icons"
-- else
-- 	theme.icon_path = "/usr/share/awesome/themes/dark-solarized/icons"
-- end

theme.colors = {}
theme.colors.base00 = "#272822" -- black
theme.colors.base01 = "#383830"
theme.colors.base02 = "#49483e"
theme.colors.base03 = "#75715e"
theme.colors.base04 = "#a59f85"
theme.colors.base05 = "#f8f8f2" -- white
theme.colors.base06 = "#f5f4f1" -- darker white
theme.colors.base07 = "#f9f8f5" -- tanish white
theme.colors.base08 = "#f92672" -- red/magenta
theme.colors.base09 = "#fd971f" -- orange
theme.colors.base0A = "#f4bf75" -- peach/yellow
theme.colors.base0B = "#a6e22e" -- lime green
theme.colors.base0C = "#a1efe4" -- light blue
theme.colors.base0D = "#66d9ef" -- sky blue
theme.colors.base0E = "#ae81ff" -- purple
theme.colors.base0F = "#cc6633" -- mahogany

theme.colors.white = theme.colors.base05
theme.colors.red = theme.colors.base08
theme.colors.orange = theme.colors.base09
theme.colors.yellow = theme.colors.base0A
theme.colors.green = theme.colors.base0B
theme.colors.light_blue = theme.colors.base0C
theme.colors.blue = theme.colors.base0D
theme.colors.purple = theme.colors.base0E
theme.colors.brown = theme.colors.base0F

-- }}}
-- {{{ Styles
theme.font      = "Ubuntu Mono 11"

-- {{{ Colors
theme.fg_normal  = theme.colors.base04
theme.fg_focus   = theme.colors.base06
theme.fg_urgent  = theme.colors.red

theme.bg_normal  = theme.colors.base00
theme.bg_focus   = theme.colors.base01
theme.bg_urgent  = theme.colors.base01
theme.bg_systray = theme.bg_normal
-- }}}

-- {{{ Borders
theme.border_width  = "1"
theme.border_normal = "#00000000"
theme.border_focus  = theme.bg_focus
theme.border_marked = theme.red -- ? does this work?
-- }}}

-- {{{ Titlebars
theme.titlebar_bg_focus  = theme.bg_focus
theme.titlebar_bg_normal = theme.bg_normal
-- }}}

-- {{{ Mouse finder
theme.mouse_finder_color = theme.colors.green
-- mouse_finder_[timeout|animate_timeout|radius|factor]
-- }}}

-- {{{ Menu
-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_height = "15"
theme.menu_width  = "100"
-- }}}

-- {{{ Icons
-- {{{ Taglist
theme.taglist_squares_sel = theme.default_themes_path .. "/zenburn/taglist/squarefz.png"
theme.taglist_squares_unsel = theme.default_themes_path .. "/zenburn/taglist/squarez.png"
--theme.taglist_squares_resize = "false"
-- }}}

-- {{{ Misc
theme.awesome_icon = theme.default_themes_path .. "/zenburn/awesome-icon.png"
theme.menu_submenu_icon = theme.default_themes_path .. "/default/submenu.png"
-- }}}

-- {{{ Layout
theme.layout_tile = theme.default_themes_path.."/zenburn/layouts/tile.png"
theme.layout_tileleft = theme.default_themes_path.."/zenburn/layouts/tileleft.png"
theme.layout_tilebottom = theme.default_themes_path.."/zenburn/layouts/tilebottom.png"
theme.layout_tiletop = theme.default_themes_path.."/zenburn/layouts/tiletop.png"
theme.layout_fairv = theme.default_themes_path.."/zenburn/layouts/fairv.png"
theme.layout_fairh = theme.default_themes_path.."/zenburn/layouts/fairh.png"
theme.layout_spiral = theme.default_themes_path.."/zenburn/layouts/spiral.png"
theme.layout_dwindle = theme.default_themes_path.."/zenburn/layouts/dwindle.png"
theme.layout_max = theme.default_themes_path.."/zenburn/layouts/max.png"
theme.layout_fullscreen = theme.default_themes_path.."/zenburn/layouts/fullscreen.png"
theme.layout_magnifier = theme.default_themes_path.."/zenburn/layouts/magnifier.png"
theme.layout_floating = theme.default_themes_path.."/zenburn/layouts/floating.png"
-- }}}

-- {{{ Titlebar
theme.titlebar_close_button_focus = theme.default_themes_path.."/zenburn/titlebar/close_focus.png"
theme.titlebar_close_button_normal = theme.default_themes_path.."/zenburn/titlebar/close_normal.png"

theme.titlebar_ontop_button_focus_active = theme.default_themes_path.."/zenburn/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active = theme.default_themes_path.."/zenburn/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive = theme.default_themes_path.."/zenburn/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive = theme.default_themes_path.."/zenburn/titlebar/ontop_normal_inactive.png"

theme.titlebar_sticky_button_focus_active = theme.default_themes_path.."/zenburn/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active = theme.default_themes_path.."/zenburn/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive = theme.default_themes_path.."/zenburn/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive = theme.default_themes_path.."/zenburn/titlebar/sticky_normal_inactive.png"

theme.titlebar_floating_button_focus_active = theme.default_themes_path.."/zenburn/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active = theme.default_themes_path.."/zenburn/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive = theme.default_themes_path.."/zenburn/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive = theme.default_themes_path.."/zenburn/titlebar/floating_normal_inactive.png"

theme.titlebar_maximized_button_focus_active = theme.default_themes_path.."/zenburn/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active = theme.default_themes_path.."/zenburn/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive = theme.default_themes_path.."/zenburn/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = theme.default_themes_path.."/zenburn/titlebar/maximized_normal_inactive.png"
-- }}}

-- }}}

return theme
