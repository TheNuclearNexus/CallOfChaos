append function_tag load:load {
    "values": [
        str(~/)
    ]
}
scoreboard objectives add coc.dummy dummy
scoreboard objectives add coc.const dummy

scoreboard objectives add coc.rift_id dummy
scoreboard objectives add coc.points dummy

scoreboard objectives add coc.powered dummy

# This is generated from the coc:prelude module via the const 
function ./set_consts


schedule function ./late_load 1s:
    if entity @a function #coc:load
    unless entity @a schedule function ./late_load 1s

function ./tick
schedule function ./5tick 5t
schedule function ./1second 1s