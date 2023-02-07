from plugins.smithed.custom_items import get_item
entropic_accelerator = get_item(ctx, 'coc:entropic_accelerator').models

if score @s coc.rift_energy matches 20.. scoreboard players set @s coc.rift_energy 20


if score @s coc.rift_energy matches 1.. function ./set_on:
    if entity @s[tag=!coc.up,tag=!coc.down] data modify entity @s ArmorItems[3].tag.CustomModelData set value entropic_accelerator.disabled
    if entity @s[tag=coc.up] data modify entity @s ArmorItems[3].tag.CustomModelData set value entropic_accelerator.disabled_up
    if entity @s[tag=coc.down] data modify entity @s ArmorItems[3].tag.CustomModelData set value entropic_accelerator.disabled_down

unless score @s coc.rift_energy matches 1.. function ./set_off:
    if entity @s[tag=!coc.up,tag=!coc.down] data modify entity @s ArmorItems[3].tag.CustomModelData set value entropic_accelerator.enabled
    if entity @s[tag=coc.up] data modify entity @s ArmorItems[3].tag.CustomModelData set value entropic_accelerator.enabled_up
    if entity @s[tag=coc.down] data modify entity @s ArmorItems[3].tag.CustomModelData set value entropic_accelerator.enabled_down