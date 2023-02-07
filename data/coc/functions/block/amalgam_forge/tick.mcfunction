from plugins.smithed.custom_items import get_item
unless block ~ ~ ~ furnace function ./break:
    nbt = {id:"minecraft:furnace",tag:{display:{Name:'{"translate":"block.coc.amalgam_forge"}'}}}
    as @e[type=item,nbt={Item:nbt},distance=..0.5]:
        store result score $count coc.dummy data get entity @s Item.Count
        loot spawn ~ ~ ~ loot coc:block/amalgam_forge
        kill @s

    positioned ~ ~0.58 ~ kill @e[type=area_effect_cloud,tag=coc.amalgam_forge.display,distance=..0.5]
    kill @s

states = get_item(ctx, 'coc:amalgam_forge').models

scoreboard players set $cmd coc.dummy states.disabled

if score @s coc.rift_energy matches 1.. function ./update_model:
    data modify entity @s Fire set value 2s
    
    scoreboard players set $cmd coc.dummy states.enabled

    positioned ~ ~-1 ~ if entity @e[type=armor_stand,tag=coc.eternal_burner,distance=..0.5,scores={coc.rift_energy=1..}] if score @s coc.rift_energy matches 20..:
        scoreboard players set $cmd coc.dummy states.smelting
store result entity @s ArmorItems[3].tag.CustomModelData int 1 scoreboard players get $cmd coc.dummy
