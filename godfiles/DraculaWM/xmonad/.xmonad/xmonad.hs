  -- Base
import XMonad
import System.IO (hPutStrLn)
import System.Exit (exitSuccess)
import qualified XMonad.StackSet as W

    -- Actions
import XMonad.Actions.CopyWindow (kill1, killAllOtherCopies)
import XMonad.Actions.CycleWS (moveTo, shiftTo, WSType(..), nextScreen, prevScreen)
import XMonad.Actions.GridSelect
import XMonad.Actions.MouseResize
import XMonad.Actions.Promote
import XMonad.Actions.RotSlaves (rotSlavesDown, rotAllDown)
import qualified XMonad.Actions.TreeSelect as TS
import XMonad.Actions.WindowGo (runOrRaise)
import XMonad.Actions.WithAll (sinkAll, killAll)
import qualified XMonad.Actions.Search as S

    -- Data
import Data.Char (isSpace)
import Data.Monoid
import Data.Maybe (isJust)
import Data.Tree
import qualified Data.Map as M

    -- Hooks
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, xmobarPP, xmobarColor, shorten, PP(..))
import XMonad.Hooks.EwmhDesktops  -- for some fullscreen events, also for xcomposite in obs.
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ManageDocks (avoidStruts, docksEventHook, manageDocks, ToggleStruts(..))
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat)
import XMonad.Hooks.ServerMode
import XMonad.Hooks.SetWMName
import XMonad.Hooks.WorkspaceHistory

    -- Layouts
import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spiral
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns

    -- Layouts modifiers
import XMonad.Layout.LayoutModifier
import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)
import XMonad.Layout.Magnifier
import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), (??))
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL, MIRROR, NOBORDERS))
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed (renamed, Rename(Replace))
import XMonad.Layout.ShowWName
import XMonad.Layout.Spacing
import XMonad.Layout.WindowArranger (windowArrange, WindowArrangerMsg(..))
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))
import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))

    -- Prompt
import XMonad.Prompt
import XMonad.Prompt.Input
import XMonad.Prompt.FuzzyMatch
import XMonad.Prompt.Man
import XMonad.Prompt.Pass
import XMonad.Prompt.Shell (shellPrompt)
import XMonad.Prompt.Ssh
import XMonad.Prompt.XMonad
import Control.Arrow (first)

    -- Utilities
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run (runProcessWithInput, safeSpawn, spawnPipe)
import XMonad.Util.SpawnOnce

myFont :: String
myFont = "xft:Jetbrains Mono:bold:size=9:antialias=true:hinting=true"

myModMask :: KeyMask
myModMask = mod4Mask       -- Sets modkey to super/windows key

myTerminal :: String
myTerminal = "termonad"   -- Sets default terminal

myBrowser :: String
myBrowser = "Browser"               -- Sets qutebrowser as browser for tree select
-- myBrowser = myTerminal ++ " -e lynx " -- Sets lynx as browser for tree select

myEditor :: String
-- myEditor = "emacsclient -c -a emacs "  -- Sets emacs as editor for tree select
myEditor = myTerminal ++ " -e nvim "    -- Sets vim as editor for tree select

myBorderWidth :: Dimension
myBorderWidth = 2          -- Sets border width for windows

myNormColor :: String
myNormColor   = "#282a36"  -- Border color of normal windows

myFocusColor :: String
myFocusColor  = "#bd93f9"  -- Border color of focused windows

altMask :: KeyMask
altMask = mod1Mask         -- Setting this for use in xprompts

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

myStartupHook :: X ()
myStartupHook = do
          spawnOnce "sh ~/.fehbg &"
          spawnOnce "picom &"
          spawnOnce "nm-applet &"
          spawnOnce "volumeicon &"
          spawnOnce "trayer --edge top --align right --widthtype request --padding 2 --SetDockType true --SetPartialStrut true --expand true --transparent true --alpha 0 --tint 0x1a1b26  --height 21 &"
          spawnOnce "xrdb -merge ~/.config/x/xresources"
          -- spawnOnce "/usr/bin/emacs --daemon &"
          -- spawnOnce "kak -d -s mysession &"
          setWMName "Xmonad"

myColorizer :: Window -> Bool -> X (String, String)
myColorizer = colorRangeFromClassName
                  (0x28,0x2c,0x34) -- lowest inactive bg
                  (0x28,0x2c,0x34) -- highest inactive bg
                  (0xc7,0x92,0xea) -- active bg
                  (0xc0,0xa7,0x9a) -- inactive fg
                  (0x28,0x2c,0x34) -- active fg

-- gridSelect menu layout
mygridConfig :: p -> GSConfig Window
mygridConfig colorizer = (buildDefaultGSConfig myColorizer)
    { gs_cellheight   = 40
    , gs_cellwidth    = 200
    , gs_cellpadding  = 6
    , gs_originFractX = 0.5
    , gs_originFractY = 0.5
    , gs_font         = myFont
    }

spawnSelected' :: [(String, String)] -> X ()
spawnSelected' lst = gridselect conf lst >>= flip whenJust spawn
    where conf = def
                   { gs_cellheight   = 40
                   , gs_cellwidth    = 200
                   , gs_cellpadding  = 6
                   , gs_originFractX = 0.5
                   , gs_originFractY = 0.5
                   , gs_font         = myFont
                   }

