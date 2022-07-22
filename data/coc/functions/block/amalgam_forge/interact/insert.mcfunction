spawnPos = '~ ~.58 ~'

append function ./insert/valid_item:
    scoreboard players set $valid coc.dummy 0
    if data storage coc:temp Item{id:"minecraft:obsidian"} scoreboard players set $valid coc.dummy 1
    if data storage coc:temp Item{id:"minecraft:iron_ingot"} scoreboard players set $valid coc.dummy 1

    if data storage coc:temp Item.tag.smithed{id:"coc:chaos_crystal"} scoreboard players set $valid coc.dummy 1
    if data storage coc:temp Item.tag.smithed{id:"coc:nebulous_powder"} scoreboard players set $valid coc.dummy 1

append function ./insert/get_symbol:
    if data storage coc:temp Item{id:"minecraft:obsidian"} data modify storage coc:temp Symbol set value '{"text":"\\uc002","font":"coc:amalgam_forge"}'
    if data storage coc:temp Item{id:"minecraft:iron_ingot"} data modify storage coc:temp Symbol set value '{"text":"\\uc003","font":"coc:amalgam_forge"}'

    if data storage coc:temp Item.tag.smithed{id:"coc:chaos_crystal"} data modify storage coc:temp Symbol set value '{"text":"\\uc005","font":"coc:amalgam_forge"}'
    if data storage coc:temp Item.tag.smithed{id:"coc:nebulous_powder"} data modify storage coc:temp Symbol set value '{"text":"\\uc006","font":"coc:amalgam_forge"}'

append function ./insert/valid_recipe:
    data modify storage coc:temp Recipe set from entity @s ArmorItems[3].tag.coc

    scoreboard players set $valid coc.dummy 0
    if data storage coc:temp Recipe{first:{id:"minecraft:obsidian"},second:{id:"minecraft:iron_ingot"}} function ./insert/recipe/blight_steel:
        data modify entity @s ArmorItems[3].tag.coc.recipe set value 'blight_steel'
        scoreboard players set $valid coc.dummy 1
    if data storage coc:temp Recipe{first:{id:"minecraft:iron_ingot"},second:{id:"minecraft:obsidian"}} function ./insert/recipe/blight_steel

    if data storage coc:temp Recipe{first:{tag:{smithed:{id: "coc:chaos_crystal"}}},second:{tag:{smithed:{id: "coc:nebulous_powder"}}}} function ./insert/recipe/nebulous_crystal:
        data modify entity @s ArmorItems[3].tag.coc.recipe set value 'nebulous_crystal'
        scoreboard players set $valid coc.dummy 1
    if data storage coc:temp Recipe{first:{tag:{smithed:{id: "coc:nebulous_powder"}}},second:{tag:{smithed:{id: "coc:chaos_crystal"}}}} function ./insert/recipe/nebulous_crystal


function ./insert/valid_item
if entity @s[tag=coc.first,tag=!coc.second] if score $valid coc.dummy matches 1.. function ./insert/second:
    data modify entity @s ArmorItems[3].tag.coc.second set from storage coc:temp Item
    item modify entity @p[tag=coc.activator] weapon.mainhand coc:reduce_count
    tag @s add coc.second

    function ./insert/valid_recipe

    if score $valid coc.dummy matches 1 positioned spawnPos as @e[tag=coc.amalgam_forge.display,sort=nearest,limit=1] function ./insert/get_name:
        data modify storage coc:temp FirstSymbol set from entity @s CustomName
        function ./insert/get_symbol
        data modify block -30000000 0 1603 Text1 set value '["",{"nbt":"FirstSymbol","storage":"coc:temp","interpret": true},{"color":"#D337D3","text":" + "},{"nbt":"Symbol","storage":"coc:temp","interpret": true}]'
        data modify entity @s CustomName set from block -30000000 0 1603 Text1
    if score $valid coc.dummy matches 0 function ./eject
    
if entity @s[tag=!coc.first] if score $valid coc.dummy matches 1.. function ./insert/first:
    data modify entity @s ArmorItems[3].tag.coc.first set from storage coc:temp Item
    item modify entity @p[tag=coc.activator] weapon.mainhand coc:reduce_count
    tag @s add coc.first

    

    summon minecraft:area_effect_cloud spawnPos {Tags:["coc.amalgam_forge.display"],Age:-2147483648,Duration:-1,WaitTime:-2147483648,CustomNameVisible:1b}

    function ./insert/get_symbol
    positioned spawnPos data modify entity @e[tag=coc.amalgam_forge.display,sort=nearest,limit=1] CustomName set from storage coc:temp Symbol
