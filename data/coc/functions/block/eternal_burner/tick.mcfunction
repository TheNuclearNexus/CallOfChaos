unless block ~ ~ ~ furnace function ./break:
    nbt = {id:"minecraft:furnace",tag:{display:{Name:'{"translate":"block.coc.eternal_burner"}'}}}
    as @e[type=item,nbt={Item:nbt},distance=..0.5]:
        store result score $count coc.dummy data get entity @s Item.Count
        loot spawn ~ ~ ~ loot coc:block/eternal_burner
        kill @s
    kill @s

scoreboard players set $cmd coc.dummy 4260005
if score @s coc.rift_energy matches 1.. function ./update_model:
    data modify entity @s Fire set value 2s
    scoreboard players set $cmd coc.dummy 4260006

    if block ~ ~1 ~ #coc:air if score @s coc.rift_energy matches 5.. scoreboard players set $cmd coc.dummy 4260007
    # tellraw @a [{"score":{"objective":"coc.rift_energy","name":"@s"}}]
store result entity @s ArmorItems[3].tag.CustomModelData int 1 scoreboard players get $cmd coc.dummy
