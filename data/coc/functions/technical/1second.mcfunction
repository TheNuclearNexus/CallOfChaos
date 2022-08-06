as @e[type=armor_stand,tag=coc.ticking] at @s function ../entity/1second_armor_stand:
    if entity @s[tag=coc.natural_rift] function ../entity/natural_rift/1second

    # blocks
    function ../block/1second

unless entity @a[tag=coc.debugging] as @e[type=marker,tag=coc.spawn_rift] at @s function coc:entity/natural_rift/summon
if entity @a[tag=coc.debugging] as @e[type=marker,tag=coc.spawn_rift] at @s particle happy_villager ~ ~0.5 ~ 0 0 0 0 1 
schedule function coc:technical/1second 1s replace