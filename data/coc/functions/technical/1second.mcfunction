as @e[type=armor_stand,tag=coc.ticking] at @s function ../entity/1second_armor_stand:
    if entity @s[tag=coc.natural_rift] function ../entity/natural_rift/1second

    # blocks
    if entity @s[tag=coc.chaotic_converter] function ../block/chaotic_converter/1second
    if entity @s[tag=coc.eternal_burner] function ../block/eternal_burner/1second

schedule function coc:technical/1second 1s replace