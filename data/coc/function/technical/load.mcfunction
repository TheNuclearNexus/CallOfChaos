append function_tag minecraft:load {
    "values": [
        str(~/)
    ]
}
scoreboard objectives add coc.dummy dummy
scoreboard objectives add coc.const dummy
# This is generated from the coc:prelude module via the const 
function ./set_consts


schedule function ./1second 1s