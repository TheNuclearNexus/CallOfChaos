append function_tag coc:item/coas {"values": [
    "coc:item/blightsight_goggles/use"
]}

if data storage coc:temp Item.tag.smithed{id:"coc:blightsight_goggles"} unless data entity @s Inventory[{Slot:103b}] function ./equip:
    if data storage coc:temp Item.Slot run function ./equip_offhand:
        item replace entity @s armor.head from entity @s weapon.offhand
        item replace entity @s weapon.offhand with air
    unless data storage coc:temp Item.Slot function ./equip_mainhand:
        item replace entity @s armor.head from entity @s weapon.mainhand
        item replace entity @s weapon.mainhand with air
