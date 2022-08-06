
if entity @s[tag=coc.up]  rotated 0 -90 positioned ^ ^ ^0.5001 function ./shoot_beam
if entity @s[tag=coc.down] rotated 0 90 positioned ^ ^ ^0.5001 function ./shoot_beam
if entity @s[tag=!coc.up,tag=!coc.down] positioned ^ ^ ^0.5001 function ./shoot_beam:
    particle minecraft:dust 0.82745 0.21568 0.82745 0.5 ^ ^ ^0.00 0 0 0 0 1
    particle minecraft:dust 0.82745 0.21568 0.82745 0.5 ^ ^ ^0.25 0 0 0 0 1
    particle minecraft:dust 0.82745 0.21568 0.82745 0.5 ^ ^ ^0.50 0 0 0 0 1
    particle minecraft:dust 0.82745 0.21568 0.82745 0.5 ^ ^ ^0.75 0 0 0 0 1

    effect give @a[name=_entro,distance=..1] speed 5 4 true

    if block ~ ~ ~ tuff function ./convert/tuff:
        tag @s add coc.done
        if score @s coc.rift_energy matches ..2 scoreboard players set $count coc.dummy 0
        if score @s coc.rift_energy matches 3   scoreboard players set $count coc.dummy 3
        if score @s coc.rift_energy matches 4   scoreboard players set $count coc.dummy 6
        if score @s coc.rift_energy matches 5   scoreboard players set $count coc.dummy 9
        if score @s coc.rift_energy matches 6   scoreboard players set $count coc.dummy 14
        if score @s coc.rift_energy matches 7   scoreboard players set $count coc.dummy 6
        if score @s coc.rift_energy matches 8   scoreboard players set $count coc.dummy 5
        if score @s coc.rift_energy matches 9.. scoreboard players set $count coc.dummy 0

        setblock ~ ~ ~ air
        loot spawn ~ ~ ~ loot coc:set_item/raw_iron_chunk

    if block ~ ~ ~ granite function ./convert/granite:
        tag @s add coc.done
        if score @s coc.rift_energy matches ..2 scoreboard players set $count coc.dummy 0
        if score @s coc.rift_energy matches 3   scoreboard players set $count coc.dummy 3
        if score @s coc.rift_energy matches 4   scoreboard players set $count coc.dummy 6
        if score @s coc.rift_energy matches 5   scoreboard players set $count coc.dummy 9
        if score @s coc.rift_energy matches 6   scoreboard players set $count coc.dummy 14
        if score @s coc.rift_energy matches 7   scoreboard players set $count coc.dummy 6
        if score @s coc.rift_energy matches 8   scoreboard players set $count coc.dummy 5
        if score @s coc.rift_energy matches 9.. scoreboard players set $count coc.dummy 0

        setblock ~ ~ ~ air
        loot spawn ~ ~ ~ loot coc:set_item/raw_copper_chunk

    if block ~ ~ ~ blackstone function ./convert/blackstone:
        tag @s add coc.done
        if score @s coc.rift_energy matches ..2 scoreboard players set $count coc.dummy 0
        if score @s coc.rift_energy matches 3   scoreboard players set $count coc.dummy 3
        if score @s coc.rift_energy matches 4   scoreboard players set $count coc.dummy 6
        if score @s coc.rift_energy matches 5   scoreboard players set $count coc.dummy 9
        if score @s coc.rift_energy matches 6   scoreboard players set $count coc.dummy 14
        if score @s coc.rift_energy matches 7   scoreboard players set $count coc.dummy 6
        if score @s coc.rift_energy matches 8   scoreboard players set $count coc.dummy 5
        if score @s coc.rift_energy matches 9.. scoreboard players set $count coc.dummy 0

        setblock ~ ~ ~ air
        loot spawn ~ ~ ~ loot coc:set_item/raw_gold_chunk
        
    if entity @s[tag=coc.done] function ./convert/sfx:
        particle explosion ~ ~ ~ 0 0 0 0 10 
        playsound minecraft:entity.generic.explode block @s ~ ~ ~ 1 2
    if block ~ ~ ~ #coc:air unless entity @s[tag=coc.done] if entity @s[distance=..5] positioned ^ ^ ^1 function ./shoot_beam

tag @s remove coc.done

scoreboard players set @s coc.rift_energy 0
