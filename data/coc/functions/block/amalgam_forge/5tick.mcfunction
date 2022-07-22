append function ./activate/recipe/modify_item:
    if entity @s[x_rotation=0] data modify entity @e[type=item,sort=nearest,limit=1,dx=0,nbt={Age:0s}] Motion set value [0.0,0.1,0.1]
    if entity @s[x_rotation=180] data modify entity @e[type=item,sort=nearest,limit=1,dx=0,nbt={Age:0s}] Motion set value [0.0,0.1,-0.1]
    if entity @s[x_rotation=-90] data modify entity @e[type=item,sort=nearest,limit=1,dx=0,nbt={Age:0s}] Motion set value [0.1,0.1,0.0]
    if entity @s[x_rotation=90] data modify entity @e[type=item,sort=nearest,limit=1,dx=0,nbt={Age:0s}] Motion set value [-0.1,0.1,0.0]

    as @e[type=item,sort=nearest,limit=1,dx=0,nbt={Age:0s}] function ./activate/recipe/as_item:
        data merge entity @s {NoGravity:1b,Tags:["coc.amalgam_forge.item"]}
        store result score @s coc.dummy schedule function ./activate/recipe/item_toggle 1t append:
            store result score $time coc.dummy time query gametime
            as @e[type=item,tag=coc.amalgam_forge.item] if score @s coc.dummy = $time coc.dummy data merge entity @s {NoGravity:0b,Tags:[]}

def recipe(id):
    if data storage coc:temp {Recipe:id} function f'coc:block/amalgam_forge/activate/recipe/{id}':
        scoreboard players remove @s coc.rift_energy 20
        kill @e[tag=coc.amalgam_forge.display,sort=nearest,limit=1,distance=..0.5]
        positioned ^ ^ ^0.7 function f'coc:block/amalgam_forge/activate/recipe/{id}/item':
            loot spawn ~ ~ ~ loot f'coc:item/{id}'
            function ./activate/recipe/modify_item
        tag @s remove coc.first
        tag @s remove coc.second
        
        

if score @s coc.rift_energy matches 20.. function ./activate:
    scoreboard players set @s coc.rift_energy 20
    positioned ~ ~-1 ~ if entity @s[tag=coc.first,tag=coc.second] if entity @e[type=armor_stand,tag=coc.eternal_burner,distance=..0.5,scores={coc.rift_energy=1..}] positioned ~ ~1 ~ function ./activate/valid:
        data modify storage coc:temp Recipe set from entity @s ArmorItems[3].tag.coc.recipe

        recipe('blight_steel')
        recipe('nebulous_crystal')

if block ~-1 ~ ~ hopper[facing=east] data merge block ~-1 ~ ~ {TransferCooldown:10}
if block ~1 ~ ~ hopper[facing=west] data merge block ~1 ~ ~ {TransferCooldown:10}
if block ~ ~ ~-1 hopper[facing=south] data merge block ~ ~ ~-1 {TransferCooldown:10}
if block ~1 ~ ~ hopper[facing=north] data merge block ~ ~ ~1 {TransferCooldown:10}
if block ~ ~1 ~ hopper[facing=down] data merge block ~ ~1 ~ {TransferCooldown:10}

