from coc:modules/playerdb import PlayerDB
from coc:modules/armory import ClassRegistry

append function ./player/tick:
    if score @s coc.coas matches 1.. function ./player/tick/_coas:
        scoreboard players reset @s coc.coas

        data modify storage coc:temp Player set from entity @s {}
        data modify storage coc:temp Offhand set from storage coc:temp Player[{Slot:-106b}]

        if data storage coc:temp Offhand{id: "minecraft:carrot_on_a_stick"} 
            unless data storage coc:temp Player.SelectedItem{id:"minecraft:carrot_on_a_stick"}
                data modify storage coc:temp Used set from storage coc:temp Offhand
        if data storage coc:temp Player.SelectedItem{id:"minecraft:carrot_on_a_stick"}
            data modify storage coc:temp Used set from storage coc:temp Player.SelectedItem
        
        data remove storage coc:temp Used.Slot
        function #coc:player/coas

    unless score @s coc.player_id matches f"{-pow(2, 31)}.." function ./player/set_id:
        scoreboard players add $total coc.player_id 1
        scoreboard players operation @s coc.player_id = $total coc.player_id
        PlayerDB.setup()


    at @s if entity @s[tag=coc.equiped] function ./player/check_class:
        PlayerDB.get()
        ClassRegistry.run_passives()


append function ./player/second:
    if entity @e[type=item_display,tag=coc.chalk,distance=..16,limit=1]:
        as @e[type=item_display,tag=coc.chalk,distance=..16] at @s function ../item/chalk/try_remove:
            unless block ~ ~ ~ #coc:air function ../item/chalk/remove
            unless block ~ ~-1 ~ #coc:solid function ../item/chalk/remove:
                on passengers function ./item/chalk/remove_passenger:
                    if entity @s[type=item] function ../item/chalk/interact/remove_item_data
                    if entity @s[type=interaction] kill @s
                kill @s
                function ../item/chalk/update_lines
                tag @e remove coc.checked
            