append function ./try_distribute:
        tag @s add coc.received
        if score $naturalRift coc.rift_energy matches 1.. function ./distribute:
            scoreboard players add @s coc.rift_energy 1
            scoreboard players remove $naturalRift coc.rift_energy 1

append function ./draw_wire:
    particle minecraft:dust 0.82745 0.21568 0.82745 0.5 ^ ^0.35 ^0.75 0 0 0 0 5 normal @a[tag=coc.goggles]
    particle minecraft:dust 0.82745 0.21568 0.82745 0.5 ^ ^0.35 ^0.50 0 0 0 0 5 normal @a[tag=coc.goggles]
    particle minecraft:dust 0.82745 0.21568 0.82745 0.5 ^ ^0.35 ^0.25 0 0 0 0 5 normal @a[tag=coc.goggles]
    particle minecraft:dust 0.82745 0.21568 0.82745 0.5 ^ ^0.35 ^0.00 0 0 0 0 5 normal @a[tag=coc.goggles]

    positioned ^ ^ ^1 unless entity @s[distance=..0.5] function ./draw_wire 


def handleReciever(distance):
    if score $naturalRift coc.rift_energy matches 1.. as @e[type=armor_stand,tag=coc.energy.receiver,distance=distance,sort=random,limit=4,tag=!coc.received] facing entity @s feet function ./draw_wire
    as @e[type=armor_stand,tag=coc.energy.receiver,distance=distance,sort=random,tag=!coc.received] function ./try_distribute


def handleTransferer(distance):
    as @e[type=armor_stand,tag=coc.energy.transferer,distance=distance,sort=random,limit=4,tag=!coc.transfered] facing entity @s feet function ./draw_wire
    as @e[type=armor_stand,tag=coc.energy.transferer,tag=!coc.transfered,distance=distance,sort=random] at @s:
        function ./transfer


append function ./transfer:
    tag @s add coc.transfered
    

    handleReciever('..16')
    handleTransferer('..16')

append function ./get_energy_stats:
    scoreboard players set $naturalRift coc.rift_energy 1
    as @e[type=armor_stand,tag=coc.focusing_crystal,distance=..8,limit=4,sort=nearest] function ./get_focusing:
        scoreboard players add $naturalRift coc.rift_energy 1
        positioned ~ ~2 ~ facing entity @s feet function ./draw_wire

    scoreboard players operation $max coc.rift_energy = @s coc.relation.lvl
    if score @s coc.rift.flow matches 1.. function ./add_flow:
        scoreboard players add $max coc.rift_energy 2
    if score $naturalRift coc.rift_energy > $max coc.rift_energy scoreboard players operation $naturalRift coc.rift_energy = $max coc.rift_energy

execute function ./init_transfer:
    as @a if data entity @s Inventory[{Slot:103b,tag:{smithed:{id:"coc:blightsight_goggles"}}}] tag @s add coc.goggles

    function ./get_energy_stats
    if score @s coc.rift.flow matches 1..:
        scoreboard players remove @s coc.rift.flow 1


    positioned ~ ~2 ~ function ./init_transfer/handle:
        handleReciever('..12')
        handleTransferer('..12')
    
        # tag @s remove coc.transfered
    tag @a remove coc.goggles

    tag @e remove coc.transfered
    tag @e remove coc.received

