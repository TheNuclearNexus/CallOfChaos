#> @params {
#   network_id: int
#   bubble_uuid: string
# }

if is_debug():
    $execute unless data storage coc:energy networks[{id: $(network_id)}] run \
        return run tellraw @a [{"text": "Network with id: ", "color": "red"}, {"text": "$(network_id)"}, {"text": " does not exist!", "color": "red"}]

    $execute unless data storage coc:energy networks[{id: $(network_id)}].bubbles[{uuid: "$(bubble_uuid)"}] run \
        return run tellraw @a [                                                                                 \
            "",                                                                                                 \
            {"text": "Bubble with id: ", "color": "red"},                                                       \
            {"text": "$(bubble_uuid)","clickEvent":{"action":"copy_to_clipboard","value":"$(bubble_uuid)"}},    \
            {"text": " does not exist in network ", "color": "red"},                                            \
            {"text": "$(network_id)"}                                                                           \
        ]


$data remove storage coc:energy networks[{id: $(network_id)}].bubbles[{uuid: "$(bubble_uuid)"}]
