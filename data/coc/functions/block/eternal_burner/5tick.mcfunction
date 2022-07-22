# if score @s coc.rift_energy matches 1.. scoreboard players remove @s coc.rift_energy 1
if score @s coc.rift_energy matches 6.. function ./activate:
    scoreboard players set @s coc.rift_energy 5
    if block ~ ~1 ~ #coc:air positioned ~ ~0.5 ~ if entity @e[type=item,distance=..0.5,tag=!coc.checked] function ./activate/valid:
        # say valid
        scoreboard players set $suc coc.dummy 0
        
        as @e[type=item,distance=..0.5,limit=1,tag=!coc.checked] function ./activate/as_item:
            # say as item
            if data entity @s Item{id:"minecraft:obsidian",Count:1b} function ./activate/chaos_shard:
                scoreboard players set $suc coc.dummy 1
                loot spawn ~ ~ ~ loot coc:item/chaos_shard
                kill @s

            tag @s add coc.checked

        if score $suc coc.dummy matches 1 scoreboard players set @s coc.rift_energy 0

