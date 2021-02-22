import XMonad
import Data.Monoid
import System.Exit
import XMonad.Hooks.ManageDocks
import XMonad.Util.SpawnOnce
import XMonad.Util.Run
import XMonad.Config.Azerty
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Layout.Spacing
import XMonad.Layout.LayoutModifier
import XMonad.Layout.Grid
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.DynamicLog

import qualified Data.Map as M
import qualified XMonad.StackSet as W
import qualified Data.Map        as M

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal      = "alacritty"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
--
myBorderWidth   = 2

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod4Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces    = ["home", "code", "web", "mail", "sns", "game", "music", "file", "txt"]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#4c566a"
myFocusedBorderColor = "#88c0d0"

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm , xK_k), spawn $ XMonad.terminal conf)

    , ((modm .|. shiftMask , xK_k), spawn "alacritty -t 'floating terminal'")

    -- launch dmenu
    , ((modm,               xK_space     ), spawn "bash ~/Scripts/rofi/launch.sh drun")

    --switch keyboard layout
    , ((modm .|. shiftMask ,       xK_space     ), spawn "bash ~/Scripts/kbSwitch.sh")

    -- launch firefox
    , ((modm,               xK_f     ), spawn "brave")


    , ((modm .|. shiftMask,               xK_f     ), spawn "firefox")

    -- launch mpd
    , ((modm .|. shiftMask, xK_p     ), spawn "mpc -p 6610 toggle")
    , ((modm .|. shiftMask, xK_KP_Add     ), spawn "mpc -p 6610 vol 10")
    , ((modm .|. shiftMask, xK_KP_Subtract     ), spawn "mpc -p 6610 vol -10")

    -- toogle polybar
    , ((modm .|. shiftMask, xK_Return),  spawn "bash ~/.config/polybar/toogle.sh")

    -- lock screen
    , ((modm, xK_l),  spawn "betterlockscreen -l blur")

    , ((modm, xK_g),  spawn "thunar")

    , ((modm,               xK_n     ), spawn "alacritty -t 'floating vimwiki' --command nvim ~/vimwiki/index.md")

    , ((modm, xK_m),  spawn "alacritty --command ncmpcpp")

    , ((modm .|. shiftMask, xK_m),  spawn "alacritty -t 'floating ncmpcpp' --command ncmpcpp")

    -- close focused window
    , ((modm , xK_q     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_Tab ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_Tab ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm .|. shiftMask,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_Left     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_Right     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_Return),  windows W.swapMaster  )

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_Left     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_Right     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm .|. mod1Mask,               xK_Left     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm .|. mod1Mask,               xK_Right     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

      -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]

------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--

mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True


myLayout = avoidStruts (tiled ||| grid ||| Full)
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = mySpacing 8 $ Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

     grid = mySpacing 8 $ Grid

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore
    , resource =? "dunst" --> doFloat
    , resource =? "/home/alexandre/Android/Sdk/emulator/qemu/linux-x86_64/qemu-system-x86_64" --> doFloat
    , resource =? "pavucontrol" --> doFloat
    , title =? "floating terminal" --> doFloat
    , className =? "floating thunar" --> doFloat
    , title =? "floating vimwiki" --> doFloat
    , title =? "floating ncmpcpp" --> doFloat
    ]

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = mempty

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.

myLogHook = return ()

myAddKeys :: [(String, X ())]
myAddKeys =
  [ ("M-S-r", spawn "xmonad --recompile; xmonad --restart")        -- Restarts xmonad
    , ("M-S-e", spawn "~/Scripts/rofi/launch.sh powermenu")

    , ("<XF86AudioMute>",   spawn "amixer set Master toggle")
    , ("<XF86AudioLowerVolume>", spawn "amixer set Master 2%- unmute")
    , ("<XF86AudioRaiseVolume>", spawn "amixer set Master 2%+ unmute")
    , ("M-F1", spawn "bash ~/.config/polybar/toogle.sh &")

  ]

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = do
    spawnOnce "nitrogen --restore &"
    spawnOnce "picom &"
    spawnOnce "dunst &"
    spawnOnce "redshift &"
    spawnOnce "mopidy &"
    spawn "bash ~/.config/polybar/launch.sh &"

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main :: IO ()
main = do
  --dbus <- D.connectSession
  --D.requestName dbus (D.busName_ "org.xmonad.Log")
    --[D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]

  xmonad $ docks $ ewmh $ defaults 
    { keys = \c -> azertyKeys c <+> keys defaults c
    , modMask            = myModMask
        , terminal           = myTerminal
        , startupHook        = myStartupHook
        , layoutHook         = myLayout
        , workspaces         = myWorkspaces
        , borderWidth        = myBorderWidth
        , normalBorderColor  = myNormalBorderColor
        , focusedBorderColor = myFocusedBorderColor

    , logHook = myLogHook <+> ewmhDesktopsLogHook 
    , handleEventHook    = fullscreenEventHook
    } `additionalKeysP` myAddKeys

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults = def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        startupHook        = myStartupHook,
        logHook = myLogHook
    }
