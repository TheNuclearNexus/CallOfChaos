from bolt_expressions import Scoreboard
from ./rates import CONVERSION_BURST_TIME

dummy = Scoreboard("coc.dummy")

def get_transform(offset):
    return {
        transformation: {
            translation:[2f,offset,0f],
            left_rotation:[0f,0f,0f,1f],
            scale:[0.5f,0.5f,0.5f],
            right_rotation:[0f,0f,0f,1f]
        },
        interpolation_duration: 20,
        start_interpolation: 0
    }

append function ./tick/apply_transformations:   
    # dummy["$offset"] = (dummy["$offset"] + 2) % 10
    # dummy["$offset2"] = dummy["$offset"] + 20
    if score $animTime coc.dummy matches 10 data merge entity @s get_transform(0.9f)
    if score $animTime coc.dummy matches 25 data merge entity @s get_transform(1.1f)

    particle dust 1 0 1 0.3 ^2.02 ^1 ^ 0 0 0 0 5

function ./tick/main_rift:
    scoreboard players set $capacity coc.dummy 8
    scoreboard players set $productionRate coc.dummy 2
    particle minecraft:portal ~ ~ ~ 2 2 2 0 3

    dummy["$animTime"] = dummy["$gameTime"] % 40
    dummy["$pulseTime"] = dummy["$gameTime"] % CONVERSION_BURST_TIME
    dummy["$offset"] = 0

    dummy["$bob"] = 0
    if entity @s[tag=!coc.animating_ritual]:
        dummy["$bob"] = 1

    store success score $playerNear coc.dummy if entity @a[distance=..24,limit=1,sort=arbitrary]
    if score $bob coc.dummy matches 1 on passengers if entity @s[tag=coc.conversion_item] at @s function ./tick/conversion_items:
        function ./conversion

        if score $playerNear coc.dummy matches 1 function ./tick/animate_ritual_items:
            at @s tp @s ~ ~ ~ ~1 ~
            on passengers at @s tp @s ~ ~ ~ ~1 ~
            function ./tick/apply_transformations
            if score $pulseTime coc.dummy matches 0 function ./tick/draw_bolt:
                particle dust 1 0 1 1 ~ ~1 ~ 0 0 0 0 1
                positioned ^0.1 ^ ^ if entity @s[distance=..2] function ./tick/draw_bolt
            

        
# For all our rift stacks in the utility chunk
positioned -30000000 320 3200 as @e[type=text_display,tag=coc.rift_stack,distance=..0.5] function ./tick/_internal:
    # Run this function on the entities their pointers reference
    on passengers on origin function ./tick/_children:
        # Process the main rift itself
        if entity @s[tag=coc.rift] at @s function ./tick/main_rift
        