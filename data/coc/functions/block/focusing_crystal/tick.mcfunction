unless block ~ ~ ~ lantern function ./break:
    playsound block.glass.break master @a
    particle minecraft:block minecraft:amethyst_cluster ~ ~ ~ 0.25 0.25 0.25 0 20

    as @e[type=item,nbt={Item:{"id":"minecraft:lantern"}},distance=..3]:
        scoreboard players set $count coc.dummy 0
        store result score $rawCount coc.dummy data get entity @s Item.Count
        as @e[type=minecraft:armor_stand,tag=coc.focusing_crystal,distance=..4,tag=!coc.broken] at @s unless block ~ ~ ~ lantern:
            tag @s add coc.broken
            scoreboard players add $count coc.dummy 1 
        if score $count coc.dummy > $rawCount coc.dummy scoreboard players operation $count coc.dummy = $rawCount coc.dummy

        loot spawn ~ ~ ~ loot coc:block/focusing_crystal
        
        scoreboard players operation $rawCount coc.dummy -= $count coc.dummy
        store result entity @s Item.Count byte 1 scoreboard players get $rawCount coc.dummy
    kill @s 
