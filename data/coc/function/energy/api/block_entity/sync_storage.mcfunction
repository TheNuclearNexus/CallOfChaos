#> @params {
#   uuid: string
#   capacity: int
#   consumption: int
# }

$data modify storage coc:energy networks[].bubbles[].sinks[{uuid: $(uuid)}] merge value {   \
    capacity: $(capacity)                                                                   \
    consumption: $(consumption)                                                             \
}