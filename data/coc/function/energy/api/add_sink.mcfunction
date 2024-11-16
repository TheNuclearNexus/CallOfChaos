#> @params {
#   bubble_uuid: string
#   sink_uuid: string
# }

from ./types import Sink

if is_debug():
    $execute unless data storage coc:energy networks[].bubbles[{id: "$(bubble_uuid)"}] run \
        return run tellraw @a ["",{"text": "Bubble with id: ", "color": "red"}, {"text": "$(bubble_uuid)"}, {"text": " does not exist!", "color": "red"}]

    $execute if data storage coc:energy networks[].bubbles[].sinks[{uuid: "$(sink_uuid)"}] run \
        return run tellraw @a [                                         \
            "",                                                         \
            {"text": "Sink with id: ", "color": "red"},                 \
            {"text": "$(sink_uuid)"},                                   \
            {"text": " already exists in a network", "color": "red"}    \
        ]


$data modify storage coc:temp bubble set from storage coc:energy networks[].bubbles[{uuid: "$(bubble_uuid)"}]

data modify storage coc:temp bubble.sinks append value Sink()

$data modify storage coc:temp bubble.sinks[-1].uuid set value "$(sink_uuid)"

$data modify storage coc:energy networks[].bubbles[{id: $(bubble_uuid)}] set from storage coc:temp bubble