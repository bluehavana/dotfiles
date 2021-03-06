-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")

local vicious = require("vicious")

local freedesktop = require("freedesktop")

local hotkeys_popup = require("awful.hotkeys_popup").widget

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
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
-- }}}

-- Load Debian menu entries
--require("debian.menu")
-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
-- beautiful.init(awful.util.get_themes_dir() .. "default/theme.lua")
beautiful.init( awful.util.get_configuration_dir() .. "/themes/base16-monokai/theme.lua" )
beautiful.font = "Roboto 12"

local user_wallpaper = os.getenv("HOME") .. "/.background"
if awful.util.file_readable(user_wallpaper) then
  beautiful.get().wallpaper = user_wallpaper
end

-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts =
{
    awful.layout.suit.tile,
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
}
-- }}}

-- {{{ Helper functions
local function client_menu_toggle_fn()
    local instance = nil

    return function ()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end
end
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
local awesome_menu = {
   { "hotkeys",
     function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end }
}

local main_menu = freedesktop.menu.build({
    after = {
      { "Awesome", awesome_menu, beautiful.awesome_icon },
      { "terminal", terminal }
    }
})

local aw_launcher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                            menu = main_menu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
local keyboard_layout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
local text_clock = wibox.widget.textclock("%H:%M")

local month_popup = awful.widget.calendar_popup.month()
month_popup:attach(text_clock, "br")

-- Create a wibox for each screen and add it
local taglist_buttons = awful.util.table.join(
          awful.button({ }, 1,
                       function(t)
                           t:view_only()
                       end),
          awful.button({ modkey }, 1,
                       function(t)
                           if client.focus then
                               client.focus:move_to_tag(t)
                           end
                       end),
          awful.button({ }, 3, awful.tag.viewtoggle),
          awful.button({ modkey }, 3,
                       function(t)
                           if client.focus then
                               client.focus:toggle_tag(t)
                           end
                       end),
          awful.button({ }, 4,
                       function(t)
                           awful.tag.viewnext(t.screen)
                       end),
          awful.button({ }, 5,
                       function(t)
                           awful.tag.viewprev(t.screen)
                       end)
       )

local tasklist_buttons = awful.util.table.join(
                     awful.button({ }, 1,
                                  function (c)
                                      if c == client.focus then
                                          c.minimized = true
                                      else
                                          -- Without this, the following
                                          -- :isvisible() makes no sense
                                          c.minimized = false
                                          -- -- old config:
                                          -- if not c:isvisible() then
                                          --  ...
                                          if not c:isvisible() and c.first_tag then
                                              c.first_tag:view_only()
                                          end
                                          -- This will also un-minimize
                                          -- the client, if needed
                                          client.focus = c
                                          c:raise()
                                      end
                                  end),
                     -- -- old config:
                     -- awful.button({ }, 3, function ()
                     --                          if instance then
                     --                              instance:hide()
                     --                              instance = nil
                     --                          else
                     --                              instance = awful.menu.clients({ width=250 })
                     --                          end
                     --                      end),
                     awful.button({ }, 3, client_menu_toggle_fn()),
                     awful.button({ }, 4,
                                  function ()
                                      awful.client.focus.byidx(1)
                                      -- -- old config:
                                      -- if client.focus then client.focus:raise() end
                                  end),
                     awful.button({ }, 5,
                                  function ()
                                      awful.client.focus.byidx(-1)
                                      -- -- old config:
                                      -- if client.focus then client.focus:raise() end
                                  end))

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

-- simple  battery widget
local batwidget = wibox.widget.progressbar()

local batbox = wibox.widget({
  {
    border_color = beautiful.fg_normal,
    border_width = 1,
    background_color = beautiful.bg_normal,
    color = beautiful.fg_normal,
    max_value = 1,
    paddings = 1,
    widget = batwidget
  },
  direction = "east",
  forced_height = 10,
  forced_width = 10,
  layout = wibox.container.rotate,
  margins = {
    left = 2,
    right = 2,
  }
})

vicious.register(batwidget, vicious.widgets.bat, "$2", 61, "BAT1")

local batpopup = wibox.widget.textbox()

vicious.register(batpopup, vicious.widgets.bat, "$2%", 61, "BAT1")

batpopup:buttons(awful.util.table.join(
  awful.button(
    { },
    1,
    function()
      naughty.notify({
        title = "Battery indicator",
        text = vicious.call(vicious.widgets.bat,
                 function(widget, args)
                   return string.format("%s %10sh\n%s: %14d%%\n%s:%12dW",
                                        "Remaining time", args[3],
                                        "Wear level", args[4],
                                        "Present rate", args[5]
                                       )
                 end,
                 0
               )
      })
    end
    )
  )
)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    -- awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, )
    awful.tag({ " ⊂ ", " ∈ ", " ⚛ ", " ® ", " ☣ ", " ∋ ", " ⊃ "}, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.prompt_box = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.layout_box = awful.widget.layoutbox(s)
    s.layout_box:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.tag_list = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

    -- Create a tasklist widget
    s.task_list = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

    -- Create the wibox
    s.wibox = awful.wibar({ position = "bottom", screen = s, height = 24 })

    -- Add widgets to the wibox
    s.wibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            aw_launcher,
            s.tag_list,
            s.prompt_box,
        },
        s.task_list, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            keyboard_layout,
            -- Something of this effect was in the old config
            -- if s.index == 1 then wibox.widget.systray() end,
            wibox.widget.systray(),
            batbox,
            text_clock,
            s.layout_box,
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () main_menu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Commands for keybindings
local scrnsaver_cmd = "xdg-screensaver lock || light-locker-command --lock"
scrnsaver_cmd = scrnsaver_cmd .. " || xscreensaver-command -lock"
scrnsaver_cmd = scrnsaver_cmd .. " || gnome-screensaver-command --lock"

modify_audio = "pacmd dump | grep set-default-sink | tail -1 | cut -d' ' -f 2 | xargs -I '{}' pactl "
audio_up = modify_audio .. "set-sink-volume '{}' +10%"
audio_down = modify_audio .. "set-sink-volume '{}' -10%"
audio_mute = modify_audio .. "set-sink-mute '{}' toggle"
-- }}}
-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ }, "XF86AudioRaiseVolume",
              function()
                  awful.spawn.with_shell(audio_up)
              end),
    awful.key({ }, "XF86AudioLowerVolume",
              function()
                  awful.spawn.with_shell(audio_down)
              end),
    awful.key({ }, "XF86AudioMute",
              function ()
                  awful.spawn.with_shell(audio_mute)
              end),
    awful.key({ "Mod1", "Control" }, "l",
              function ()
                  awful.spawn.with_shell(scrnsaver_cmd)
              end,
              { description = "lock screen", group = "client" }),

    awful.key({ modkey, }, "s", hotkeys_popup.show_help,
              { description="show help", group="awesome" }),

    awful.key({ modkey, }, "Left",   awful.tag.viewprev,
              { description = "view previous", group = "tag" }),
    awful.key({ modkey, }, "Right",  awful.tag.viewnext,
              { description = "view next", group = "tag" }),
    awful.key({ modkey, }, "Escape", awful.tag.history.restore,
              { description = "go back", group = "tag" }),

    awful.key({ modkey, }, "j",
              function ()
                  awful.client.focus.byidx( 1)
              end,
              { description = "focus next by index", group = "client" }),
    awful.key({ modkey, }, "k",
              function ()
                  awful.client.focus.byidx(-1)
              end,
              { description = "focus previous by index", group = "client" }),
    awful.key({ modkey, }, "w", function () main_menu:show()
              end,
              { description = "show main menu", group = "awesome" }),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j",
              function ()
                  awful.client.swap.byidx( 1)
              end,
              { description = "swap with next client by index", group = "client" }),
    awful.key({ modkey, "Shift"   }, "k",
              function ()
                  awful.client.swap.byidx(-1)
              end,
              { description = "swap with previous client by index", group = "client" }),
    awful.key({ modkey, "Control" }, "j",
              function ()
                  awful.screen.focus_relative( 1)
              end,
              { description = "focus the next screen", group = "screen" }),
    awful.key({ modkey, "Control" }, "k",
              function ()
                  awful.screen.focus_relative(-1)
              end,
              { description = "focus the previous screen", group = "screen" }),
    awful.key({ modkey, }, "u", awful.client.urgent.jumpto,
              { description = "jump to urgent client", group = "client" }),
    awful.key({ modkey, }, "Tab",
              function ()
                  awful.client.focus.history.previous()
                  if client.focus then
                      client.focus:raise()
                  end
              end,
              { description = "go back", group = "client" }),

    -- Standard program
    awful.key({ modkey, }, "Return",
              function ()
                  awful.spawn.with_shell(terminal .. " -e tmux")
              end,
              { description = "open a terminal", group = "launcher" }),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              { description = "reload awesome", group = "awesome" }),
    awful.key({ modkey, "Shift" }, "q", awesome.quit,
              { description = "quit awesome", group = "awesome" }),

    awful.key({ modkey, }, "l",
              function ()
                  awful.tag.incmwfact( 0.05)
              end,
              { description = "increase master width factor", group = "layout" }),
    awful.key({ modkey, }, "h",
              function ()
                  awful.tag.incmwfact(-0.05)
              end,
              { description = "decrease master width factor", group = "layout" }),
    awful.key({ modkey, "Shift" }, "h",
              function ()
                  awful.tag.incnmaster( 1, nil, true)
              end,
              { description = "increase the number of master clients", group = "layout" }),
    awful.key({ modkey, "Shift"   }, "l",
              function ()
                  awful.tag.incnmaster(-1, nil, true)
              end,
              { description = "decrease the number of master clients", group = "layout" }),
    awful.key({ modkey, "Control" }, "h",
              function ()
                  awful.tag.incncol( 1, nil, true)
              end,
              { description = "increase the number of columns", group = "layout" }),
    awful.key({ modkey, "Control" }, "l",
               function ()
                   awful.tag.incncol(-1, nil, true)
               end,
              { description = "decrease the number of columns", group = "layout" }),
    awful.key({ modkey, }, "space",
              function ()
                  awful.layout.inc( 1)
              end,
              { description = "select next", group = "layout" }),
    awful.key({ modkey, "Shift" }, "space",
              function ()
                  awful.layout.inc(-1)
              end,
              { description = "select previous", group = "layout" }),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                      client.focus = c
                      c:raise()
                  end
              end,
              { description = "restore minimized", group = "client" }),

    -- Prompt
    awful.key({ modkey }, "r",
              function ()
                  awful.screen.focused().prompt_box:run()
              end,
              { description = "run prompt", group = "launcher" }),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().prompt_box.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              { description = "lua execute prompt", group = "awesome" }),
    -- Menubar
    awful.key({ modkey }, "p",
              function()
                  menubar.show()
              end,
              { description = "show the menubar", group = "launcher" })
)

