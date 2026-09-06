-- Hyprland config, migrated from hyprland.conf to the Lua format (0.55+).
-- Refer to the wiki for more information.
-- https://wiki.hypr.land/Configuring/Start/

-- You can split this configuration into multiple files
-- Create your files separately and then require them like this:
-- require("myColors")

local home = os.getenv("HOME")


------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = 1,
})


---------------------
---- MY PROGRAMS ----
---------------------

local terminal    = "foot"
local fileManager = "nautilus"
local menu        = "fuzzel --no-icons"


-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/
hl.on("hyprland.start", function()
    hl.exec_cmd(home .. "/.config/hypr/autostart.sh")
end)


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

-- hl.env("AQ_DRM_DEVICES", "/dev/dri/card2:/dev/dri/card1")

-- hl.env("GBM_BACKEND", "nvidia-drm")
-- hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
-- hl.env("LIBVA_DRIVER_NAME", "nvidia")
-- hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
-- hl.env("NVD_BACKEND", "direct")

hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")

hl.env("GDK_SCALE", "1")
hl.env("GDK_DPI_SCALE", "1")
hl.env("QT_SCALE_FACTOR", "1")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("XDG_SESSION_TYPE", "wayland")

-- Helps applications (Flameshot, Electron apps, portals, etc.) detect the desktop
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")

hl.env("GTK_CSD", "0")

hl.env("XCURSOR_SIZE", "16")
hl.env("HYPRCURSOR_SIZE", "16")
hl.env("XCURSOR_THEME", "Gruvbox")
hl.env("HYPRCURSOR_THEME", "Gruvbox")

hl.config({
    xwayland = {
        force_zero_scaling = true,
    },
})


-----------------------
----- PERMISSIONS -----
-----------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- Permission changes require a Hyprland restart and are not applied on-the-fly.

-- hl.config({
--   ecosystem = {
--     enforce_permissions = true,
--   },
-- })

-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")


-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    general = {
        gaps_in  = 2,
        gaps_out = 4,

        border_size = 0,

        col = {
            active_border   = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },

        -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = true,

        -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
        allow_tearing = false,

        layout = "master",
    },

    decoration = {
        rounding       = 10,
        rounding_power = 5,

        -- Change transparency of focused and unfocused windows
        active_opacity   = 1.0,
        inactive_opacity = 1.0,
        dim_inactive     = true,
        dim_strength     = 0.08,
        dim_special      = 0.10,

        shadow = {
            enabled      = false,
            range        = 4,
            render_power = 3,
            color        = "rgba(1a1a1aee)",
        },

        blur = {
            enabled  = false,
            size     = 3,
            passes   = 1,
            vibrancy = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },

    ecosystem = {
        no_update_news  = true,
        no_donation_nag = true,
    },
})

-- Curves, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint",   { type = "bezier", points = { { 0.23, 1 },    { 0.32, 1 }   } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 }   } })
hl.curve("linear",         { type = "bezier", points = { { 0, 0 },       { 1, 1 }      } })
hl.curve("almostLinear",   { type = "bezier", points = { { 0.5, 0.5 },   { 0.75, 1.0 } } })
hl.curve("quick",          { type = "bezier", points = { { 0.15, 0 },    { 0.1, 1 }    } })

-- --- Slightly faster animations (~20%) ---

-- Hiding Waybar releases its exclusive zone, so the bar and the windows that
-- reflow into the freed space animate together. Both run off these values --
-- `windows` is the leaf that drives window movement -- so they travel at the
-- same rate.
local moveSpeed, moveCurve = 2, "easeOutQuint"

hl.animation({ leaf = "global",        enabled = true, speed = 4,    bezier = "default" })
hl.animation({ leaf = "border",        enabled = true, speed = 2.2,  bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true, speed = moveSpeed, bezier = moveCurve })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 1.6,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 0.55, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 0.7,  bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 0.55, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 1.2,  bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true, speed = 1.5,  bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = moveSpeed, bezier = moveCurve, style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = moveSpeed, bezier = moveCurve, style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 0.7,  bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 0.55, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 0.8,  bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 0.45, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 0.8,  bezier = "almostLinear", style = "fade" })

