unless block ~ ~ ~ furnace function ./break:
    positioned ~ ~0.7 ~ data merge entity @e[type=item,dx=0,tag=coc.offering_item,limit=1] {PickupDelay: 0s, Tags:[]}


    nbt = {id:"minecraft:furnace",tag:{display:{Name:'{"translate":"block.coc.offering_altar"}'}}}
    as @e[type=item,nbt={Item:nbt},distance=..0.5]:
        store result score $count coc.dummy data get entity @s Item.Count
        loot spawn ~ ~ ~ loot coc:block/offering_altar
        kill @s
    kill @s

    if entity @e[type=armor_stand,tag=coc.natural_rift,distance=..8] schedule function ./break/check_status 1t:
        as @e[type=armor_stand,tag=coc.natural_rift] at @s function ./place/check_count

