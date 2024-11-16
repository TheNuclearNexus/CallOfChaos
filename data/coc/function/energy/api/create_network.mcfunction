#> @params {
#   network_id: int   
#   network_uuid: string
# }

from ./types import Network

if is_debug():
    $execute if data storage coc:energy networks[{id: $(network_id)}] run \
        return run tellraw @a ["", {"text": "Network with id: ", "color": "red"}, {"text": "$(network_id)"}, {"text": " already exists!", "color": "red"}]

data modify storage coc:energy networks append value Network()


$data modify storage coc:energy networks[-1].id set value $(network_id)
$data modify storage coc:energy networks[-1].uuid set value $(network_uuid)

data modify storage coc:temp network set from storage coc:energy networks[-1]

data modify storage coc:temp network_id set from storage coc:temp network.id 
data modify storage coc:temp bubble_uuid set from storage coc:temp network.uuid 

data modify storage coc:temp transfer set value -1

execute summon marker function ~/get_pos:
    data modify storage coc:temp pos set from entity @s Pos

    store result storage coc:temp x int 1 data get storage coc:temp pos[0]
    store result storage coc:temp y int 1 data get storage coc:temp pos[1]
    store result storage coc:temp z int 1 data get storage coc:temp pos[2]

    kill @s

function ./add_bubble with storage coc:temp {}