-- SUPER+B stops/starts Waybar (scripts/waybar-toggle.py); the slide style turns
-- that into a slide up / slide down instead of a fade in place.
hl.layer_rule({
    name      = "waybar-slide",
    match     = { namespace = "waybar" },
    animation = "slide",
})

-- Ref https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- "Smart gaps" / "No gaps when only"
-- uncomment all if you wish to use that.
-- hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
-- hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
-- hl.window_rule({
--     name  = "no-gaps-wtv1",
--     match = { float = false, workspace = "w[tv1]" },
--     border_size = 0,
--     rounding    = 0,
-- })
-- hl.window_rule({
--     name  = "no-gaps-f1",
--     match = { float = false, workspace = "f[1]" },
--     border_size = 0,
--     rounding    = 0,
-- })

hl.config({
    -- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
    dwindle = {
        preserve_split = true,
    },

    -- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
    master = {
        new_status        = "slave",
        allow_small_split = true,
    },

    misc = {
        force_default_wallpaper        = 1,
        disable_hyprland_logo          = true,
        exit_window_retains_fullscreen = true,
        enable_swallow                 = true,
        swallow_regex                  = "^(foot)$",
    },

    debug = {
        vfr = true,
    },
})


---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "caps:escape",
        kb_rules   = "",

        follow_mouse = 1,

        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = true,
        },
    },
})

-- Example per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})


---------------
---- GROUP ----
---------------

hl.config({
    group = {
        -- col = {
        --     border_active   = "rgb(2E3440)", -- Nordic blue
        --     border_inactive = "rgb(3b4252)", -- Nordic dark grey
        -- },

        groupbar = {
            enabled = false,

            font_family = "JetBrains Mono",
            font_size   = 16,

            -- Visual settings for the groupbar
            font_weight_active   = "bold",   -- Make the active window title bold
            font_weight_inactive = "normal", -- Inactive titles normal

            -- Gradients for the background (use a single color for solid)
            gradients = true,
            col = {
                active          = "rgb(a3be8c)",
                inactive        = "rgba(2E3440ff)",
                locked_active   = "rgb(3b4252)",
                locked_inactive = "rgba(3b425200)",
            },

            text_color = "rgba(ffffffff)", -- White text color for titles

            -- Size and spacing
            height           = 0,  -- Height of the entire groupbar
            indicator_height = 4,  -- Height of the active tab indicator
            indicator_gap    = 0,  -- Gap between indicator and title text
            gaps_in          = 0,  -- Gap size between individual gradient tabs
            gaps_out         = -4, -- Gap size between the groupbar and the window content

            -- Rounding for the groupbar and its elements
            rounding          = 2,     -- How much to round the individual indicator
            gradient_rounding = 2,     -- How much to round the background gradients
            round_only_edges  = false, -- Round only the outer edges of the entire groupbar

            -- Other behavior/rendering options
            render_titles = true,  -- Whether to show window titles in the groupbar
            scrolling     = true,  -- Scroll (e.g. mouse wheel) to change active window in group
            stacked       = false, -- Render the groupbar horizontally (default is false)
            priority      = 3,     -- Decoration priority (higher is drawn on top)
            text_offset   = 0,     -- Adjust vertical position for titles (0 is centered)
            keep_upper_gap = false, -- Keep a gap at the top of the groupbar
        },
    },
})


---------------------
---- KEYBINDINGS ----
---------------------

-- See https://wiki.hypr.land/Configuring/Basics/Binds/
local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- Fraction of the monitor a window gets when toggled to floating (SUPER + F)
local floatWidth, floatHeight = 0.55, 0.6

hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd(home .. "/.config/hypr/scripts/screenshot_slurp.sh - | wl-copy"))
hl.bind(mainMod .. " + SHIFT + A", hl.dsp.exec_cmd([[grim "/media/Pictures/screenshots/$(date +%Y%m%d-%H%M%S).png"]]))

hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("chromium"))
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("copyq toggle"))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(home .. "/bin/search"))
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("pavucontrol"))
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exit())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + F", function()
    hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
    local w = hl.get_active_window()
    local m = hl.get_active_monitor()
    if w and m and w.floating then
        hl.dispatch(hl.dsp.window.resize({
            x = math.floor(m.width  * floatWidth),
            y = math.floor(m.height * floatHeight),
        }))
        hl.dispatch(hl.dsp.window.center())
    end
end)
-- Slide Waybar out of view / back in.
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(home .. "/.config/hypr/scripts/waybar-toggle.py"))

hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())            -- dwindle
hl.bind(mainMod .. " + R", hl.dsp.layout("togglesplit"))      -- dwindle

-- Maximize (old `fullscreen, 1`) / true fullscreen (old `fullscreen, 0`)
hl.bind(mainMod .. " + M",         hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.window.fullscreen({ mode = "fullscreen" }))

-- Move focus with mainMod + hjkl
-- hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "l" }))
-- hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "r" }))
-- hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "u" }))
-- hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "d" }))

hl.bind(mainMod .. " + SHIFT + RETURN", hl.dsp.layout("swapwithmaster"))

hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "d" }))

hl.bind(mainMod .. " + L", hl.dsp.layout("cyclenext"))
hl.bind(mainMod .. " + H", hl.dsp.layout("cycleprev"))

hl.bind(mainMod .. " + J", hl.dsp.layout("cyclenext"))
hl.bind(mainMod .. " + K", hl.dsp.layout("cycleprev"))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace (silently) with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,           hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key,   hl.dsp.window.move({ workspace = i, follow = false }))
end

hl.bind(mainMod .. " + CTRL + H", hl.dsp.window.move({ into_group = "l" }))
hl.bind(mainMod .. " + CTRL + L", hl.dsp.window.move({ into_group = "r" }))
hl.bind(mainMod .. " + CTRL + J", hl.dsp.window.move({ into_group = "d" }))
hl.bind(mainMod .. " + CTRL + K", hl.dsp.window.move({ into_group = "u" }))

hl.bind(mainMod .. " + ALT + H", hl.dsp.window.move({ out_of_group = "l" }))
hl.bind(mainMod .. " + ALT + L", hl.dsp.window.move({ out_of_group = "r" }))
hl.bind(mainMod .. " + ALT + J", hl.dsp.window.move({ out_of_group = "d" }))
hl.bind(mainMod .. " + ALT + K", hl.dsp.window.move({ out_of_group = "u" }))

hl.bind(mainMod .. " + SHIFT + D", hl.dsp.layout("addmaster"))
hl.bind(mainMod .. " + CTRL + D",  hl.dsp.layout("removemaster"))

hl.bind(mainMod .. " + ALT + G",   hl.dsp.window.deny_from_group({ action = "toggle" }))
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

hl.window_rule({
    name  = "windowrule-1",
    match = { class = "pavucontrol" },

    float  = true,
    size   = { 250, 250 },
    center = true,
})

-- CopyQ reports "copyq" under XWayland and "com.github.hluk.copyq" natively,
-- so match both -- it now runs natively (see autostart.sh).
hl.window_rule({
    name  = "windowrule-2",
    match = { class = "^(com\\.github\\.hluk\\.)?copyq$" },

    float  = true,
    size   = { 400, 900 },
    center = true,
})

-- Ignore maximize requests from apps. You'll probably like this.
hl.window_rule({
    name  = "windowrule-3",
    match = { class = ".*" },

    suppress_event = "maximize",
    border_size    = 0,
})

-- Fix some dragging issues with XWayland
hl.window_rule({
    name  = "windowrule-4",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})
