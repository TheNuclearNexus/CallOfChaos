unless block ~ ~ ~ dropper function ./break:
    positioned ~ ~0.7 ~ data merge entity @e[type=item,dx=0,tag=coc.rift_stabilizer,limit=1] {PickupDelay: 0s, Tags:[]}


    nbt = {id:"minecraft:dropper",tag:{display:{Name:'{"translate":"block.coc.rift_stabilizer"}'}}}
    as @e[type=item,nbt={Item:nbt},distance=..0.5]:
        store result score $count coc.dummy data get entity @s Item.Count
        loot spawn ~ ~ ~ loot coc:block/rift_stabilizer
        kill @s
    kill @s
