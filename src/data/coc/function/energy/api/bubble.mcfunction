from ./mod import MAX_NETWORK_DISTANCE

BUBBLE_DATA = 'item.components."minecraft:custom_data".coc.bubble'

function ~/set_network:
    #> Set the parent network for a bubble
    #
    #> @params {
    #    bubble_uuid: string,
    #    network_uuid: string
    #  }

    # If the bubble was already marked as in a network
    # Remove it from it's list
    if data storage coc:energy bubbles.$(bubble_uuid).network function ~/../reset_network {bubble_uuid: $(bubble_uuid: string)}
    # Add the bubble to the network's list and set the bubble's network
    data modify storage coc:energy bubbles.$(bubble_uuid).network set value $(network_uuid: string)
    data modify storage coc:energy networks.$(network_uuid).bubbles append value {uuid: $(bubble_uuid: string)}

function ~/reset_network:
    #> Reset the parent network for a bubble
    #
    #> @params {
    #    bubble_uuid: string
    #  }
    
    execute function ~/remove with storage coc:energy bubbles.$(bubble_uuid):
        data remove storage coc:energy networks.$(network).bubbles[{uuid: $(uuid: string)}]
    
    data remove storage coc:energy bubbles.$(bubble_uuid).network

function ~/update_network:
    #> Add a bubble to the nearest network
    #
    #> @params {
    #    bubble_uuid: string
    #  }

    unless entity @e[type=minecraft:item_display, tag=coc.energy.network, limit=1, distance=f"..{MAX_NETWORK_DISTANCE}"]:
        return fail

    as @n[type=item_display, tag=coc.energy.network, distance=f"..{MAX_NETWORK_DISTANCE}"] function gu:generate

    data modify storage coc:temp bubble_uuid set value $(bubble_uuid: string)
    
    data modify storage coc:temp network_uuid set from storage gu:main out

    function ~/../set_network with storage coc:temp {}
        
function ~/create:
    #> Add a new bubble to a network
    #
    #> @params {
    #    bubble_uuid: string,
    #    transfer: int,
    #    x: int,
    #    y: int,
    #    z: int
    #  }

    data modify storage coc:temp bubble set value {
        uuid: $(bubble_uuid: string),
        transfer: $(transfer),                      
        radius: 16,                                 
        base_capacity: 100,                         
        max_capacity: 100,                          
        capacity: 0,                                
        x: $(x),                                    
        y: $(y),                                    
        z: $(z),                                    
        sinks: []                                   
    }

    data modify storage coc:energy bubbles.keys append value {uuid: $(bubble_uuid: string)}
    data modify storage coc:energy bubbles.$(bubble_uuid) set from storage coc:temp bubble

    function ~/../update_network {
        bubble_uuid: $(bubble_uuid: string)
    }

    # TODO: Update sinks that are within the new bubble
    positioned $(x) $(y) $(z) as @e[tag=coc.energy.sink,distance=..$(radius)] function ./update_bubble
    return 1

function ~/destroy:
    data remove storage coc:energy bubbles.keys[{ uuid: $(bubble_uuid: string) }]
    data modify storage coc:temp bubble set from storage coc:energy bubbles.$(bubble_uuid)

    if data storage coc:temp bubble.network function ~/../reset_network/remove with storage coc:temp bubble

    data remove storage coc:energy bubbles.$(bubble_uuid)

    if data storage coc:temp bubble.sinks[] function ~/iter_sink with storage coc:temp bubble.sinks[-1]:
        data remove storage coc:temp bubble.sinks[-1]
        data remove storage coc:energy sinks.$(sink_uuid).bubble

        if data storage coc:temp bubble.sinks[] function ~/ with storage coc:temp bubble.sinks[-1]

function ~/register:
    if is_debug():
        if entity @s[type=!item_display] return:
            tellraw @a {"text": "Cannot register non item_display as a bubble!", "color": "red"}

        unless data entity @s item return:
            tellraw @a {"text": "Cannot register empty item_display!", "color": "red"} 

    function gu:generate

    tag @s add coc.energy.bubble

    data modify storage coc:temp bubble_uuid set from storage gu:main out

    data modify entity @s BUBBLE_DATA merge value {}
    data modify entity @s f'{BUBBLE_DATA}.uuid' set from storage gu:main out

    unless data entity @s f'{BUBBLE_DATA}.transfer':
        data modify entity @s f'{BUBBLE_DATA}.transfer' set value 16

    unless data entity @s f'{BUBBLE_DATA}.radius':
        data modify entity @s f'{BUBBLE_DATA}.radius' set value 4

    data modify storage coc:temp transfer set from entity @s f'{BUBBLE_DATA}.transfer'

    execute summon marker function ~/get_pos:
        store result storage coc:temp x int 1 data get entity @s Pos[0]
        store result storage coc:temp y int 1 data get entity @s Pos[1]
        store result storage coc:temp z int 1 data get entity @s Pos[2]
        kill @s

    function ~/../create with storage coc:temp {}
    function ~/../sync_storage with entity @s BUBBLE_DATA

    return 1

function ~/unregister:
    data modify storage coc:temp bubble_uuid set from entity @s f"{BUBBLE_DATA}.uuid"

    function ~/../destroy with storage coc:temp {} 

function ~/sync_storage:
    #> @params {
    #   uuid: string
    #   transfer: int
    #   radius: int
    # }

    data modify storage coc:energy bubbles.$(uuid).transfer set value $(transfer)
    data modify storage coc:energy bubbles.$(uuid).radius set value $(radius)

    at $(uuid) as @e[type=item_display, tag=coc.energy.sink, distance=..$(radius)] function ./sink/update_bubble

function ~/calculate_capacity:
    #> Recalculate the capacity for the given bubble
    #
    #> @params {
    #    bubble_uuid: string    
    #  }

    if is_debug():
        $execute unless data storage coc:energy bubbles."$(bubble_uuid)" run \
            return run tellraw @a ["",{"text": "Bubble with id: ", "color": "red"}, {"text": "$(bubble_uuid)"}, {"text": " does not exist!", "color": "red"}]

    data modify storage coc:temp bubble set from storage coc:energy bubbles.$(bubble_uuid)
    data modify storage coc:temp sinks set from storage coc:temp bubble.sinks

    store result score #total_capacity coc.dummy data get storage coc:temp bubble.base_capacity

    if data storage coc:temp sinks[] function ~/iter with storage coc:temp sinks[-1]:
        store result score #c coc.dummy data get storage coc:energy sinks.$(uuid).capacity
        scoreboard players operation #total_capacity coc.dummy += #c coc.dummy
        data remove storage coc:temp sinks[-1]

        if data storage coc:temp sinks[] function ~/ with storage coc:temp sinks[-1]

    store result storage coc:energy bubbles.$(bubble_uuid).max_capacity int 1 scoreboard players get #total_capacity coc.dummy