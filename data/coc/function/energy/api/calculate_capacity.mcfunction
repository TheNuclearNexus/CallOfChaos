#> @params {
#   bubble_uuid: string
# }

$execute unless data storage coc:energy networks[].bubbles[{uuid: "$(bubble_uuid)"}] run return run \
    return run tellraw @a ["",{"text": "Bubble with id: ", "color": "red"}, {"text": "$(bubble_uuid)"}, {"text": " does not exist!", "color": "red"}]

$data modify storage coc:temp bubble set from storage coc:energy networks[].bubbles[{uuid: "$(bubble_uuid)"}]
data modify storage coc:temp sinks set from storage coc:temp bubble.sinks

store result score #total_capacity coc.dummy data get storage coc:temp bubble.base_capacity

if data storage coc:temp sinks[] function ~/iter:
    store result score #c coc.dummy data get storage coc:temp sinks[-1].capacity
    
    scoreboard players operation #total_capacity coc.dummy += #c coc.dummy

    data remove storage coc:temp sinks[-1]

    if data storage coc:temp sinks[] function ~/

$execute store result storage coc:energy networks[].bubbles[{uuid: "$(bubble_uuid)"}].max_capacity int 1 run scoreboard players get #total_capacity coc.dummy

