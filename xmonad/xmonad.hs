import XMonad
import Data.Monoid
import System.Exit

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Util.Run
import XMonad.Util.SpawnOnce
import XMonad.Util.EZConfig
import XMonad.Layout.Renamed
import XMonad.Layout.Spacing
import XMonad.Layout.ResizableTile
import XMonad.Layout.TwoPanePersistent
import XMonad.Layout.Grid
import XMonad.Layout.NoBorders
import XMonad.Hooks.RefocusLast
import XMonad.Layout.FocusTracking
import XMonad.Layout.CircleEx
import XMonad.Layout.Tabbed

-- Colors
background = "#1a1b26"
foreground = "#565f89"
color1 = "#2ac3de"
color2 = "#73daca"
color3 = "#9ece6a"
color4 = "#e0af68"
color5 = "#f7768e"

-- Terminal
myTerminal :: String
myTerminal = "kitty"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
myBorderWidth = 1

-- width of the spacing between windows in pixels
gapWidth = 4

-- modMask
myModMask :: KeyMask
myModMask = mod4Mask

-- Workspaces
myWorkspaces    = ["0","1","2","3","4","5","6","7","8","9"]

-- Border colors
myNormalBorderColor  = foreground
myFocusedBorderColor = color1

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
myKeys :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
myKeys c = mkKeymap c $
  [ ("M-<Space>", spawn "dmenu_run") -- launch dmenu
  , ("M-d", spawn $ terminal c) -- launch a terminal
  , ("M-c", spawn "emacsclient -c") -- launch emacs
  , ("<Print>", spawn "magick import ~/Pictures/Screenshots/capture$(date +%d-%m-%G-%H-%M-%S-%N.png)") -- take a screenshot
  , ("M-k", kill) -- close focused window
  , ("M-x M-r", refresh) -- Resize viewed windows to the correct size
  , ("M-x r", setLayout $ layoutHook c) -- Reset the layouts on the current workspace to default

  -- movement
  , ("M-a", windows W.focusUp) -- Move focus to the previous window in stack
  , ("M-e", windows W.focusDown) -- Move focus to the next window in stack
  , ("M-<Return>", windows W.focusMaster) -- Move focus to the master window
  , ("M-o", toggleFocus) -- Move focus with last focused window

  -- swaping
  , ("M-S-a", windows W.swapUp) -- Swap to the previous window in stack
  , ("M-S-e", windows W.swapDown) -- Swap to the next window in stack
  , ("M-S-<Return>", windows W.swapMaster) -- Swap the focused window and the master window
  , ("M-S-o", swapWithLast) -- Swap with last focused window

  -- resizing
  , ("M-p", sendMessage MirrorExpand) -- Increase window up
  , ("M-n", sendMessage MirrorShrink) -- Increase window down
  , ("M-b", sendMessage Shrink) -- Increase window left
  , ("M-f", sendMessage Expand) -- Increase window right

  --Toggle
  , ("M-t r", toggleRefocusing) -- Enable/disable refocusing

  --Layout
  , ("M-l t", sendMessage $ JumpToLayout "vtall") -- Switch to vertical tall layout
  , ("M-l S-t", sendMessage $ JumpToLayout "htall") -- Switch to horizontal tall layout
  , ("M-l d", sendMessage $ JumpToLayout "vdivided") -- Switch to vertical divided layout
  , ("M-l S-d", sendMessage $ JumpToLayout "hdivided") -- Switch to horizontal divided layout
  , ("M-l g", sendMessage $ JumpToLayout "grid") -- Switch to grid layout
  , ("M-l c", sendMessage $ JumpToLayout "wheel") -- Switch to circle layout
  , ("M-l w", sendMessage $ JumpToLayout "tab") -- Switch to tabbed layout
  , ("M-l f", sendMessage $ JumpToLayout "afull") -- Switch to avoidStruts full layout
  , ("M-l S-f", sendMessage $ JumpToLayout "full") -- Switch to full layout

  -- Other
  , ("M-S-t", withFocused $ windows . W.sink) -- Push window back into tiling
  , ("M-,", sendMessage (IncMasterN 1)) -- Increment the number of windows in the master area
  , ("M-.", sendMessage (IncMasterN (-1))) -- Decrement the number of windows in the master area
  , ("M-S-q", io exitSuccess) -- Quit xmonad
  , ("M-q", spawn "xmonad --recompile; xmonad --restart") -- Restart xmonad
  ]
  ++
  -- Keybindings for workspaces
  [ ("M-" ++ show i, windows $ W.greedyView ws) -- Cambiar de workspace
  | (i, ws) <- zip [0..9] (workspaces c)
  ]
  ++
  [ ("M-S-" ++ show i, windows $ W.shift ws) -- Mover ventana a una workspace
  | (i, ws) <- zip [0..9] (workspaces c)
  ]
  ++
  -- Keybindings for screens
  [ ("M-x a", screenWorkspace 0 >>= flip whenJust (windows . W.view))
  , ("M-x m", screenWorkspace 1 >>= flip whenJust (windows . W.view))
  , ("M-x e", screenWorkspace 2 >>= flip whenJust (windows . W.view))
  ]
  ++
  [ ("M-x M-a", screenWorkspace 0 >>= flip whenJust (windows . W.shift))
  , ("M-x M-m", screenWorkspace 1 >>= flip whenJust (windows . W.shift))
  , ("M-x M-e", screenWorkspace 2 >>= flip whenJust (windows . W.shift))
  ]

