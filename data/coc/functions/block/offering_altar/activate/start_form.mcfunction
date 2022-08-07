positioned ~ ~1 ~ data modify storage coc:temp Item set from entity @e[type=item,tag=coc.offering_item,dx=0,limit=1] Item 

if data storage coc:temp Item.tag.smithed{id:"coc:blood_vial"} if data storage coc:temp Item.tag.coc.player:
    unless entity @e[type=minecraft:armor_stand,tag=coc.natural_rift,tag=coc.pact_formed,distance=..8] function ./item_valid:
        store result score $owner coc.player_id data get storage coc:temp Item.tag.coc.player
        
        if score @a[tag=coc.activate,sort=nearest,limit=1] coc.player_id = $owner coc.player_id function ./pass:
            tellraw @a[tag=coc.activate,sort=nearest,limit=1] [{"translate":"text.coc.natural_rift.activate.pass","color":"dark_gray","italic": true}]

            scoreboard players add $global coc.pact_id 1
            scoreboard players operation @a[tag=coc.activate,sort=nearest,limit=1] coc.pact_id = $global coc.pact_id 

            #region as rift
            as @e[type=minecraft:armor_stand,tag=coc.natural_rift,tag=!coc.pact_formed,distance=..8] at @s function ./as_rift
            #endregion
            
            #region item animation
            tag @s remove coc.has_item
            positioned ~ ~1 ~ kill @e[type=item,tag=coc.offering_item,dx=0,limit=1]

            summon armor_stand ~.5 ~-0.5 ~.5 {
                Tags:["coc.offering_item.animating"],
                Invisible:1b,Marker:1b,NoGravity:1b,
                ArmorItems:[
                    {},{},{},
                    {id:"minecraft:potion",Count:1b,tag:{CustomModelData:4260001,CustomPotionColor:16777215}}
                ]
            }

            positioned ~ ~-0.5 ~ as @e[type=armor_stand,tag=coc.offering_item.animating,sort=nearest,limit=1]:
                tag @s add coc.offering_item.animating
                tag @s remove coc.offering_item
                data merge entity @s {NoGravity:1b}

                schedule function ./animate_item 1t replace:
                    as @e[type=armor_stand,tag=coc.offering_item.animating] at @s:
                        scoreboard players add @s coc.dummy 1

                        particle dragon_breath ~ ~1.6 ~ 0 0 0 0 1  
                        if score @s coc.dummy matches ..20 tp @s ~ ~ ~ ~5 0
                        if score @s coc.dummy matches 21..35 tp @s ~ ~0.1 ~ ~5 0
                        if score @s coc.dummy matches 36..45 tp @s ~ ~0.05 ~ ~5 0
                        if score @s coc.dummy matches 46..80 positioned ~ ~-2 ~ facing entity @e[type=minecraft:armor_stand,tag=coc.natural_rift,sort=nearest,limit=1] feet positioned ~ ~2 ~ positioned ^ ^ ^0.1 rotated as @s tp @s ~ ~ ~ ~5 0
                        if score @s coc.dummy matches 80.. kill @s
                        if entity @e[type=minecraft:armor_stand,tag=coc.natural_rift,dx=0] kill @s
                    if entity @e[type=armor_stand,tag=coc.offering_item.animating] schedule function ./animate_item 1t replace
            #endregion
        unless score @a[tag=coc.activate,sort=nearest,limit=1] coc.player_id = $owner coc.player_id function ./fail:
            tellraw @a[tag=coc.activate,sort=nearest,limit=1] [{"translate":"text.coc.natural_rift.activate.fail","color":"dark_gray","italic": true}]
                    
