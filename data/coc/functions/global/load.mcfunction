scoreboard objectives add coc.dummy dummy
scoreboard objectives add coc.rift_id dummy
scoreboard objectives add coc.player_id dummy

scoreboard objectives add coc.x dummy
scoreboard objectives add coc.z dummy

scoreboard objectives add coc.cursor.x dummy
scoreboard objectives add coc.cursor.z dummy
scoreboard objectives add coc.cursor.r dummy
scoreboard objectives add coc.cursor.d dummy

scoreboard objectives add coc.screen.w dummy
scoreboard objectives add coc.screen.h dummy

scoreboard objectives add coc.coas minecraft.used:minecraft.carrot_on_a_stick

forceload add -30000000 3200
schedule function coc:global/tick 1t replace
schedule function coc:global/second 1s replace