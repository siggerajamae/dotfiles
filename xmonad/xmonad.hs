{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeOperators #-}
{-# OPTIONS_GHC -fno-warn-missing-signatures -fno-warn-orphans #-}

module XMonad.Config (defaultConfig, Default (..)) where

-- Useful imports
import Data.Bits ((.|.))
import Data.Default.Class
import qualified Data.Map as M
import Data.Monoid
import Graphics.X11.Xlib
import Graphics.X11.Xlib.Extras
import System.Exit
import XMonad.Core as XMonad hiding
  ( borderWidth,
    clickJustFocuses,
    clientMask,
    focusFollowsMouse,
    focusedBorderColor,
    handleEventHook,
    keys,
    layoutHook,
    logHook,
    manageHook,
    modMask,
    mouseBindings,
    normalBorderColor,
    rootMask,
    startupHook,
    terminal,
    workspaces,
  )
import qualified XMonad.Core as XMonad
  ( borderWidth,
    clickJustFocuses,
    clientMask,
    focusFollowsMouse,
    focusedBorderColor,
    handleEventHook,
    keys,
    layoutHook,
    logHook,
    manageHook,
    modMask,
    mouseBindings,
    normalBorderColor,
    rootMask,
    startupHook,
    terminal,
    workspaces,
  )
import XMonad.Layout
import XMonad.ManageHook
import XMonad.Operations
import qualified XMonad.StackSet as W

workspaces :: [WorkspaceId]
workspaces = map show [1 .. 9 :: Int]

defaultModMask :: KeyMask
defaultModMask = mod4Mask

-- Width of the window border in pixels.
borderWidth :: Dimension
borderWidth = 2

-- Border colors for unfocused and focused windows, respectively.
normalBorderColor, focusedBorderColor :: String
normalBorderColor = "gray"
focusedBorderColor = "red"

-- Window rules
manageHook :: ManageHook
manageHook =
  composeAll
    [className =? "pavucontrol" --> doFloat]

-- Logging
logHook :: X ()
logHook = return ()

-- Event handling
handleEventHook :: Event -> X All
handleEventHook _ = return (All True)

-- Perform an arbitrary action at xmonad startup.
startupHook :: X ()
startupHook = return ()

------------------------------------------------------------------------
-- Extensible layouts
--
-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--

-- | The available layouts.  Note that each layout is separated by |||, which
-- denotes layout choice.
layout = tiled ||| Mirror tiled ||| Full
  where
    -- default tiling algorithm partitions the screen into two panes
    tiled = Tall nmaster delta ratio

    -- The default number of windows in the master pane
    nmaster = 1

    -- Default proportion of screen occupied by master pane
    ratio = 1 / 2

    -- Percent of screen to increment by when resizing panes
    delta = 3 / 100

------------------------------------------------------------------------
-- Event Masks:

-- | The client events that xmonad is interested in
clientMask :: EventMask
clientMask = structureNotifyMask .|. enterWindowMask .|. propertyChangeMask

-- | The root events that xmonad is interested in
rootMask :: EventMask
rootMask =
  substructureRedirectMask
    .|. substructureNotifyMask
    .|. enterWindowMask
    .|. leaveWindowMask
    .|. structureNotifyMask
    .|. buttonPressMask

------------------------------------------------------------------------
-- Key bindings:

-- | The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
terminal :: String
terminal = "xterm"

-- | Whether focus follows the mouse pointer.
focusFollowsMouse :: Bool
focusFollowsMouse = True

-- | Whether a mouse click select the focus or is just passed to the window
clickJustFocuses :: Bool
clickJustFocuses = True

-- | The xmonad key bindings. Add, modify or remove key bindings here.
--
-- (The comment formatting character is used when generating the manpage)
keys :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
keys conf@(XConfig {XMonad.modMask = modMask}) =
  M.fromList $
    -- launching and killing programs
    [ ((modMask .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf), -- %! Launch terminal
      ((modMask, xK_p), spawn "dmenu_run"), -- %! Launch dmenu
      ((modMask .|. shiftMask, xK_p), spawn "gmrun"), -- %! Launch gmrun
      ((modMask .|. shiftMask, xK_c), kill), -- %! Close the focused window
      ((modMask, xK_space), sendMessage NextLayout), -- %! Rotate through the available layout algorithms
      ((modMask .|. shiftMask, xK_space), setLayout $ XMonad.layoutHook conf), -- %!  Reset the layouts on the current workspace to default
      ((modMask, xK_n), refresh), -- %! Resize viewed windows to the correct size

      -- move focus up or down the window stack
      ((modMask, xK_Tab), windows W.focusDown), -- %! Move focus to the next window
      ((modMask .|. shiftMask, xK_Tab), windows W.focusUp), -- %! Move focus to the previous window
      ((modMask, xK_j), windows W.focusDown), -- %! Move focus to the next window
      ((modMask, xK_k), windows W.focusUp), -- %! Move focus to the previous window
      ((modMask, xK_m), windows W.focusMaster), -- %! Move focus to the master window

      -- modifying the window order
      ((modMask, xK_Return), windows W.swapMaster), -- %! Swap the focused window and the master window
      ((modMask .|. shiftMask, xK_j), windows W.swapDown), -- %! Swap the focused window with the next window
      ((modMask .|. shiftMask, xK_k), windows W.swapUp), -- %! Swap the focused window with the previous window

      -- resizing the master/slave ratio
      ((modMask, xK_h), sendMessage Shrink), -- %! Shrink the master area
      ((modMask, xK_l), sendMessage Expand), -- %! Expand the master area

      -- floating layer support
      ((modMask, xK_t), withFocused $ windows . W.sink), -- %! Push window back into tiling

      -- increase or decrease number of windows in the master area
      ((modMask, xK_comma), sendMessage (IncMasterN 1)), -- %! Increment the number of windows in the master area
      ((modMask, xK_period), sendMessage (IncMasterN (-1))), -- %! Deincrement the number of windows in the master area

      -- quit, or restart
      ((modMask .|. shiftMask, xK_q), io exitSuccess), -- %! Quit xmonad
      ((modMask, xK_q), spawn "if type xmonad; then xmonad --recompile && xmonad --restart; else xmessage xmonad not in \\$PATH: \"$PATH\"; fi"), -- %! Restart xmonad
      ((modMask .|. shiftMask, xK_slash), helpCommand), -- %! Run xmessage with a summary of the default keybindings (useful for beginners)
      -- repeat the binding for non-American layout keyboards
      ((modMask, xK_question), helpCommand) -- %! Run xmessage with a summary of the default keybindings (useful for beginners)
    ]
      ++
      -- mod-[1..9] %! Switch to workspace N
      -- mod-shift-[1..9] %! Move client to workspace N
      [ ((m .|. modMask, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9],
          (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
      ]
      ++
      -- mod-{w,e,r} %! Switch to physical/Xinerama screens 1, 2, or 3
      -- mod-shift-{w,e,r} %! Move client to screen 1, 2, or 3
      [ ((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0 ..],
          (f, m) <- [(W.view, 0), (W.shift, shiftMask)]
      ]
  where
    helpCommand :: X ()
    helpCommand = xmessage help

-- | Mouse bindings: default actions bound to mouse events
mouseBindings :: XConfig Layout -> M.Map (KeyMask, Button) (Window -> X ())
mouseBindings (XConfig {XMonad.modMask = modMask}) =
  M.fromList
    -- mod-button1 %! Set the window to floating mode and move by dragging
    [ ( (modMask, button1),
        \w ->
          focus w
            >> mouseMoveWindow w
            >> windows W.shiftMaster
      ),
      -- mod-button2 %! Raise the window to the top of the stack
      ((modMask, button2), windows . (W.shiftMaster .) . W.focusWindow),
      -- mod-button3 %! Set the window to floating mode and resize by dragging
      ( (modMask, button3),
        \w ->
          focus w
            >> mouseResizeWindow w
            >> windows W.shiftMaster
      )
      -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

instance (a ~ Choose Tall (Choose (Mirror Tall) Full)) => Default (XConfig a) where
  def =
    XConfig
      { XMonad.borderWidth = borderWidth,
        XMonad.workspaces = workspaces,
        XMonad.layoutHook = layout,
        XMonad.terminal = terminal,
        XMonad.normalBorderColor = normalBorderColor,
        XMonad.focusedBorderColor = focusedBorderColor,
        XMonad.modMask = defaultModMask,
        XMonad.keys = keys,
        XMonad.logHook = logHook,
        XMonad.startupHook = startupHook,
        XMonad.mouseBindings = mouseBindings,
        XMonad.manageHook = manageHook,
        XMonad.handleEventHook = handleEventHook,
        XMonad.focusFollowsMouse = focusFollowsMouse,
        XMonad.clickJustFocuses = clickJustFocuses,
        XMonad.clientMask = clientMask,
        XMonad.rootMask = rootMask,
        XMonad.handleExtraArgs = \xs theConf -> case xs of
          [] -> return theConf
          _ -> fail ("unrecognized flags:" ++ show xs),
        XMonad.extensibleConf = M.empty
      }

-- | The default set of configuration values itself
{-# DEPRECATED defaultConfig "Use def (from Data.Default, and re-exported by XMonad and XMonad.Config) instead." #-}
defaultConfig :: XConfig (Choose Tall (Choose (Mirror Tall) Full))
defaultConfig = def

-- | Finally, a copy of the default bindings in simple textual tabular format.
help :: String
help =
  unlines
    [ "The default modifier key is 'alt'. Default keybindings:",
      "",
      "-- launching and killing programs",
      "mod-Shift-Enter  Launch xterminal",
      "mod-p            Launch dmenu",
      "mod-Shift-p      Launch gmrun",
      "mod-Shift-c      Close/kill the focused window",
      "mod-Space        Rotate through the available layout algorithms",
      "mod-Shift-Space  Reset the layouts on the current workSpace to default",
      "mod-n            Resize/refresh viewed windows to the correct size",
      "mod-Shift-/      Show this help message with the default keybindings",
      "",
      "-- move focus up or down the window stack",
      "mod-Tab        Move focus to the next window",
      "mod-Shift-Tab  Move focus to the previous window",
      "mod-j          Move focus to the next window",
      "mod-k          Move focus to the previous window",
      "mod-m          Move focus to the master window",
      "",
      "-- modifying the window order",
      "mod-Return   Swap the focused window and the master window",
      "mod-Shift-j  Swap the focused window with the next window",
      "mod-Shift-k  Swap the focused window with the previous window",
      "",
      "-- resizing the master/slave ratio",
      "mod-h  Shrink the master area",
      "mod-l  Expand the master area",
      "",
      "-- floating layer support",
      "mod-t  Push window back into tiling; unfloat and re-tile it",
      "",
      "-- increase or decrease number of windows in the master area",
      "mod-comma  (mod-,)   Increment the number of windows in the master area",
      "mod-period (mod-.)   Deincrement the number of windows in the master area",
      "",
      "-- quit, or restart",
      "mod-Shift-q  Quit xmonad",
      "mod-q        Restart xmonad",
      "",
      "-- Workspaces & screens",
      "mod-[1..9]         Switch to workSpace N",
      "mod-Shift-[1..9]   Move client to workspace N",
      "mod-{w,e,r}        Switch to physical/Xinerama screens 1, 2, or 3",
      "mod-Shift-{w,e,r}  Move client to screen 1, 2, or 3",
      "",
      "-- Mouse bindings: default actions bound to mouse events",
      "mod-button1  Set the window to floating mode and move by dragging",
      "mod-button2  Raise the window to the top of the stack",
      "mod-button3  Set the window to floating mode and resize by dragging"
    ]
