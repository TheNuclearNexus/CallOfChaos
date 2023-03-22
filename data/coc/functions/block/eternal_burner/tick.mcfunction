from plugins.smithed.custom_items import get_item
eternal_burner = get_item(ctx, 'coc:eternal_burner').models

unless block ~ ~ ~ furnace function ./break:
    nbt = {id:"minecraft:furnace",tag:{display:{Name:'{"translate":"block.coc.eternal_burner"}'}}}
    as @e[type=item,nbt={Item:nbt},distance=..0.5]:
        store result score $count coc.dummy data get entity @s Item.Count
        loot spawn ~ ~ ~ loot coc:block/eternal_burner
        kill @s
    kill @s

scoreboard players set $cmd coc.dummy eternal_burner.disabled
if score @s coc.rift_energy matches 1.. function ./update_model:
    data modify entity @s Fire set value 2s
    scoreboard players set $cmd coc.dummy eternal_burner.enabled

    if block ~ ~1 ~ #coc:air if score @s coc.rift_energy matches 5.. scoreboard players set $cmd coc.dummy eternal_burner.burning
    # tellraw @a [{"score":{"objective":"coc.rift_energy","name":"@s"}}]
store result entity @s item.tag.CustomModelData int 1 scoreboard players get $cmd coc.dummy