myAppGrid = [ ("Settings", "st -e bmenu")
                 , ("Music", "st -e ncmpcpp")
                 , ("Editor", "st -e nvim")
                 , ("Browser", "brave-bin")
                 , ("Tasks", "st -e htop")
                 , ("Files", "st -e ranger")
                 , ("Sec Mp3", "gimp")
                 , ("PCManFM", "pcmanfm")
                 ]

treeselectAction :: TS.TSConfig (X ()) -> X ()
treeselectAction a = TS.treeselectAction a
   [ Node (TS.TSNode "+ Info Gathering" "Pentoo Repo" (return ()))
       [ Node (TS.TSNode "Nmap" "The Network Mapper" (spawn "st -e ho nmap")) []
       ]
   , Node (TS.TSNode "+ Vulnerability Access" "Pentoo Repo" (return ()))
       [ Node (TS.TSNode "Lynis" "Security Auditing Tool" (spawn "st -e lynis")) []
       ]
   , Node (TS.TSNode "+ Web Application Analsis" "Pentoo Repo" (return ()))
       [ Node (TS.TSNode "HTtrack" "GNU image manipulation program" (spawn "st -e httrack")) []
       ]
   , Node (TS.TSNode "+ Exploitation tools" "Pentoo Repo" (return ()))
       [ Node (TS.TSNode "Commix" "A privacy-oriented web browser" (spawn "st -e commix")) []
       ]
   , Node (TS.TSNode "+ Reporting Tools" "Pentoo Repo" (return ()))
       [ Node (TS.TSNode "Metagoofil" "Alsa volume control utility" (spawn (myTerminal ++ " -e alsamixer"))) []
       , Node (TS.TSNode "cupycat" "Graphical audio editing program" (spawn "audacity")) []
       ]
   , Node (TS.TSNode "+ Privacy Scripts" "Pentoo Repo" (return ()))
       [ Node (TS.TSNode "ZeroNet" "The Decrypted Internet" (spawn "cd ~/Documents/ZeroNet-linux-dist-linux64 && ./ZeroNet.sh")) []
       , Node (TS.TSNode "ZeroNet" "firefox with zeronet" (spawn "firefox-bin 127.0.0.1:43110/x")) []
       , Node (TS.TSNode "Searx" "Security Auditing Tool" (spawn "firefox-bin sam1431.github.io/startpages/startpage/index.html")) []
       , Node (TS.TSNode "Normal firefox with duckduckgo" "Security Auditing Tool" (spawn "firefox-bin duckduckgo.com")) []
       ]
   , Node (TS.TSNode "+ Automotive" "Pentoo Repo" (return ()))
       [ Node (TS.TSNode "+ Emacs" "Emacs is more than a text editor" (return ()))
           [ Node (TS.TSNode "Emacs Client" "Doom Emacs launched as client" (spawn "emacsclient -c -a emacs")) []
           , Node (TS.TSNode "M-x dired" "File manager for Emacs" (spawn "emacsclient -c -a '' --eval '(dired nil)'")) []
           , Node (TS.TSNode "M-x elfeed" "RSS client for Emacs" (spawn "emacsclient -c -a '' --eval '(elfeed)'")) []
           , Node (TS.TSNode "M-x emms" "Emacs" (spawn "emacsclient -c -a '' --eval '(emms)' --eval '(emms-play-directory-tree \"~/Music/Non-Classical/70s-80s/\")'")) []
           , Node (TS.TSNode "M-x erc" "IRC client for Emacs" (spawn "emacsclient -c -a '' --eval '(erc)'")) []
           , Node (TS.TSNode "M-x eshell" "The Eshell in Emacs" (spawn "emacsclient -c -a '' --eval '(eshell)'")) []
           , Node (TS.TSNode "M-x ibuffer" "Emacs buffer list" (spawn "emacsclient -c -a '' --eval '(ibuffer)'")) []
           , Node (TS.TSNode "M-x mastodon" "Emacs" (spawn "emacsclient -c -a '' --eval '(mastodon)'")) []
           , Node (TS.TSNode "M-x mu4e" "Email client for Emacs" (spawn "emacsclient -c -a '' --eval '(mu4e)'")) []
           , Node (TS.TSNode "M-x vterm" "Emacs" (spawn "emacsclient -c -a '' --eval '(+vterm/here nil))'")) []
           ]
        , Node (TS.TSNode "Python" "Python interactive prompt" (spawn (myTerminal ++ " -e python"))) []
       ]
   , Node (TS.TSNode "+ Digital Forensics" "Pentoo Repo" (return ()))
       [ Node (TS.TSNode "RKhunter" "GPU accelerated terminal" (spawn "alacritty")) []
       ]
   , Node (TS.TSNode "------------------------" "" (spawn "xdotool key Escape")) []
   , Node (TS.TSNode "+ Websites" "A list of Websites I use" (return ()))
       [ Node (TS.TSNode "+ Wikis" "a list of web bookmarks" (return ()))
           [ Node (TS.TSNode "+ Gentoo " "btw, I use Gentoo!" (return ()))
               [ Node (TS.TSNode "Gentoo/Linux homepage" "Gentoo Homepage" (spawn (myBrowser ++ "https://gentoo.org/"))) []
               , Node (TS.TSNode "Gentoo Wiki" "The Best Linux wiki" (spawn (myBrowser ++ "https://wiki.gentoo.org/wiki/Main_Page"))) []
               , Node (TS.TSNode "Gentoo Packages" "Gentoo Packages" (spawn (myBrowser ++ "https://packages.gentoo.org/"))) []
               , Node (TS.TSNode "Gentoo Forums" "Gentoo forums" (spawn (myBrowser ++ "https://forums.gentoo.org/"))) []
               ]
           , Node (TS.TSNode "+ News" "Hacker news and blogs" (return ()))
               [ Node (TS.TSNode "Hacker News" "Hacker News" (spawn (myBrowser ++ "https://thehackernews.com/"))) []
               , Node (TS.TSNode "Kali Linux Tools" "Tools from Kali Linux" (spawn (myBrowser ++ "https://tools.kali.org/tools-listing"))) []
               , Node (TS.TSNode "Parrot OS Blogs" "Blogs from the Parrot OS" (spawn (myBrowser ++ "https://parrotlinux.org/blog/"))) []
               ]
           , Node (TS.TSNode "+ Computer Langs" "Programming Languages" (return ()))
               [ Node (TS.TSNode "+ Haskell" " The Pure Functional Programming Lang" (return ()))
                   [ Node (TS.TSNode "Xmonad" "The Pure Functional Window Manager" (spawn (myBrowser ++ "https://xmonad.org/"))) []
                   , Node (TS.TSNode "Termonad" "The Haskell Terminal" (spawn (myBrowser ++ "https://github.com/cdepillabout/termonad"))) []
                   , Node (TS.TSNode "r/xmonad" "Subreddit for Xmonad" (spawn (myBrowser ++ "https://www.reddit.com/r/xmonad/"))) []
                   ]
               , Node (TS.TSNode "+ C" "The Heart of Gnu/Linux" (return ()))
                   [ Node (TS.TSNode "C" "The Heart of Gnu/Linux" (spawn (myBrowser ++ "https://en.cppreference.com/w/"))) []
                   , Node (TS.TSNode "Dwm" "The Most Minimal WM" (spawn (myBrowser ++ "https://dwm.suckless.org/"))) []
                   , Node (TS.TSNode "Suckless" "The creators of DWM" (spawn (myBrowser ++ "https://suckless.org/"))) []
                   ]
               , Node (TS.TSNode "+ Python" "qtile documentation" (return ()))
                   [ Node (TS.TSNode "Python " "The easiest Lang I guess" (spawn (myBrowser ++ "https://www.python.org/"))) []
                   , Node (TS.TSNode "Qtile" "My 2nd Fav WM" (spawn (myBrowser ++ "https://www.qtile.org"))) []
                   , Node (TS.TSNode "Xonsh" "Shell based on Linux" (spawn (myBrowser ++ "hhttps://xon.sh/"))) []
                   ]
               , Node (TS.TSNode "+ Lua" "I don't Know anything About lua" (return ()))
                   [ Node (TS.TSNode "Lua" "" (spawn (myBrowser ++ "https://www.lua.org/"))) []
                   , Node (TS.TSNode "Awesome" "The lua based wm" (spawn (myBrowser ++ "https://awesomewm.org/"))) []
                   , Node (TS.TSNode "luakit" "the lua based webrowser" (spawn (myBrowser ++ "https://luakit.github.io/"))) []
                   , Node (TS.TSNode "Awesome TUT" "awesome wm tutorial" (spawn (myBrowser ++ "https://awesomewm.org/apidoc/documentation/07-my-first-awesome.md.html"))) []
                   , Node (TS.TSNode "luajit" "the Just In Time compiler"  (spawn (myBrowser ++ "https://luajit.org/"))) []
                   ]
               ]
           ]
       ]         
   , Node (TS.TSNode "+ Config Files" "config files that edit often" (return ()))
       [ Node (TS.TSNode "bashrc" "the bourne again shell" (spawn (myEditor ++ "/home/dt/.bashrc"))) []
       , Node (TS.TSNode "dunst" "dunst notifications" (spawn (myEditor ++ "/home/dt/.config/dunst/dunstrc"))) []
       , Node (TS.TSNode "neovim" "neovim text editor" (spawn (myEditor ++ "/home/dt/.config/nvim/init.vim"))) []
       , Node (TS.TSNode "qtile" "qtile window manager" (spawn (myEditor ++ "/home/dt/.config/qtile/config.py"))) []
       ]
   , Node (TS.TSNode "+ Screenshots" "take a screenshot" (return ()))
       [ Node (TS.TSNode "Quick fullscreen" "take screenshot immediately" (spawn "scrot -d 1 ~/scrot/%Y-%m-%d-@%H-%M-%S-scrot.png")) []
       , Node (TS.TSNode "Delayed fullscreen" "take screenshot in 5 secs" (spawn "scrot -d 5 ~/scrot/%Y-%m-%d-@%H-%M-%S-scrot.png")) []
       , Node (TS.TSNode "Section screenshot" "take screenshot of section" (spawn "scrot -s ~/scrot/%Y-%m-%d-@%H-%M-%S-scrot.png")) []
       ]
   , Node (TS.TSNode "------------------------" "" (spawn "xdotool key Escape")) []
   , Node (TS.TSNode "+ XMonad" "window manager commands" (return ()))
       [ Node (TS.TSNode "+ View Workspaces" "View a specific workspace" (return ()))
         [ Node (TS.TSNode "View 1" "View workspace 1" (spawn "~/.xmonad/xmonadctl 1")) []
         , Node (TS.TSNode "View 2" "View workspace 2" (spawn "~/.xmonad/xmonadctl 3")) []
         , Node (TS.TSNode "View 3" "View workspace 3" (spawn "~/.xmonad/xmonadctl 5")) []
         , Node (TS.TSNode "View 4" "View workspace 4" (spawn "~/.xmonad/xmonadctl 7")) []
         , Node (TS.TSNode "View 5" "View workspace 5" (spawn "~/.xmonad/xmonadctl 9")) []
         , Node (TS.TSNode "View 6" "View workspace 6" (spawn "~/.xmonad/xmonadctl 11")) []
         , Node (TS.TSNode "View 7" "View workspace 7" (spawn "~/.xmonad/xmonadctl 13")) []
         , Node (TS.TSNode "View 8" "View workspace 8" (spawn "~/.xmonad/xmonadctl 15")) []
         , Node (TS.TSNode "View 9" "View workspace 9" (spawn "~/.xmonad/xmonadctl 17")) []
         ]
       , Node (TS.TSNode "+ Shift Workspaces" "Send focused window to specific workspace" (return ()))
         [ Node (TS.TSNode "View 1" "View workspace 1" (spawn "~/.xmonad/xmonadctl 2")) []
         , Node (TS.TSNode "View 2" "View workspace 2" (spawn "~/.xmonad/xmonadctl 4")) []
         , Node (TS.TSNode "View 3" "View workspace 3" (spawn "~/.xmonad/xmonadctl 6")) []
         , Node (TS.TSNode "View 4" "View workspace 4" (spawn "~/.xmonad/xmonadctl 8")) []
         , Node (TS.TSNode "View 5" "View workspace 5" (spawn "~/.xmonad/xmonadctl 10")) []
         , Node (TS.TSNode "View 6" "View workspace 6" (spawn "~/.xmonad/xmonadctl 12")) []
         , Node (TS.TSNode "View 7" "View workspace 7" (spawn "~/.xmonad/xmonadctl 14")) []
         , Node (TS.TSNode "View 8" "View workspace 8" (spawn "~/.xmonad/xmonadctl 16")) []
         , Node (TS.TSNode "View 9" "View workspace 9" (spawn "~/.xmonad/xmonadctl 18")) []
         ]
       , Node (TS.TSNode "Next layout" "Switch to next layout" (spawn "~/.xmonad/xmonadctl next-layout")) []
       , Node (TS.TSNode "Recompile" "Recompile XMonad" (spawn "xmonad --recompile")) []
       , Node (TS.TSNode "Restart" "Restart XMonad" (spawn "xmonad --restart")) []
       , Node (TS.TSNode "Quit" "Restart XMonad" (io exitSuccess)) []
       ]
   ]

