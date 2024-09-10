schedule function ~/ 1t

store result score #gametime coc.dummy time query gametime
store result score #daytime coc.dummy time query daytime

as @e[type=item_display,tag=coc.block] at @s function coc:block/tick

as @e[type=item_display,tag=coc.entity] at @s function coc:entity/item_display/tick