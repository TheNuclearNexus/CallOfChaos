tag @s add coc.found


if entity @s[tag=coc.first] positioned ^0.2 ^ ^ function ./eject/first:
    summon item ~ ~1 ~ {Tags:["coc.temp"],Item:{id:"minecraft:stone",Count:1b}}
    data modify entity @e[type=item,distance=..1,tag=coc.temp,sort=nearest,limit=1] Item set from entity @s ArmorItems[3].tag.coc.first
    tag @e remove coc.temp

if entity @s[tag=coc.second] positioned ^-0.2 ^ ^ function ./eject/second:
    summon item ~ ~1 ~ {Tags:["coc.temp"],Item:{id:"minecraft:stone",Count:1b}}
    data modify entity @e[type=item,distance=..1,tag=coc.temp,sort=nearest,limit=1] Item set from entity @s ArmorItems[3].tag.coc.second
    tag @e remove coc.temp

positioned ~ ~.58 ~ kill @e[tag=coc.amalgam_forge.display,sort=nearest,limit=1]

tag @s remove coc.smelting
tag @s remove coc.first
tag @s remove coc.second