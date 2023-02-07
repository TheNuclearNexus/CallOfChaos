scoreboard players set $suc coc.dummy 0
as @e[type=armor_stand,tag=coc.offering_altar,dx=0] if entity @s[tag=!coc.disabled] function ./as_altar:
    if data storage coc:temp Item unless entity @s[tag=coc.has_item]:
        summon item ~.5 ~1 ~.5 {Item:{id:"minecraft:stone",Count:1b,tag:{}},PickupDelay:32767s,Tags:["coc.offering_item"],Age:-32767s}
        positioned ~ ~1 ~ data modify entity @e[type=item,dx=0,tag=coc.offering_item,limit=1] Item set from storage coc:temp Item
        positioned ~ ~1 ~ data modify entity @e[type=item,dx=0,tag=coc.offering_item,limit=1] Item.Count set value 1b
        tag @s add coc.has_item
        scoreboard players set $suc coc.dummy 1
    if score $suc coc.dummy matches 0 if entity @s[tag=coc.has_item]:
        tag @s remove coc.has_item
        positioned ~ ~1 ~ as @e[type=item,dx=0,tag=coc.offering_item]:
            data modify entity @s PickupDelay set value 5s
            data modify entity @s Motion set value [0.0d,0.2d,0.0d]
            tag @s remove coc.offering_item

if score $suc coc.dummy matches 1:
    item modify entity @s[gamemode=!creative] weapon.mainhand coc:reduce_count