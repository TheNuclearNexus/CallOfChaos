from coc:block/api import interact
interact('amalgam_forge')

data remove storage coc:temp Item
data modify storage coc:temp Item set from entity @s SelectedItem
if data storage coc:temp Item.Count data modify storage coc:temp Item.Count set value 1b

tag @s add coc.activator
anchored eyes function ./raycast:
    if block ^ ^ ^0.01 minecraft:furnace{Lock:"\\uf001coc.amalgam_forge"} positioned ^ ^ ^0.01 align xyz as @e[type=armor_stand,tag=coc.amalgam_forge,dx=0] positioned ~.5 ~ ~.5 function ./at_block:
        if entity @s[tag=coc.first,tag=coc.second] function ./interact/eject 
        if entity @s[tag=!coc.found] unless data storage coc:temp Item function ./interact/eject
        if entity @s[tag=!coc.found] function ./interact/insert

        tag @s remove coc.found
    if entity @s[distance=..5] unless block ^ ^ ^0.01 minecraft:furnace{Lock:"\\uf001coc.amalgam_forge"} positioned ^ ^ ^0.01 run function ./raycast

tag @s remove coc.activator
