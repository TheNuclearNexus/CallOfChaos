if score @s coc.rift_energy matches 20.. scoreboard players set @s coc.rift_energy 20


if score @s coc.rift_energy matches 1.. function ./set_on:
    if entity @s[tag=!coc.up,tag=!coc.down] data modify entity @s ArmorItems[3].tag.CustomModelData set value 4260002
    if entity @s[tag=coc.up] data modify entity @s ArmorItems[3].tag.CustomModelData set value 4260004
    if entity @s[tag=coc.down] data modify entity @s ArmorItems[3].tag.CustomModelData set value 4260006

unless score @s coc.rift_energy matches 1.. function ./set_off:
    if entity @s[tag=!coc.up,tag=!coc.down] data modify entity @s ArmorItems[3].tag.CustomModelData set value 4260001
    if entity @s[tag=coc.up] data modify entity @s ArmorItems[3].tag.CustomModelData set value 4260003
    if entity @s[tag=coc.down] data modify entity @s ArmorItems[3].tag.CustomModelData set value 4260005