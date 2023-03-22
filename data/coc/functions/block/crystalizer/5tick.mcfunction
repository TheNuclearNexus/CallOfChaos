from plugins.smithed.custom_items import get_item
states = get_item(ctx, 'coc:crystalizer').models
if score @s coc.rift_energy matches 20.. scoreboard players set @s coc.rift_energy 20


if score @s coc.rift_energy matches 1.. function ./set_on:
    if entity @s[tag=!coc.up,tag=!coc.down] data modify entity @s item.tag.CustomModelData set value states.enabled
    if entity @s[tag=coc.up] data modify entity @s item.tag.CustomModelData set value states.enabled_up
    if entity @s[tag=coc.down] data modify entity @s item.tag.CustomModelData set value states.enabled_down

unless score @s coc.rift_energy matches 1.. function ./set_off:
    if entity @s[tag=!coc.up,tag=!coc.down] data modify entity @s item.tag.CustomModelData set value states.disabled
    if entity @s[tag=coc.up] data modify entity @s item.tag.CustomModelData set value states.disabled_up
    if entity @s[tag=coc.down] data modify entity @s item.tag.CustomModelData set value states.disabled_down
    