tsDefaultConfig :: TS.TSConfig a
tsDefaultConfig = TS.TSConfig { TS.ts_hidechildren = True
                              , TS.ts_background   = 0xdd282c34
                              , TS.ts_font         = myFont
                              , TS.ts_node         = (0xfff8f8f2, 0xff1c1f24)
                              , TS.ts_nodealt      = (0xfff8f8f2, 0xff282c34)
                              , TS.ts_highlight    = (0xffffffff, 0xff755999)
                              , TS.ts_extra        = 0xffd0d0d0
                              , TS.ts_node_width   = 200
                              , TS.ts_node_height  = 20
                              , TS.ts_originX      = 100
                              , TS.ts_originY      = 100
                              , TS.ts_indent       = 80
                              , TS.ts_navigate     = myTreeNavigation
                              }

myTreeNavigation = M.fromList
    [ ((0, xK_Escape),   TS.cancel)
    , ((0, xK_Return),   TS.select)
    , ((0, xK_space),    TS.select)
    , ((0, xK_Up),       TS.movePrev)
    , ((0, xK_Down),     TS.moveNext)
    , ((0, xK_Left),     TS.moveParent)
    , ((0, xK_Right),    TS.moveChild)
    , ((0, xK_k),        TS.movePrev)
    , ((0, xK_j),        TS.moveNext)
    , ((0, xK_h),        TS.moveParent)
    , ((0, xK_l),        TS.moveChild)
    , ((0, xK_o),        TS.moveHistBack)
    , ((0, xK_i),        TS.moveHistForward)
    ]

