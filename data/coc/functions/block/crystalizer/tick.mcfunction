unless block ~ ~ ~ furnace function ./break:    
    nbt = {id:"minecraft:furnace",tag:{display:{Name:'{"translate":"block.coc.crystalizer"}'}}}
    as @e[type=item,nbt={Item:nbt},distance=..0.5]:
        store result score $count coc.dummy data get entity @s Item.Count
        loot spawn ~ ~ ~ loot coc:block/crystalizer
        kill @s
    kill @s
