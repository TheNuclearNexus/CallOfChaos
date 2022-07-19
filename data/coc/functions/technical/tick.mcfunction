as @a at @s function ../entity/player/tick
as @e[type=armor_stand,tag=coc.ticking] at @s function ../entity/armor_stand:
    if entity @s[tag=coc.natural_rift] function ../entity/natural_rift/tick

    # blocks
    if entity @s[tag=coc.focusing_crystal] function ../block/focusing_crystal/tick
    if entity @s[tag=coc.offering_altar] function ../block/offering_altar/tick
    if entity @s[tag=coc.chaotic_converter] function ../block/chaotic_converter/tick



schedule function coc:technical/tick 1t replace

