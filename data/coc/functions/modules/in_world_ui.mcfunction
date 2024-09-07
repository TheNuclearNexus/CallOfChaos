from bolt_expressions import Scoreboard, Data
from nbtlib import Float

dummy = Scoreboard("coc.dummy")
atSelf = Data.entity("@s")
temp = Data.storage("coc:temp")


CURSOR_X = dummy["$x"]
CURSOR_Y = dummy["$y"]
CURSOR_D = Scoreboard("coc.cursor.d")["@s"]
CURSOR_R = Scoreboard("coc.cursor.r")["@s"]

SCREEN_W = Scoreboard("coc.screen.w")["@s"]
SCREEN_H = Scoreboard("coc.screen.h")["@s"]

SCREEN_PPU = Scoreboard("coc.screen.ppu")["@s"]

append function ./in_world_ui/start_tracking:
    CURSOR_R = atSelf.Rotation[0] * 1000
    CURSOR_D = 200

    SCREEN_W = 192
    SCREEN_H = 192
    SCREEN_PPU = 64

    tag @s add coc.has_tracked_ui

append function ./in_world_ui/set_scores:

    # Calculate the screen bounds, ex. width = 64, lower = -34, upper = 33, offset = 32
    # Add 2 pixels of padding so moving the cursor of screen doesn't leave buttons hovered
    dummy["$positiveXBound"] = dummy["$w"] / 2 + 1
    dummy["$negativeXBound"] = (dummy["$w"] / 2 + 2) * -1 
    dummy["$xOffset"] = dummy["$w"] / 2

    # Same as above but for the y component
    dummy["$positiveYBound"] = dummy["$h"] / 2 + 1
    dummy["$negativeYBound"] = (dummy["$h"] / 2 + 2) * -1 
    dummy["$yOffset"] = dummy["$h"] / 2

    # Round to the nearest coordinate
    dummy["$x"] = atSelf.Pos[0] * -10000 * dummy["$ppu"] / 10000
    dummy["$y"] = atSelf.Pos[1] * 10000 * dummy["$ppu"]  / 10000

    def clamp(low, value, high):
        return max(low, min(value, high))

    dummy["$x"] = clamp(dummy["$negativeXBound"], dummy["$x"], dummy["$positiveXBound"]) + dummy["$xOffset"]
    dummy["$y"] = clamp(dummy["$negativeYBound"], dummy["$y"], dummy["$positiveYBound"]) + dummy["$yOffset"]


append function coc:entity/player/tick:
    if entity @s[tag=coc.has_tracked_ui] function ./in_world_ui/process:
        tag @s add coc.root_player
        temp.rotation = atSelf.Rotation
        rotation = temp.rotation
        rotation[0] = (rotation[0] * 1000 - CURSOR_R) / 1000

        dummy["$d"] = CURSOR_D * (SCREEN_PPU / 16)
        dummy["$w"] = SCREEN_W
        dummy["$h"] = SCREEN_H
        dummy["$ppu"] = SCREEN_PPU

        positioned 0.0 0.0 0.0 summon marker function ./in_world_ui/do_plane_math:
            atSelf.Rotation = temp.rotation
            at @s function ./in_world_ui/iterate_ray:
                tp @s ^ ^ ^0.1 ~ ~
                particle happy_villager ~ ~ ~ 0 0 0 0 1
                dummy["$z"] = atSelf.Pos[2] * 100 * (dummy["$ppu"] / 16)

                if score $z coc.dummy < $d coc.dummy positioned 0.0 0.0 0.0 if entity @s[distance=..8] at @s function ./in_world_ui/iterate_ray
                if score $z coc.dummy >= $d coc.dummy function ./in_world_ui/set_scores
            kill @s

        tag @s remove coc.root_player

        dummy["$r"] = CURSOR_R
        dummy["$id"] = Scoreboard("coc.player_id")["@s"]
        anchored eyes positioned ^ ^ ^ as @e[type=text_display,tag=coc.world_ui,distance=..3] if score @s coc.dummy = $id coc.dummy function ./in_world_ui/track_player
append function coc:entity/player/second:
    if entity @s[tag=coc.has_tracked_ui] function ./in_world_ui/long_tp:
        dummy["$id"] = Scoreboard("coc.player_id")["@s"]    
        anchored eyes positioned ^ ^ ^ as @e[type=text_display,tag=coc.world_ui] if score @s coc.dummy = $id coc.dummy function ./in_world_ui/track_player
            