if entity @s[tag=!coc.first,tag=!coc.second] function ./interact/load_items_hopper:
    data remove storage coc:temp Left
    data remove storage coc:temp Right
    if entity @s[x_rotation=0] function ./interact/load_items_hopper/south:
        if block ~-1 ~ ~ hopper[facing=east,enabled=true] data modify storage coc:temp Left set from block ~-1 ~ ~ Items[0]
        if block ~1 ~ ~ hopper[facing=west,enabled=true] data modify storage coc:temp Right set from block ~1 ~ ~ Items[0]
    if entity @s[x_rotation=180] function ./interact/load_items_hopper/north:
        if block ~1 ~ ~ hopper[facing=west,enabled=true] data modify storage coc:temp Left set from block ~1 ~ ~ Items[0]
        if block ~-1 ~ ~ hopper[facing=east,enabled=true] data modify storage coc:temp Right set from block ~-1 ~ ~ Items[0]
    if entity @s[x_rotation=-90] function ./interact/load_items_hopper/east:
        if block ~ ~ ~1 hopper[facing=north,enabled=true] data modify storage coc:temp Left set from block ~ ~ ~1 Items[0]
        if block ~ ~ ~-1 hopper[facing=south,enabled=true] data modify storage coc:temp Right set from block ~ ~ ~-1 Items[0]
    if entity @s[x_rotation=90] function ./interact/load_items_hopper/west:
        if block ~ ~ ~-1 hopper[facing=south,enabled=true] data modify storage coc:temp Left set from block ~ ~ ~-1 Items[0]
        if block ~ ~ ~1 hopper[facing=north,enabled=true] data modify storage coc:temp Right set from block ~ ~ ~1 Items[0]
    
    if data storage coc:temp Left function ./interact/load_items_hopper/try_left:
        data modify storage coc:temp Left.Count set value 1b
        data modify storage coc:temp Item set from storage coc:temp Left
        function ./interact/insert/valid_item
        function ./interact/insert/get_symbol
        data modify storage coc:temp LeftSymbol set from storage coc:temp Symbol

        if score $valid coc.dummy matches 1.. function ./interact/load_items_hopper/try_right:
            # say left done
            data modify storage coc:temp Right.Count set value 1b
            data modify storage coc:temp Item set from storage coc:temp Right
            function ./interact/insert/valid_item
            function ./interact/insert/get_symbol
            data modify storage coc:temp RightSymbol set from storage coc:temp Symbol

            if score $valid coc.dummy matches 1.. function ./interact/load_items_hopper/try_recipe:
                # say right done
                data modify entity @s ArmorItems[3].tag.coc.first set from storage coc:temp Left
                data modify entity @s ArmorItems[3].tag.coc.second set from storage coc:temp Right
                function ./interact/insert/valid_recipe
                if score $valid coc.dummy matches 1.. positioned ~ ~0.08 ~ function ./interact/load_items_hopper/finish:
                    # say recipe done
                    tag @s add coc.first
                    tag @s add coc.second

                    summon minecraft:area_effect_cloud ~ ~ ~ {Tags:["coc.amalgam_forge.display"],Age:-2147483648,Duration:-1,WaitTime:-2147483648,CustomNameVisible:1b}
                    data modify block -30000000 0 1603 Text1 set value '["",{"nbt":"LeftSymbol","storage":"coc:temp","interpret": true},{"color":"#D337D3","text":" + "},{"nbt":"RightSymbol","storage":"coc:temp","interpret": true}]'
                    data modify entity @e[type=area_effect_cloud,tag=coc.amalgam_forge.display,sort=nearest,limit=1] CustomName set from block -30000000 0 1603 Text1

                        if entity @s[x_rotation=0] function ./interact/remove_item/south:
                            if block ~-1 ~ ~ hopper[facing=east,enabled=true] store result block ~-1 ~ ~ Items[0].Count byte 1 data get block ~-1 ~ ~ Items[0].Count 0.999999 
                            if block ~1 ~ ~ hopper[facing=west,enabled=true] store result block ~1 ~ ~ Items[0].Count byte 1 data get block ~1 ~ ~ Items[0].Count 0.999999 
                        if entity @s[x_rotation=180] function ./interact/remove_item/north:
                            if block ~1 ~ ~ hopper[facing=west,enabled=true] store result block ~1 ~ ~ Items[0].Count byte 1 data get block ~1 ~ ~ Items[0].Count 0.999999 
                            if block ~-1 ~ ~ hopper[facing=east,enabled=true] store result block ~-1 ~ ~ Items[0].Count byte 1 data get block ~-1 ~ ~ Items[0].Count 0.999999 
                        if entity @s[x_rotation=-90] function ./interact/remove_item/east:
                            if block ~ ~ ~1 hopper[facing=north,enabled=true] store result block ~ ~ ~1 Items[0].Count byte 1 data get block ~ ~ ~1 Items[0].Count 0.999999 
                            if block ~ ~ ~-1 hopper[facing=south,enabled=true] store result block ~ ~ ~-1 Items[0].Count byte 1 data get block ~ ~ ~-1 Items[0].Count 0.999999 
                        if entity @s[x_rotation=90] function ./interact/remove_item/west:
                            if block ~ ~ ~-1 hopper[facing=south,enabled=true] store result block ~ ~ ~-1 Items[0].Count byte 1 data get block ~ ~ ~-1 Items[0].Count 0.999999 
                            if block ~ ~ ~1 hopper[facing=north,enabled=true] store result block ~ ~ ~1 Items[0].Count byte 1 data get block ~ ~ ~1 Items[0].Count 0.999999 