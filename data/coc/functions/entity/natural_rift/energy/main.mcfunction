append function ./try_distribute:
        tag @s add coc.received
        if score $naturalRift coc.rift_energy matches 1.. function ./distribute:
            scoreboard players add @s coc.rift_energy 1
            scoreboard players remove $naturalRift coc.rift_energy 1

append function ./draw_wire:
    particle dragon_breath ^ ^0.35 ^0.5 0 0 0 0 1
    particle dragon_breath ^ ^0.35 ^0 0 0 0 0 1

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



if score @s coc.rift_energy_pool matches 1.. function ./move_from_pool:     
    scoreboard players remove @s coc.rift_energy_pool 4
    scoreboard players add @s coc.rift_energy 4

if score @s coc.rift_energy matches 1.. function ./init_transfer:
    scoreboard players operation $naturalRift coc.rift_energy = @s coc.rift_energy


    handleReciever('..32')
    handleTransferer('..32')
    
        # tag @s remove coc.transfered

    tag @e remove coc.transfered
    tag @e remove coc.received
    scoreboard players operation @s coc.rift_energy = $naturalRift coc.rift_energy

