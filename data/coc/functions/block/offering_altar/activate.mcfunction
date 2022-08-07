tag @s add coc.activate
as @e[type=minecraft:armor_stand,tag=coc.offering_altar,dx=0] if entity @s[tag=coc.has_item,tag=!coc.disabled]:
    unless score @p[tag=coc.activator] coc.pact_id matches 0.. if entity @e[type=minecraft:armor_stand,tag=coc.natural_rift,tag=!coc.pact_formed,distance=..8] function ./activate/start_form

    if score @p[tag=coc.activator] coc.pact_id matches 0..:
        as @e[type=minecraft:armor_stand,tag=coc.natural_rift,tag=coc.pact_formed,distance=..8,limit=1] if score @s coc.pact_id = @p[tag=coc.activator] coc.pact_id at @s function ./generate_ritual:
            data modify storage coc:temp Items set value []

            positioned ~ ~1 ~:
                as @e[type=minecraft:item,tag=coc.offering_item,distance=..8]:
                    data modify storage coc:temp Items append from entity @s Item
            
            scoreboard players set $xp coc.dummy 0
            scoreboard players set $suc coc.dummy 0

            function ../../recipes/rituals

            if score $suc coc.dummy matches 1.. function ./activate/successful_ritual:
                scoreboard players operation @s coc.relation.pts += $xp coc.dummy
                function ../../entity/natural_rift/relation/check_level_up

                playsound minecraft:entity.wither.spawn master @a ~ ~ ~ 0.2 2
                playsound minecraft:block.beacon.power_select master @a ~ ~ ~ 1 1.3
                particle minecraft:dust 0.82745 0.21568 0.82745 0.5 ~ ~15 ~ 0 5 0 0 1000
                # particle minecraft:dust 0.82745 0.21568 0.82745 0.5 ~ ~1 ~ 0.4 0 0.4 0 1000

                positioned ~ ~1 ~ kill @e[type=minecraft:item,tag=coc.offering_item,distance=..8]
                tag @e[type=minecraft:armor_stand,tag=coc.offering_altar,distance=..8] remove coc.has_item
            if score $suc coc.dummy matches 0 function ./activate/failed_ritual:
                playsound minecraft:entity.wither.shoot master @a ~ ~ ~ 0.1 0.1
                playsound minecraft:entity.generic.extinguish_fire master @a ~ ~ ~ 1 2
tag @s remove coc.activate