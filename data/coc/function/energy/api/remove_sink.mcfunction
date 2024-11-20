#> @params {
#   sink_uuid: int   
# }

if is_debug():
    $execute unless data storage coc:energy networks[].bubbles[].sinks[{uuid: "$(sink_uuid)"}] run \
        return run tellraw @a [                                                                             \
            "",                                                                                             \
            {"text": "Sink with id: ", "color": "red"},                                                     \
            {"text": "$(sink_uuid)","clickEvent":{"action":"copy_to_clipboard","value":"$(sink_uuid)"}},    \
            {"text": " does not exist in a network", "color": "red"}                                        \
        ]

$data modify storage coc:temp bubble_uuid set from storage coc:energy networks[].bubbles[{sinks: [{uuid: "$(sink_uuid)"}]}].uuid

$data remove storage coc:energy networks[].bubbles[].sinks[{uuid: "$(sink_uuid)"}]

function ./calculate_capacity with storage coc:temp {}