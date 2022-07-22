unless block ~ ~ ~ furnace function ./break:
    nbt = {id:"minecraft:furnace",tag:{display:{Name:'{"translate":"block.coc.eternal_burner"}'}}}
    as @e[type=item,nbt={Item:nbt},distance=..0.5]:
        store result score $count coc.dummy data get entity @s Item.Count
        loot spawn ~ ~ ~ loot coc:block/eternal_burner
        kill @s
    kill @s

if score @s coc.rift_energy matches 0 data modify entity @s ArmorItems[3].tag.CustomModelData set value 4260005
if score @s coc.rift_energy matches 1.. function ./update_model:
    data modify entity @s Fire set value 2s
    if block ~ ~1 ~ #coc:air data modify entity @s ArmorItems[3].tag.CustomModelData set value 4260007
    unless block ~ ~1 ~ #coc:air data modify entity @s ArmorItems[3].tag.CustomModelData set value 4260006