dtXPConfig :: XPConfig
dtXPConfig = def
      { font                = myFont
      , bgColor             = "#1a1b26"
      , fgColor             = "#f8f8f2"
      , bgHLight            = "#ff79c6"
      , fgHLight            = "#1a1b26"
      , borderColor         = "#535974"
      , promptBorderWidth   = 0
      , promptKeymap        = dtXPKeymap
      , position            = Top
      -- , position            = CenteredAt { xpCenterY = 0.3, xpWidth = 0.3 }
      , height              = 21
      , historySize         = 256
      , historyFilter       = id
      , defaultText         = []
      , autoComplete        = Just 100000  -- set Just 100000 for .1 sec
      , showCompletionOnTab = False
      -- , searchPredicate     = isPrefixOf
      , searchPredicate     = fuzzyMatch
      , alwaysHighlight     = True
      , maxComplRows        = Nothing      -- set to Just 5 for 5 rows
      }

-- The same config above minus the autocomplete feature which is annoying
-- on certain Xprompts, like the search engine prompts.
dtXPConfig' :: XPConfig
dtXPConfig' = dtXPConfig
      { autoComplete        = Nothing
      }

-- A list of all of the standard Xmonad prompts and a key press assigned to them.
-- These are used in conjunction with keybinding I set later in the config.
promptList :: [(String, XPConfig -> X ())]
promptList = [ ("m", manPrompt)          -- manpages prompt
             , ("p", passPrompt)         -- get passwords (requires 'pass')
             , ("g", passGeneratePrompt) -- generate passwords (requires 'pass')
             , ("r", passRemovePrompt)   -- remove passwords (requires 'pass')
             , ("s", sshPrompt)          -- ssh prompt
             , ("x", xmonadPrompt)       -- xmonad prompt
             ]

