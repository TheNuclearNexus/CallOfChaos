as @e[type=armor_stand,tag=coc.ticking] at @s function ../entity/5tick_armor_stand:
    if entity @s[tag=coc.natural_rift] function ../entity/natural_rift/5tick
    function ../block/5tick
schedule function coc:technical/5tick 5t replace