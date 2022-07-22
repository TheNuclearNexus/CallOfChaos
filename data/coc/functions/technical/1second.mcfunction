as @e[type=armor_stand,tag=coc.ticking] at @s function ../entity/1second_armor_stand:
    if entity @s[tag=coc.natural_rift] function ../entity/natural_rift/1second

    # blocks
    function ../block/1second

schedule function coc:technical/1second 1s replace