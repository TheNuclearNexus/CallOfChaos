if score @s coc.rift_energy matches 20.. function ./activate:
    scoreboard players remove @s coc.rift_energy 20

    if entity @s[tag=!coc.up,tag=!coc.down] positioned ^ ^0.5 ^0.5001 function ./raycast:
        particle dragon_breath ^ ^ ^0.00 0 0 0 0 1
        particle dragon_breath ^ ^ ^0.25 0 0 0 0 1
        particle dragon_breath ^ ^ ^0.50 0 0 0 0 1
        particle dragon_breath ^ ^ ^0.75 0 0 0 0 1

        if block ~ ~ ~ stone function ./convert/stone:
            store result score $val coc.dummy loot spawn ~ ~ ~ loot coc:technical/random/1_100

            if score $val coc.dummy matches 0..40 setblock ~ ~ ~ cobblestone
            if score $val coc.dummy matches 41..60 setblock ~ ~ ~ coal_ore
            if score $val coc.dummy matches 61..75 setblock ~ ~ ~ iron_ore
            if score $val coc.dummy matches 76..85 setblock ~ ~ ~ gold_ore
            if score $val coc.dummy matches 86..93 setblock ~ ~ ~ lapis_ore
            if score $val coc.dummy matches 94.. setblock ~ ~ ~ diamond_ore

            tag @s add coc.done

        if entity @s[tag=coc.done] function ./convert/sfx:
            particle explosion ~ ~ ~ 0 0 0 0 10 
        if block ~ ~ ~ #coc:air positioned ^ ^ ^1 function ./raycast

    tag @s remove coc.done