from ./mod import MAX_BUBBLE_RADIUS
from ./bubble import BUBBLE_DATA

SINK_DATA = 'item.components."minecraft:custom_data".coc.sink'

function ~/set_bubble:
    #> Set the parent bubble for a sink
    #
    #> @params {
    #    sink_uuid: string,
    #    bubble_uuid: string  
    #  }

    # If the sink was already marked as in a bubble
    # Remove it from it's list
    if data storage coc:energy sinks.$(sink_uuid).bubble function ~/../reset_bubble {sink_uuid: $(sink_uuid: string)}

    # Add the sink to the bubble's list and set the sink's bubble
    data modify storage coc:energy bubbles.$(bubble_uuid).sinks append value {uuid: $(sink_uuid: string)}
    data modify storage coc:energy sinks.$(sink_uuid).bubble set value $(bubble_uuid: string)

    function ./bubble/calculate_capacity {bubble_uuid: $(bubble_uuid: string)}

function ~/reset_bubble:
    #> Reset the parent bubble for a sink
    #
    #> @params {
    #    sink_uuid: string
    #  }
    
    execute function ~/remove with storage coc:energy sinks.$(sink_uuid):
        data remove storage coc:energy bubbles.$(bubble).sinks[{uuid: $(uuid: string)}]
    
    data remove storage coc:energy sinks.$(sink_uuid).bubble

function ~/update_bubble:
    #> Update the parent bubble to the nearest for a sink
    
    data modify storage coc:temp sink_uuid set from entity @s f"{SINK_DATA}.uuid"

    unless function ~/../get_bubble:
        return 0

    function ~/../reset_bubble with storage coc:temp {}

    function ~/../set_bubble with storage coc:temp {}

function ~/create:
    #> Add the sink into the energy database
    #
    #> @params {
    #    sink_uuid: string
    #  }

    data modify storage coc:temp sink set value {  
        uuid: $(sink_uuid: string),
        capacity: 50,                               
        consumption: 2                              
    }                                               

    data modify storage coc:energy sinks.$(sink_uuid) set from storage coc:temp sink

    return 1

function ~/destroy:
    #> Add the sink into the energy database
    #
    #> @params {
    #    sink_uuid: string
    #  }

    if data storage coc:energy sinks.$(sink_uuid).bubble function ~/../reset_bubble {sink_uuid: $(sink_uuid: string)}

    data remove storage coc:energy sinks.$(sink_uuid)


function ~/register:
    if is_debug():
        if entity @s[type=!item_display] return:
            tellraw @a {"text": "Cannot register non item_display as a sink!", "color": "red"}

        unless data entity @s item return:
            tellraw @a {"text": "Cannot register empty item_display!", "color": "red"} 

    function gu:generate

    tag @s add coc.energy.sink
    data modify storage coc:temp sink_uuid set from storage gu:main out
    data modify entity @s SINK_DATA merge value {}
    data modify entity @s f'{SINK_DATA}.uuid' set from storage gu:main out

    function ~/../create with storage coc:temp {}

    unless data entity @s f'{SINK_DATA}.capacity':
        data modify entity @s f'{SINK_DATA}.capacity' set value 50

    unless data entity @s f'{SINK_DATA}.consumption':
        data modify entity @s f'{SINK_DATA}.consumption' set value 2

    if function ~/../get_bubble:
        function ~/../set_bubble with storage coc:temp {}

    function ~/../sync_storage with entity @s SINK_DATA

    return 1

function ~/unregister:
    data modify storage coc:temp sink_uuid set from entity @s f"{SINK_DATA}.uuid"

    function ~/../destroy with storage coc:temp {} 

function ~/sync_storage:
    #> @params {
    #   uuid: string
    #   capacity: int
    #   consumption: int
    # }

    data modify storage coc:energy sinks.$(uuid).capacity set value $(capacity)
    data modify storage coc:energy sinks.$(uuid).consumption set value $(consumption)

# Get the first bubble that the execution context is within
function ~/get_bubble:
    data modify storage coc:temp bubbles set value []
    # Fill bubbles with *all* registered bubbles 
    data modify storage coc:temp bubbles set from storage coc:energy bubbles.keys

    data remove storage coc:temp bubble_uuid

    function ~/check_distance:
        # If we are in the cylinder defined by the bubble, radius is variable,
        # height is always +/- 3 blocks

        positioned $(x) ~ $(z) if entity @s[distance=..$(radius)]:        
            at @s positioned ~-0.5 $(y) ~-0.5 positioned ~ ~-1 ~ if entity @s[dy=3]:
                return 1

        return 0

    data modify storage coc:temp bubbles set value []

    as @e[type=item_display,tag=coc.energy.bubble,distance=f"..{MAX_BUBBLE_RADIUS}",sort=nearest] function ~/add:
        data modify storage coc:temp bubbles append from entity @s BUBBLE_DATA    

    execute function ~/iter with storage coc:temp bubbles[-1]:
        store result score #found coc.dummy function ~/../check_distance with storage coc:energy bubbles.$(uuid)

        if score #found coc.dummy matches 1 return:
            data modify storage coc:temp bubble_uuid set from storage coc:temp bubbles[-1].uuid

        data remove storage coc:temp bubbles[-1]

        if data storage coc:temp bubbles[] function ~/ with storage coc:temp bubbles[-1]


    if data storage coc:temp bubble_uuid return 1
    return fail
