# ~/ means this function
schedule function ~/ 1s

as @a at @s function coc:entity/player/1second
as @e[type=item_display,tag=coc.entity] at @s function coc:entity/item_display/1second
as @e[type=item_display,tag=coc.block] at @s function ./../block/1second