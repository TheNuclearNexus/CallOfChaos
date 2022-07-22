unless block ~ ~ ~ furnace function ./break:
    nbt = {id:"minecraft:furnace",tag:{display:{Name:'{"translate":"block.coc.amalgam_forge"}'}}}
    as @e[type=item,nbt={Item:nbt},distance=..0.5]:
        store result score $count coc.dummy data get entity @s Item.Count
        loot spawn ~ ~ ~ loot coc:block/amalgam_forge
        kill @s
    kill @s

states = {
    off: 4260008,
    on: 4260009,
    smelting: 4260010
}



if score @s coc.rift_energy matches 0:
    data modify entity @s ArmorItems[3].tag.CustomModelData set value states.off

if score @s coc.rift_energy matches 1.. function ./update_model:
    data modify entity @s Fire set value 2s
    
    positioned ~ ~-1 ~ unless entity @e[type=armor_stand,tag=coc.eternal_burner,distance=..0.5,scores={coc.rift_energy=1..}]:
        data modify entity @s ArmorItems[3].tag.CustomModelData set value states.on
    positioned ~ ~-1 ~ if entity @e[type=armor_stand,tag=coc.eternal_burner,distance=..0.5,scores={coc.rift_energy=1..}]:
        data modify entity @s ArmorItems[3].tag.CustomModelData set value states.smelting

