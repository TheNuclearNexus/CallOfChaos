#> @params {
#   network_id: int
#   bubble_uuid: string
#   x: int
#   y: int
#   z: int
# }

from ./types import Bubble

if is_debug():
    $execute unless data storage coc:energy networks[{id: $(network_id)}] run \
        return run tellraw @a ["",{"text": "Network with id: ", "color": "red"}, {"text": "$(network_id)"}, {"text": " does not exist!", "color": "red"}]

    $execute if data storage coc:energy networks[{id: $(network_id)}].bubbles[{uuid: $(bubble_uuid)}] run \
        return run tellraw @a [                                         \
            "",                                                         \
            {"text": "Bubble with id: ", "color": "red"},               \
            {"text": "$(bubble_uuid)"},                                 \
            {"text": " already exists in network ", "color": "red"},    \
            {"text": "$(network_id)"}                                   \
        ]

$data modify storage coc:temp network set from storage coc:energy networks[{id: $(network_id)}]

bubble = Bubble()
data modify storage coc:temp network.bubbles append value bubble

$data modify storage coc:temp network.bubbles[-1].uuid set value "$(bubble_uuid)"
$data modify storage coc:temp network.bubbles[-1].x set value "$(x)"
$data modify storage coc:temp network.bubbles[-1].y set value "$(y)"
$data modify storage coc:temp network.bubbles[-1].z set value "$(z)"
$data modify storage coc:temp network.bubbles[-1].transfer set value $(transfer) 

path = ./update_bubble
raw f"$execute positioned $(x) $(y) $(z) as @e[distance=..{bubble['radius']},tag=coc.energy.sink] at @s run function {path}"

$data modify storage coc:energy networks[{id: $(network_id)}] set from storage coc:temp network