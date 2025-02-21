from ./creatures import ACTIVE_TAG, STAGE_DURATION, CREATURE_DATA

ANIMATION_TIME = 60
ANIMATION_INTERVAL = set_const(ANIMATION_TIME // 5 * 2)
ANIMATION_CYCLE = ANIMATION_TIME // 5

SCALE_RANGE = (60, 110)

unless entity @s[tag=ACTIVE_TAG] return 0

def transform(translation= [0,0,0], scale= [1,1,1], left_rotation=[0,0,0,1], right_rotation=[0,0,0,1]):
    return {
        "translation":      list(map(Float, translation)),
        "scale":            list(map(Float, scale)),
        "left_rotation":    list(map(Float, left_rotation)),
        "right_rotation":   list(map(Float, right_rotation))
    }

if entity @a[distance=..32,limit=1] on passengers if entity @s[tag=coc.creature] at @s function ./animate:
    rotate @s ~5 ~

    store result score #progress coc.dummy time query gametime

    scoreboard players operation #progress coc.dummy %= ANIMATION_INTERVAL coc.const

    if score #progress coc.dummy matches 0 return run function ~/up:
        data modify storage coc:temp animation set value {
            transformation: transform(
                translation=[0,1.1,0]
            ),
            interpolation_duration: ANIMATION_TIME,
            start_interpolation: 0
        }

        store result storage coc:temp animation.transformation.scale[0] float .01 random value SCALE_RANGE
        store result storage coc:temp animation.transformation.scale[1] float .01 random value SCALE_RANGE
        store result storage coc:temp animation.transformation.scale[2] float .01 random value SCALE_RANGE

        store result storage coc:temp animation.transformation.translation[1] float .01 random value 101..110

        data modify entity @s[type=item_display] {} merge from storage coc:temp animation

    if score #progress coc.dummy matches ANIMATION_CYCLE return run function ~/down:
        data modify storage coc:temp animation set value {
            transformation: transform(
                translation=[0,0.9,0]
            ),
            interpolation_duration: ANIMATION_TIME,
            start_interpolation: 0
        }

        store result storage coc:temp animation.transformation.scale[0] float .01 random value SCALE_RANGE
        store result storage coc:temp animation.transformation.scale[1] float .01 random value SCALE_RANGE
        store result storage coc:temp animation.transformation.scale[2] float .01 random value SCALE_RANGE

        store result storage coc:temp animation.transformation.translation[1] float .01 random value 80..99

        data modify entity @s[type=item_display] {} merge from storage coc:temp animation


unless score @s coc.powered matches 1 return 0

scoreboard players add @s coc.dummy 1

if score @s coc.dummy matches f"{STAGE_DURATION}.." function ~/progress_stage:
    data modify storage coc:temp creature set from entity @s f"item.{CREATURE_DATA}"

    store result score #stage coc.dummy data get storage coc:temp creature.stage

    if score #stage coc.dummy matches 0:
        on passengers if entity @s[tag=coc.creature] data remove entity @s item_display

    store result storage coc:temp stage int 1 scoreboard players add #stage coc.dummy 1

    execute function ~/increment_stage with storage coc:temp {}:
        say increment
        unless data storage coc:temp creature.stages.$(stage) return:
            execute function ~/../breach with storage coc:temp creature:    
                function ./explode
                $function $(corrupted)

        on passengers if entity @s[tag=coc.creature]:
            data modify entity @s item.components."minecraft:item_model" set from storage coc:temp creature.stages.$(stage)
        
        data modify entity @s f"item.{CREATURE_DATA}.stage" set value $(stage)
    
    scoreboard players set @s coc.dummy 0