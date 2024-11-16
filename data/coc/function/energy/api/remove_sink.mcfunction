#> @params {
#   network_id: int
#   sink_uuid: int   
# }

if is_debug():
    $execute unless data storage coc:energy networks[{id: $(network_id)}] run \
        return run tellraw @a [{"text": "Network with id: ", "color": "red"}, {"text": "$(network_id)"}, {"text": " does not exist!", "color": "red"}]

    $execute unless data storage coc:energy networks[{id: $(network_id)}].bubbles[].sinks[{id: "$(sink_uuid)"}] run \
        return run tellraw @a [                                                                             \
            "",                                                                                             \
            {"text": "Sink with id: ", "color": "red"},                                                     \
            {"text": "$(sink_uuid)","clickEvent":{"action":"copy_to_clipboard","value":"$(sink_uuid)"}},    \
            {"text": " does not exist in network ", "color": "red"},                                        \
            {"text": "$(network_id)"}                                                                       \
        ]


$data remove storage coc:energy networks[{id: $(network_id)}].bubbles[].sinks[{uuid: "$(sink_uuid)"}]
