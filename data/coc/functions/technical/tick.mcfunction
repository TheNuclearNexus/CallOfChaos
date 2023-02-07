as @a at @s function ../entity/player/tick
as @e[type=armor_stand,tag=coc.ticking] at @s function ../entity/armor_stand:
    if entity @s[tag=coc.natural_rift] function ../entity/natural_rift/tick
    if entity @s[tag=coc.crystalizer.block] function ../block/crystalizer/block/tick
    if entity @s[tag=coc.crystalizer.crystal] function ../block/crystalizer/crystal/tick
    # blocks
    function ../block/tick


schedule function coc:technical/tick 1t replace

