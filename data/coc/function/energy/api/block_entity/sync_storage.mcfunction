#> @params {
#   uuid: string
#   capacity: int
#   consumption: int
# }

$data modify storage coc:energy networks[].bubbles[].sinks[{uuid: "$(uuid)"}].capacity set value $(capacity)
$data modify storage coc:energy networks[].bubbles[].sinks[{uuid: "$(uuid)"}].consumption set value $(consumption)