# Ambience
particle minecraft:reverse_portal ~ ~ ~ 5 5 5 0 10 normal
particle minecraft:reverse_portal ~ ~ ~ 2 2 2 0.2 10 normal

# Destruction
if score #daytime coc.dummy matches 23000.. return run function ./kill
if score #daytime coc.dummy matches ..13000 return run function ./kill

if score @s coc.points matches 50.. return run function ./kill