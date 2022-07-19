if score @s coc.coas matches 1.. function ./use_coas:
    scoreboard players reset @s coc.coas
    if data entity @s Inventory[{Slot:-106b,id:"minecraft:carrot_on_a_stick"}] data modify storage coc:temp Item set from entity @s Inventory[{Slot:-106b}]
    if data entity @s SelectedItem{id:"minecraft:carrot_on_a_stick"} data modify storage coc:temp Item set from entity @s SelectedItem
    function #coc:item/coas

unless score @s coc.player_id matches 1.. function ./set_id:
    scoreboard players add $global coc.player_id 1
    scoreboard players operation @s coc.player_id = $global coc.player_id
    