clientkeys = awful.util.table.join(
    awful.key({ modkey, }, "f",
              function (c)
                  c.fullscreen = not c.fullscreen
                  c:raise()
              end,
              { description = "toggle fullscreen", group = "client" }),
    awful.key({ modkey, "Shift" }, "c",
              function (c)
                  c:kill()
              end,
              { description = "close", group = "client"  }),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client" }),
    awful.key({ modkey, "Control" }, "Return",
              function (c)
                  c:swap(awful.client.getmaster())
              end,
              { description = "move to master", group = "client" }),
    awful.key({ modkey, }, "o",
              function (c)
                  c:move_to_screen()
              end,
              { description = "move to screen", group = "client" }),
    awful.key({ modkey, }, "t",
              function (c)
                  c.ontop = not c.ontop
              end,
              { description = "toggle keep on top", group = "client" }),
    awful.key({ modkey,}, "n",
              function (c)
                  -- The client currently has the input focus, so it cannot be
                  -- minimized, since minimized clients can't have the focus.
                  c.minimized = true
              end,
              { description = "minimize", group = "client" }),
    awful.key({ modkey, }, "m",
              function (c)
                  c.maximized = not c.maximized
                  c:raise()
              end,
              { description = "maximize", group = "client" })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
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

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     size_hints_honor = false,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },


    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
        },
        class = {
          "Arandr",
          "Dia",
          "Empathy",
          "Gimp",
          "Gpick",
          "Inkscape",
          "Kruler",
          "MPlayer",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Wpa_gui",
          "pinentry",
          "veromix",
          "VirtualBox",
          "vmware",
          "vmplayer",
          "xtightvncviewer"},

        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
          -- Chromes notifications are a "bubble" (in air-quotes)
          "bubble"
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = true }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        awful.placement.no_overlap(c)
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
-- client.connect_signal("request::titlebars", function(c)
--     -- buttons for the titlebar
--     local buttons = awful.util.table.join(
--         awful.button({ }, 1, function()
--             client.focus = c
--             c:raise()
--             awful.mouse.client.move(c)
--         end),
--         awful.button({ }, 3, function()
--             client.focus = c
--             c:raise()
--             awful.mouse.client.resize(c)
--         end)
--     )
--
--     awful.titlebar(c) : setup {
--         { -- Left
--             awful.titlebar.widget.iconwidget(c),
--             buttons = buttons,
--             layout  = wibox.layout.fixed.horizontal
--         },
--         { -- Middle
--             { -- Title
--                 align  = "center",
--                 widget = awful.titlebar.widget.titlewidget(c)
--             },
--             buttons = buttons,
--             layout  = wibox.layout.flex.horizontal
--         },
--         { -- Right
--             awful.titlebar.widget.floatingbutton (c),
--             awful.titlebar.widget.maximizedbutton(c),
--             awful.titlebar.widget.stickybutton   (c),
--             awful.titlebar.widget.ontopbutton    (c),
--             awful.titlebar.widget.closebutton    (c),
--             layout = wibox.layout.fixed.horizontal()
--         },
--         layout = wibox.layout.align.horizontal
--     }
-- end)

-- Enable sloppy focus, so that focus follows mouse.
-- client.connect_signal("mouse::enter", function(c)
--     if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
--         and awful.client.focus.filter(c) then
--         client.focus = c
--     end
-- end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- {{{ Execute user specified programs on startup
awful.util.spawn_with_shell( awful.util.get_configuration_dir() .. "/atload.sh" )
awesome.connect_signal("exit",
                       function ()
                           awful.spawn.with_shell(
                               awful.util.get_configuration_dir() .. "/atexit.sh" )
                       end)
-- }}}
