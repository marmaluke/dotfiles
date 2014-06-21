import XMonad
import XMonad.Hooks.SetWMName
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import Graphics.X11.ExtraTypes.XF86
import System.IO

main = do
    xmproc <- spawnPipe "xmobar"
    xmonad $ defaultConfig
        { manageHook  = manageDocks <+> manageHook defaultConfig
        , layoutHook  = avoidStruts  $  layoutHook defaultConfig
        , startupHook = do
            setWMName "LG3D"
            spawn "~/.xmonad/autostart"
        , logHook     = dynamicLogWithPP xmobarPP
                            { ppOutput = hPutStrLn xmproc
                            , ppTitle  = xmobarColor "green" "" . shorten 50
                            }
        , modMask     = mod4Mask
        , terminal    = "konsole"
        } `additionalKeys`
            [ ((0, xF86XK_AudioLowerVolume), spawn "pactl set-sink-volume 0 -- -2%")
            , ((0, xF86XK_AudioRaiseVolume), spawn "pactl set-sink-volume 0 +2%")
            , ((0, xF86XK_AudioMute), spawn "pactl set-sink-mute 0 toggle")
            ]