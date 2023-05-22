function coc:modules/rift/tick

as @a at @s function coc:entity/player/tick

as @e[type=marker,tag=coc.marker] at @s function coc:entity/marker/tick

store result score $gameTime coc.dummy time query gametime

schedule function coc:global/tick 1t replace