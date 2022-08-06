unless block ~ ~ ~ furnace function ./break:    
    nbt = {id:"minecraft:furnace",tag:{display:{Name:'{"translate":"block.coc.entropic_accelerator"}'}}}
    as @e[type=item,nbt={Item:nbt},distance=..0.5]:
        store result score $count coc.dummy data get entity @s Item.Count
        loot spawn ~ ~ ~ loot coc:block/entropic_accelerator
        kill @s
    kill @s
