append function_tag load:load {
    "values": [
        str(~/)
    ]
}
scoreboard objectives add coc.dummy dummy
scoreboard objectives add coc.const dummy

scoreboard objectives add coc.rift_id dummy
scoreboard objectives add coc.points dummy
# This is generated from the coc:prelude module via the const 
function ./set_consts


function ./tick
schedule function ./1second 1s