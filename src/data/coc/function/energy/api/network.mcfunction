from ./bubble import BUBBLE_DATA


DEFAULT_NETWORK_BUBBLE_RADIUS = 8

NETWORK_DATA = 'item.components."minecraft:custom_data".coc.network'

function ~/create:
    #> Add a new network to the database
    #
    #> @params {
    #    network_uuid: string  
    #  }

    data modify storage coc:temp network set value {
        bubbles: []                                  
    }                       

    data modify storage coc:energy networks.$(network_uuid) set from storage coc:temp network
    data modify storage coc:energy networks.keys append value {uuid: $(network_uuid: string)}

    return 1

function ~/destroy:
    #> Destroy a network
    #
    #> @params {
    #    network_uuid: string  
    #  }

    data remove storage coc:energy networks.keys[{ uuid: $(network_uuid: string)}]
    data modify storage coc:temp network set from storage coc:energy networks.$(network_uuid)
    data remove storage coc:energy networks.$(network_uuid)
    data modify storage coc:temp network_uuid set value $(network_uuid: string)

    if data storage coc:temp network.bubbles[] function ~/iter with storage coc:temp network.bubbles[-1].uuid:
        data remove storage coc:temp network.bubbles[-1]

        data remove storage coc:energy bubbles.$(uuid).network

        if data storage coc:temp network.bubbles[] function ~/ with storage coc:temp network.bubbles[-1].uuid

    function ./bubble/destroy { bubble_uuid: $(network_uuid: string) } 

function ~/register:
    #> Register an entity as a network

    if is_debug():
        if entity @s[type=!item_display] return:
            tellraw @a {"text": "Cannot register non item_display as a network!", "color": "red"}

        unless data entity @s item return:
            tellraw @a {"text": "Cannot register empty item_display!", "color": "red"} 

    function gu:generate
    tag @s add coc.energy.network

    data modify storage coc:temp network_uuid set from storage gu:main out
    data modify entity @s NETWORK_DATA merge value {}
    data modify entity @s f'{NETWORK_DATA}.uuid' set from storage gu:main out

    function ~/../create with storage coc:temp {}

    data modify entity @s BUBBLE_DATA merge value {          
        transfer: -1,                                
        radius: DEFAULT_NETWORK_BUBBLE_RADIUS                 
    }                                                

    # Register the bubble in the storage
    function ./bubble/register

function ~/unregister:
    data modify storage coc:temp network_uuid set from entity @s f"{NETWORK_DATA}.uuid"
    data modify storage coc:temp bubble_uuid set from entity @s f"{NETWORK_DATA}.uuid"

    function ~/../destroy with storage coc:temp {}
    function ./bubble/unregister with storage coc:temp {}