------------------------------------------------------------------------
-- Mouse bindings
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList
  [ ((modm .|. shiftMask, button1), \w -> focus w >> mouseMoveWindow w >> windows W.shiftMaster)
  , ((modm .|. shiftMask, button2), \w -> focus w >> kill)
  , ((modm .|. shiftMask, button3), \w -> focus w >> mouseResizeWindow w >> windows W.shiftMaster)
  ]

------------------------------------------------------------------------
-- tabbed theme
myTabTheme = def
  { inactiveColor = background
  , activeColor = background
  , activeBorderColor = color1
  , inactiveBorderColor = foreground
  , activeTextColor = color1
  , inactiveTextColor = foreground
  }

-- Layouts:
vtall =
  renamed [Replace "tall"]
  $ avoidStruts
  $ spacingWithEdge gapWidth
  $ ResizableTall 1 (3/100) (1/2) []

htall =
  renamed [Replace "mtall"]
  $ avoidStruts
  $ spacingWithEdge gapWidth
  $ Mirror vtall

vdivided =
  renamed [Replace "divided"]
  $ avoidStruts
  $ spacingWithEdge gapWidth
  $ TwoPanePersistent Nothing (3/100) (1/2)

hdivided =
  renamed [Replace "mdivided"]
  $ avoidStruts
  $ spacingWithEdge gapWidth
  $ Mirror vdivided

grid =
  renamed [Replace "grid"]
  $ avoidStruts
  $ spacingWithEdge gapWidth
  Grid

wheel =
  renamed [Replace "circle"]
  $ avoidStruts
  $ spacingWithEdge gapWidth
  circle

tab =
  renamed [Replace "tab"]
  $ avoidStruts
  $ spacingWithEdge gapWidth
  $ tabbed shrinkText myTabTheme

afull =
  renamed [Replace "full"]
  $ avoidStruts
  $ spacingWithEdge gapWidth
  Full

myLayouts =
  named "vtall" vtall |||
  named "htall" htall |||
  named "vdivided" vdivided |||
  named "hdivided" hdivided |||
  named "grid" grid |||
  named "wheel" wheel |||
  named "tab" tab |||
  named "afull" afull |||
  named "full" Full

myLayout = smartBorders $ refocusLastLayoutHook $ focusTracking myLayouts

------------------------------------------------------------------------
-- Window rules:
myManageHook = composeAll
               [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore ]

------------------------------------------------------------------------
-- Event handling
myEventHook = mempty

------------------------------------------------------------------------
-- Status bars and logging
myLogHook = return ()

------------------------------------------------------------------------
-- Startup hook
myStartupHook = do
  spawnOnce "~/.fehbg &"

------------------------------------------------------------------------
-- Main
main :: IO ()
main = do
  _ <- spawnPipe "~/.config/polybar/launch-xmonad.sh"
  _ <- spawnPipe "picom"
  xmonad $ ewmhFullscreen . ewmh $ docks defaults

defaults = def
  { terminal = myTerminal
  , focusFollowsMouse = myFocusFollowsMouse
  , clickJustFocuses = myClickJustFocuses
  , borderWidth = myBorderWidth
  , modMask = myModMask
  , workspaces = myWorkspaces
  , normalBorderColor = myNormalBorderColor
  , focusedBorderColor = myFocusedBorderColor
  , keys = myKeys
  , mouseBindings = myMouseBindings
  , layoutHook = myLayout
  , manageHook = myManageHook
  , handleEventHook = myEventHook
  , logHook = myLogHook
  , startupHook = myStartupHook
  }
