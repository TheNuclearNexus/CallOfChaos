#> @params {
#   network_id: int   
# }

from ./types import Network

if is_debug():
    $execute unless data storage coc:energy networks[{id: $(network_id)}] run \
        return run tellraw @a ["", {"text": "Network with id: ", "color": "red"}, {"text": "$(network_id)"}, {"text": " does not exist!", "color": "red"}]


$data remove storage coc:energy networks[{id: $(network_id)}]