-- Same as the above list except this is for my custom prompts.
promptList' :: [(String, XPConfig -> String -> X (), String)]
promptList' = [ ("c", calcPrompt, "qalc")         -- requires qalculate-gtk
              ]

calcPrompt c ans =
    inputPrompt c (trim ans) ?+ \input ->
        liftIO(runProcessWithInput "qalc" [input] "") >>= calcPrompt c
    where
        trim  = f . f
            where f = reverse . dropWhile isSpace

dtXPKeymap :: M.Map (KeyMask,KeySym) (XP ())
dtXPKeymap = M.fromList $
     map (first $ (,) controlMask)   -- control + <key>
     [ (xK_z, killBefore)            -- kill line backwards
     , (xK_k, killAfter)             -- kill line forwards
     , (xK_a, startOfLine)           -- move to the beginning of the line
     , (xK_e, endOfLine)             -- move to the end of the line
     , (xK_m, deleteString Next)     -- delete a character foward
     , (xK_b, moveCursor Prev)       -- move cursor forward
     , (xK_f, moveCursor Next)       -- move cursor backward
     , (xK_BackSpace, killWord Prev) -- kill the previous word
     , (xK_y, pasteString)           -- paste a string
     , (xK_g, quit)                  -- quit out of prompt
     , (xK_bracketleft, quit)
     ]
     ++
     map (first $ (,) altMask)       -- meta key + <key>
     [ (xK_BackSpace, killWord Prev) -- kill the prev word
     , (xK_f, moveWord Next)         -- move a word forward
     , (xK_b, moveWord Prev)         -- move a word backward
     , (xK_d, killWord Next)         -- kill the next word
     , (xK_n, moveHistory W.focusUp')   -- move up thru history
     , (xK_p, moveHistory W.focusDown') -- move down thru history
     ]
     ++
     map (first $ (,) 0) -- <key>
     [ (xK_Return, setSuccess True >> setDone True)
     , (xK_KP_Enter, setSuccess True >> setDone True)
     , (xK_BackSpace, deleteString Prev)
     , (xK_Delete, deleteString Next)
     , (xK_Left, moveCursor Prev)
     , (xK_Right, moveCursor Next)
     , (xK_Home, startOfLine)
     , (xK_End, endOfLine)
     , (xK_Down, moveHistory W.focusUp')
     , (xK_Up, moveHistory W.focusDown')
     , (xK_Escape, quit)
     ]

archwiki, ebay, news, reddit, urban :: S.SearchEngine

archwiki = S.searchEngine "archwiki" "https://wiki.archlinux.org/index.php?search="
ebay     = S.searchEngine "ebay" "https://www.ebay.com/sch/i.html?_nkw="
news     = S.searchEngine "news" "https://news.google.com/search?q="
reddit   = S.searchEngine "reddit" "https://www.reddit.com/search/?q="
urban    = S.searchEngine "urban" "https://www.urbandictionary.com/define.php?term="

-- This is the list of search engines that I want to use. Some are from
-- XMonad.Actions.Search, and some are the ones that I added above.
searchList :: [(String, S.SearchEngine)]
searchList = [ ("a", archwiki)
             , ("d", S.duckduckgo)
             , ("e", ebay)
             , ("g", S.google)
             , ("h", S.hoogle)
             , ("i", S.images)
             , ("n", news)
             , ("r", reddit)
             , ("s", S.stackage)
             , ("t", S.thesaurus)
             , ("v", S.vocabulary)
             , ("b", S.wayback)
             , ("u", urban)
             , ("w", S.wikipedia)
             , ("y", S.youtube)
             , ("z", S.amazon)
             ]

myScratchPads :: [NamedScratchpad]
myScratchPads = [ NS "terminal" spawnTerm findTerm manageTerm
                , NS "mocp" spawnMocp findMocp manageMocp
                ]
  where
    spawnTerm  = myTerminal ++ " -n scratchpad"
    findTerm   = resource =? "scratchpad"
    manageTerm = customFloating $ W.RationalRect l t w h
               where
                 h = 0.9
                 w = 0.9
                 t = 0.95 -h
                 l = 0.95 -w
    spawnMocp  = myTerminal ++ " -n mocp 'mocp'"
    findMocp   = resource =? "mocp"
    manageMocp = customFloating $ W.RationalRect l t w h
               where
                 h = 0.9
                 w = 0.9
                 t = 0.95 -h
                 l = 0.95 -w

mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

-- Below is a variation of the above except no borders are applied
-- if fewer than two windows. So a single window has no gaps.
mySpacing' :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing' i = spacingRaw True (Border i i i i) True (Border i i i i) True

-- Defining a bunch of layouts, many that I don't use.
tall     = renamed [Replace "tall"]
           $ limitWindows 12
           $ mySpacing 5 
           $ ResizableTall 1 (3/100) (1/2) []
magnify  = renamed [Replace "magnify"]
           $ magnifier
           $ limitWindows 12
           $ mySpacing 8
           $ ResizableTall 1 (3/100) (1/2) []
monocle  = renamed [Replace "monocle"]
           $ limitWindows 20 Full
floats   = renamed [Replace "floats"]
           $ limitWindows 20 simplestFloat
grid     = renamed [Replace "grid"]
           $ limitWindows 12
           $ mySpacing 8
           $ mkToggle (single MIRROR)
           $ Grid (16/10)
spirals  = renamed [Replace "spirals"]
           $ mySpacing' 8
           $ spiral (6/7)
threeCol = renamed [Replace "threeCol"]
           $ limitWindows 7
           $ mySpacing' 4
           $ ThreeCol 1 (3/100) (1/2)
threeRow = renamed [Replace "threeRow"]
           $ limitWindows 7
           $ mySpacing' 4
           -- Mirror takes a layout and rotates it by 90 degrees.
           -- So we are applying Mirror to the ThreeCol layout.
           $ Mirror
           $ ThreeCol 1 (3/100) (1/2)
tabs     = renamed [Replace "tabs"]
           -- I cannot add spacing to this layout because it will
           -- add spacing between window and tabs which looks bad.
           $ tabbed shrinkText myTabConfig
  where
    myTabConfig = def { fontName            = "xft:Mononoki Nerd Font:regular:pixelsize=11"
                      , activeColor         = "#282c34"
                      , inactiveColor       = "#3e445e"
                      , activeBorderColor   = "#bd93f9"
                      , inactiveBorderColor = "#282a36"
                      , activeTextColor     = "#ffffff"
                      , inactiveTextColor   = "#d0d0d0"
                      }

-- Theme for showWName which prints current workspace when you change workspaces.
myShowWNameTheme :: SWNConfig
myShowWNameTheme = def
    { swn_font              = "xft:Sans:bold:size=60"
    , swn_fade              = 1.0
    , swn_bgcolor           = "#000000"
    , swn_color             = "#FFFFFF"
    }

-- The layout hook
myLayoutHook = avoidStruts $ mouseResize $ windowArrange $ T.toggleLayouts floats $
               mkToggle (NBFULL ?? NOBORDERS ?? EOT) myDefaultLayout
             where
               -- I've commented out the layouts I don't use.
               myDefaultLayout =     tall
                                 ||| magnify
                                 ||| noBorders monocle
                                 ||| floats
                                 -- ||| grid
                                 ||| noBorders tabs
                                 -- ||| spirals
                                 -- ||| threeCol
                                 -- ||| threeRow

xmobarEscape :: String -> String
xmobarEscape = concatMap doubleLts
  where
        doubleLts '<' = "<<"
        doubleLts x   = [x]

myWorkspaces :: [String]
myWorkspaces = clickable . (map xmobarEscape)
               -- $ ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
               $ ["dev", "www", "sys", "doc", "vbox", "chat", "mus", "vid", "gfx"]
  where
        clickable l = [ "<action=xdotool key super+" ++ show (n) ++ "> " ++ ws ++ " </action>" |
                      (i,ws) <- zip [1..9] l,
                      let n = i ]

myManageHook :: XMonad.Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll
     -- using 'doShift ( myWorkspaces !! 7)' sends program to workspace 8!
     -- I'm doing it this way because otherwise I would have to write out
     -- the full name of my workspaces.
     [ className =? "htop"     --> doShift ( myWorkspaces !! 7 )
     , title =? "firefox"     --> doShift ( myWorkspaces !! 1 )
     , className =? "mpv"     --> doShift ( myWorkspaces !! 7 )
     -- , className =? "vlc"     --> doShift ( myWorkspaces !! 7 )
     , className =? "Gimp"    --> doShift ( myWorkspaces !! 8 )
     , className =? "Gimp"    --> doFloat
     , title =? "Oracle VM VirtualBox Manager"     --> doFloat
     , className =? "VirtualBox Manager" --> doShift  ( myWorkspaces !! 4 )
     , (className =? "firefox" <&&> resource =? "Dialog") --> doFloat  -- Float Firefox Dialog
     ] <+> namedScratchpadManageHook myScratchPads

myLogHook :: X ()
myLogHook = fadeInactiveLogHook fadeAmount
    where fadeAmount = 1.0

myKeys :: [(String, X ())]
myKeys =
    -- Xmonad
        [ ("M-C-r", spawn "xmonad --restart")      -- Recompiles xmonad
        , ("M-S-r", spawn "xmonad --recompile && xmonad --restart && herbe 'XMONAD' 'Recompiled and Restarted XmonadWM'")        -- Restarts xmonad
        , ("M-S-q", io exitSuccess)                  -- Quits xmonad

    -- Open my preferred terminal
        , ("M-S-<Return>", spawn myTerminal)

    -- Run Prompt
        , ("M-<Return>", shellPrompt dtXPConfig)   -- Shell Prompt

    -- Windows
        , ("M-x", kill1)                           -- Kill the currently focused client
        , ("M-S-a", killAll)                         -- Kill all windows on current workspace

    -- Floating windows
        , ("M-f", sendMessage (T.Toggle "floats"))       -- Toggles my 'floats' layout
        , ("M-w", withFocused $ windows . W.sink) -- Push floating window back to tile
        , ("M-S-<Delete>", sinkAll)                      -- Push ALL floating windows to tile

    -- Grid Select (CTRL-g followed by a key)
        , ("C-g g", spawnSelected' myAppGrid)                 -- grid select favorite apps
        , ("C-M1-g", spawnSelected' myAppGrid)                -- grid select favorite apps
        , ("C-g t", goToSelected $ mygridConfig myColorizer)  -- goto selected window
        , ("C-g b", bringSelected $ mygridConfig myColorizer) -- bring selected window

    -- Tree Select/
        , ("C-t t", treeselectAction tsDefaultConfig)
        , ("C-M1-t", treeselectAction tsDefaultConfig)

    -- Windows navigation
        , ("M-m", windows W.focusMaster)     -- Move focus to the master window
        , ("M-j", windows W.focusDown)       -- Move focus to the next window
        , ("M-k", windows W.focusUp)         -- Move focus to the prev window
        --, ("M-S-m", windows W.swapMaster)    -- Swap the focused window and the master window
        , ("M-C-j", windows W.swapDown)      -- Swap focused window with next window
        , ("M-C-k", windows W.swapUp)        -- Swap focused window with prev window
        , ("M-<Backspace>", promote)         -- Moves focused window to master, others maintain order
        , ("M1-S-<Tab>", rotSlavesDown)      -- Rotate all windows except master and keep focus in place
        , ("M1-C-<Tab>", rotAllDown)         -- Rotate all the windows in the current stack
        --, ("M-S-s", windows copyToAll)
        , ("M-C-s", killAllOtherCopies)

        -- Layouts
        , ("M-<Tab>", sendMessage NextLayout)                -- Switch to next layout
        , ("M-C-M1-<Up>", sendMessage Arrange)
        , ("M-C-M1-<Down>", sendMessage DeArrange)
        , ("M-<Space>", sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts) -- Toggles noborder/full
        , ("M-S-<Space>", sendMessage ToggleStruts)         -- Toggles struts
        , ("M-S-n", sendMessage $ MT.Toggle NOBORDERS)      -- Toggles noborder
        , ("M-<KP_Multiply>", sendMessage (IncMasterN 1))   -- Increase number of clients in master pane
        , ("M-<KP_Divide>", sendMessage (IncMasterN (-1)))  -- Decrease number of clients in master pane
        , ("M-S-<KP_Multiply>", increaseLimit)              -- Increase number of windows
        , ("M-S-<KP_Divide>.", decreaseLimit)                -- Decrease number of windows

        , ("M-h", sendMessage Shrink)                       -- Shrink horiz window width
        , ("M-l", sendMessage Expand)                       -- Expand horiz window width
        , ("M-C-h", sendMessage MirrorShrink)               -- Shrink vert window width
        , ("M-C-l", sendMessage MirrorExpand)               -- Exoand vert window width

    -- Workspaces
        , ("M-.", nextScreen)  -- Switch focus to next monitor
        , ("M-,", prevScreen)  -- Switch focus to prev monitor
        , ("M-S-<KP_Add>", shiftTo Next nonNSP >> moveTo Next nonNSP)       -- Shifts focused window to next ws
        , ("M-S-<KP_Subtract>", shiftTo Prev nonNSP >> moveTo Prev nonNSP)  -- Shifts focused window to prev ws

    -- Scratchpads
        , ("M-C-<Return>", namedScratchpadAction myScratchPads "terminal")
        , ("M-C-c", namedScratchpadAction myScratchPads "mocp")

    -- Controls for mocp music player.
        , ("M-u p", spawn "mocp --play")
        , ("M-u l", spawn "mocp --next")
        , ("M-u h", spawn "mocp --previous")
        , ("M-u <Space>", spawn "mocp --toggle-pause")

    -- Emacs (CTRL-e followed by a key)
        , ("C-e e", spawn "emacsclient -c -a ''")                            -- start emacs
        , ("C-e b", spawn "emacsclient -c -a '' --eval '(ibuffer)'")         -- list emacs buffers
        , ("C-e d", spawn "emacsclient -c -a '' --eval '(dired nil)'")       -- dired emacs file manager
        , ("C-e i", spawn "emacsclient -c -a '' --eval '(erc)'")             -- erc emacs irc client
        , ("C-e m", spawn "emacsclient -c -a '' --eval '(mu4e)'")            -- mu4e emacs email client
        , ("C-e n", spawn "emacsclient -c -a '' --eval '(elfeed)'")          -- elfeed emacs rss client
        , ("C-e s", spawn "emacsclient -c -a '' --eval '(eshell)'")          -- eshell within emacs
        , ("C-e t", spawn "emacsclient -c -a '' --eval '(mastodon)'")        -- mastodon within emacs
        , ("C-e v", spawn "emacsclient -c -a '' --eval '(+vterm/here nil)'") -- vterm within emacs
        -- emms is an emacs audio player. I set it to auto start playing in a specific directory.
        , ("C-e a", spawn "emacsclient -c -a '' --eval '(emms)' --eval '(emms-play-directory-tree \"~/Music/Non-Classical/70s-80s/\")'")

    --- My Applications (Super+Alt+Key)
        , ("M-M1-a", spawn (myTerminal ++ " -e ncpamixer"))
        , ("M-M1-b", spawn "surf www.youtube.com/c/DistroTube/")
        , ("M-M1-e", spawn (myTerminal ++ " -e neomutt"))
        , ("M-M1-f", spawn (myTerminal ++ " -e sh ./.config/vifm/scripts/vifmrun"))
        , ("M-M1-i", spawn (myTerminal ++ " -e irssi"))
        , ("M-M1-j", spawn (myTerminal ++ " -e joplin"))
        , ("M-M1-l", spawn (myTerminal ++ " -e lynx https://distrotube.com"))
        , ("M-M1-m", spawn (myTerminal ++ " -e mocp"))
        , ("M-M1-n", spawn (myTerminal ++ " -e newsboat"))
        , ("M-M1-p", spawn (myTerminal ++ " -e pianobar"))
        , ("M-M1-r", spawn (myTerminal ++ " -e rtv"))
        , ("M-M1-t", spawn (myTerminal ++ " -e toot curses"))
        , ("M-M1-w", spawn (myTerminal ++ " -e wopr report.xml"))
        , ("M-M1-y", spawn (myTerminal ++ " -e youtube-viewer"))

    -- Multimedia Keys
        , ("<XF86AudioPlay>", spawn "cmus toggle")
        , ("<XF86AudioPrev>", spawn "cmus prev")
        , ("<XF86AudioNext>", spawn "cmus next")
        -- , ("<XF86AudioMute>",   spawn "amixer set Master toggle")  -- Bug prevents it from toggling correctly in 12.04.
        , ("<XF86AudioLowerVolume>", spawn "amixer set Master 5%- unmute")
        , ("<XF86AudioRaiseVolume>", spawn "amixer set Master 5%+ unmute")
        , ("<XF86HomePage>", spawn "firefox")
        , ("<XF86Search>", safeSpawn "firefox" ["https://www.google.com/"])
        , ("<XF86Mail>", runOrRaise "geary" (resource =? "thunderbird"))
        , ("<XF86Calculator>", runOrRaise "gcalctool" (resource =? "gcalctool"))
        , ("<XF86Eject>", spawn "toggleeject")
        , ("<Print>", spawn "scrotd 0")
        ]
        -- Appending search engine prompts to keybindings list.
        -- Look at "search engines" section of this config for values for "k".
        ++ [("M-s " ++ k, S.promptSearch dtXPConfig' f) | (k,f) <- searchList ]
        ++ [("M-S-s " ++ k, S.selectSearch f) | (k,f) <- searchList ]
        -- Appending some extra xprompts to keybindings list.
        -- Look at "xprompt settings" section this of config for values for "k".
        ++ [("M-p " ++ k, f dtXPConfig') | (k,f) <- promptList ]
        ++ [("M-p " ++ k, f dtXPConfig' g) | (k,f,g) <- promptList' ]
        -- The following lines are needed for named scratchpads.
          where nonNSP          = WSIs (return (\ws -> W.tag ws /= "nsp"))
                nonEmptyNonNSP  = WSIs (return (\ws -> isJust (W.stack ws) && W.tag ws /= "nsp"))

main :: IO ()
main = do
    -- Launching three instances of xmobar on their monitors.
    xmproc0 <- spawnPipe "xmobar -x 0 /home/chandra/.config/xmobar/xmobarrc0"
    xmproc1 <- spawnPipe "xmobar -x 1 /home/chandra/.config/xmobar/xmobarrc2"
    xmproc2 <- spawnPipe "xmobar -x 2 /home/chandra/.config/xmobar/xmobarrc1"
    -- the xmonad, ya know...what the WM is named after!
    xmonad $ ewmh def
        { manageHook = ( isFullscreen --> doFullFloat ) <+> myManageHook <+> manageDocks
        -- Run xmonad commands from command line with "xmonadctl command". Commands include:
        -- shrink, expand, next-layout, default-layout, restart-wm, xterm, kill, refresh, run,
        -- focus-up, focus-down, swap-up, swap-down, swap-master, sink, quit-wm. You can run
        -- "xmonadctl 0" to generate full list of commands written to ~/.xsession-errors.
        , handleEventHook    = serverModeEventHookCmd
                               <+> serverModeEventHook
                               <+> serverModeEventHookF "XMONAD_PRINT" (io . putStrLn)
                               <+> docksEventHook
        , modMask            = myModMask
        , terminal           = myTerminal
        , startupHook        = myStartupHook
        , layoutHook         = myLayoutHook
        , workspaces         = myWorkspaces
        , borderWidth        = myBorderWidth
        , normalBorderColor  = myNormColor
        , focusedBorderColor = myFocusColor
        , logHook = workspaceHistoryHook <+> myLogHook <+> dynamicLogWithPP xmobarPP
                        { ppOutput = \x -> hPutStrLn xmproc0 x  >> hPutStrLn xmproc1 x  >> hPutStrLn xmproc2 x
                        , ppCurrent = xmobarColor "#c5f467" "" . wrap "[" "]" -- Current workspace in xmobar
                        , ppVisible = xmobarColor "#c5f467" ""                -- Visible but not current workspace
                        , ppHidden = xmobarColor "#5cb2ff" "" . wrap "*" ""   -- Hidden workspaces in xmobar
                        , ppHiddenNoWindows = xmobarColor "#cf8dfb" ""        -- Hidden workspaces (no windows)
                        , ppTitle = xmobarColor "#b3afc2" "" . shorten 60     -- Title of active window in xmobar
                        , ppSep =  "<fc=#666666> <fn=2>|</fn> </fc>"                     -- Separators in xmobar
                        , ppUrgent = xmobarColor "#C45500" "" . wrap "!" "!"  -- Urgent workspace
                        , ppExtras  = [windowCount]                           -- # of windows current workspace
                        , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]
                        }
        } `additionalKeysP` myKeys
