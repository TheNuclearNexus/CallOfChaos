tag @s add coc.activate
as @e[type=minecraft:armor_stand,tag=coc.offering_altar,dx=0] if entity @s[tag=coc.has_item]:
    unless score @p[tag=coc.activator] coc.pact_id matches 0.. if entity @e[type=minecraft:armor_stand,tag=coc.natural_rift,tag=!coc.pact_formed,distance=..8] function ./activate/start_form

    if score @p[tag=coc.activator] coc.pact_id matches 0..:
        as @e[type=minecraft:armor_stand,tag=coc.natural_rift,tag=coc.pact_formed,distance=..8,limit=1] if score @s coc.pact_id = @p[tag=coc.activator] coc.pact_id at @s function ./generate_ritual:
            data modify storage coc:temp Items set value []

            positioned ~ ~1 ~:
                as @e[type=minecraft:item,tag=coc.offering_item,distance=..8]:
                    data modify storage coc:temp Items append from entity @s Item
            
            scoreboard players set $xp coc.dummy 1
            scoreboard players set $suc coc.dummy 0

            if entity @s[tag=!coc.has_contract] if data storage coc:temp Items[{id:"minecraft:writable_book"}] function ./rituals/contract:
                scoreboard players set $suc coc.dummy 1
                function ../../entity/natural_rift/contract/generate


            if score $suc coc.dummy matches 1.. function ./activate/successful_ritual:
                scoreboard players operation @s coc.relation.pts += $xp coc.dummy
                function ../../entity/natural_rift/relation/check_level_up

                
                positioned ~ ~1 ~ kill @e[type=minecraft:item,tag=coc.offering_item,distance=..8]
                tag @e[type=minecraft:armor_stand,tag=coc.offering_altar,distance=..8] remove coc.has_item
tag @s remove coc.activate