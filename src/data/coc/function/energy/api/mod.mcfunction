

class Networks():
    @staticmethod
    def add(uuid: str = "network_uuid"):
        raw f'$data modify storage coc:energy networks.keys append value {{uuid: "$({uuid})"}}'
        raw f'$data modify storage coc:energy networks."$({uuid})" set from storage coc:temp network'
    
    @staticmethod
    def remove(uuid: str = "network_uuid"):
        raw f'$data remove storage coc:energy networks.keys[{{ uuid: "$({uuid})" }}]'
        raw f'$data remove storage coc:energy networks."$({uuid})"'

    def __init__(self, uuid: str = "network_uuid"):
        self.uuid = uuid

    def add_bubble(self, uuid_path: str = "bubble_uuid"):
        raw f'$data modify storage coc:energy networks."$({self.uuid})".bubbles append value {{uuid: "$({uuid_path})"}}'
        raw f'$data modify storage coc:energy bubbles."$(uuid_path)".networks append value {{uuid: "$({self.uuid})"}}'

    def remove_bubble(self, uuid_path: str = "bubble_uuid"):
        raw f'$data remove storage coc:energy networks."$({self.uuid})".bubbles[{{uuid: "$(uuid_path)"}}]'
        raw f'$data remove storage coc:energy bubbles."$(uuid_path)".networks[{{uuid: "$({self.uuid})"}}]'

class Bubbles():
    @staticmethod
    def add(uuid: str = "bubble_uuid"):
        raw f'$data modify storage coc:energy bubbles.keys append value {{uuid: "$({uuid})"}}'
        raw f'$data modify storage coc:energy bubbles."$({uuid})" set from storage coc:temp bubble'
    
    @staticmethod
    def remove(uuid: str = "bubble_uuid"):
        raw f'$data remove storage coc:energy bubbles.keys[{{ uuid: "$({uuid})" }}]'
        raw f'$data modify storage coc:temp bubble set from storage coc:energy bubbles."$({uuid})"'
        raw f'$data remove storage coc:energy bubbles."$({uuid})"'
        raw f'$data modify storage coc:temp bubble_uuid set value "$({uuid})"'

        if data storage coc:temp bubble.networks[] function ~/iter:
            data modify storage coc:temp network_uuid set from storage coc:temp bubble.networks[-1]
            data remove storage coc:temp bubble.networks[-1]

            execute function ~/remove with storage coc:temp {}:
                Networks("network_uuid").remove_bubble()

            if data storage coc:temp bubble.networks[] function ~/


    def __init__(self, uuid: str = "bubble_uuid"):
        self.uuid = uuid

    def add_sink(self, uuid_path: str = "sink_uuid"):
        raw f'$data modify storage coc:energy bubbles."$({self.uuid})".sinks append value {{uuid: "$({uuid_path})"}}'
        raw f'$data modify storage coc:energy sinks."$(uuid_path)".bubbles append value {{uuid: "$({self.uuid})"}}'

    def remove_sink(self, uuid_path: str = "sink_uuid"):
        raw f'$data remove storage coc:energy bubbles."$({self.uuid})".sinks[{{uuid: "$(uuid_path)"}}]'
        raw f'$data remove storage coc:energy sinks."$(uuid_path)".bubbles[{{uuid: "$({self.uuid})"}}]'


class Sinks():
    @staticmethod
    def add(uuid: str = "sink_uuid"):
        raw f'$data modify storage coc:energy sinks."$({uuid})" set from storage coc:temp sink'
    
    @staticmethod
    def remove(uuid: str = "sink_uuid"):
        raw f'$data modify storage coc:temp sink set from storage coc:energy sinks."$({uuid})"'
        raw f'$data remove storage coc:energy sinks."$({uuid})"'
        raw f'$data modify storage coc:temp sink_uuid set value "$({uuid})"'

        if data storage coc:temp sink.bubbles[] function ~/iter:
            data modify storage coc:temp bubble_uuid set from storage coc:temp sink.bubbles[-1]
            data remove storage coc:temp sink.bubbles[-1]

            execute function ~/remove with storage coc:temp {}:
                Bubbles("bubble_uuid").remove_sink()

            if data storage coc:temp sink.bubbles[] function ~/


# ----------------------------
# Create/Register Energy Types
# ----------------------------

# Create a new energy network
function ./create_network:
    $data modify storage coc:temp network set { \
        id: $(network_id),                      \
        bubbles: [{uuid: "$(network_uuid)"}]    \
    }                                           \

    Networks.add()

    # Register the network in storage

    data modify storage coc:temp bubble set value {
        transfer: -1,
        radius: 16,
        base_capacity: 100,
        max_capacity: 100,
        capacity: 0,
        x: 0,
        y: 0,
        z: 0,
        sinks: []
    }

    # Get the current execution position and set it to the bubble
    execute summon marker function ~/get_pos:
        data modify storage coc:temp pos set from entity @s Pos

        store result storage coc:temp bubble.x int 1 data get storage coc:temp pos[0]
        store result storage coc:temp bubble.y int 1 data get storage coc:temp pos[1]
        store result storage coc:temp bubble.z int 1 data get storage coc:temp pos[2]

        kill @s

    # Register the bubble in the storage
    Bubbles.add("network_uuid")

# Add a new bubble to a network
function ./create_bubble:
    $data modify storage coc:temp bubble set value { \
        transfer: $(transfer),                       \
        radius: 16,                                  \
        base_capacity: 100,                          \
        max_capacity: 100,                           \
        capacity: 0,                                 \
        x: $(x),                                     \
        y: $(y),                                     \
        z: $(z),                                     \
        sinks: []                                    \
    }

    Bubbles.add()
    Networks("network_uuid").add_bubble("bubble_uuid")

    $data modify storage coc:temp bubble_uuid set value "$(bubble_uuid)"

    # TODO: Update sinks that are within the new bubble
    # raw f"$execute positioned $(x) $(y) $(z) as @e[tag=coc.energy.sink,distance=..16] run function {(./update_bubble)}"




# Add a new sink to a bubble
function ./create_sink:
    data modify storage coc:temp sink set value {  
        capacity: 50,                               
        consumption: 2                              
    }                                               

    Sinks.add()
    Bubbles("bubble_uuid").add_sink()


# ----------------------------
# Destroy Energy Types
# ----------------------------

function ./destroy_sink:
    Sinks.remove()

function ./destroy_bubble:
    Bubbles.remove()

function ./destroy_network:
    Networks.remove()

# ----------------------------
# Utilities
# ----------------------------

# Update the bubble for a given sink
function ./update_bubble:
    function gu:generate

    data modify storage coc:temp sink_uuid set from storage gu:main out

# Calculate the total capacity for a given bubble
function ./calculate_capacity:
    if is_debug():
        $execute unless data storage coc:energy bubbles."$(bubble_uuid)" run \
            return run tellraw @a ["",{"text": "Bubble with id: ", "color": "red"}, {"text": "$(bubble_uuid)"}, {"text": " does not exist!", "color": "red"}]

    $data modify storage coc:temp bubble set from storage coc:energy bubbles."$(bubble_uuid)"
    data modify storage coc:temp sinks set from storage coc:temp bubble.sinks

    store result score #total_capacity coc.dummy data get storage coc:temp bubble.base_capacity

    if data storage coc:temp sinks[] function ~/iter:
        data modify storage coc:temp sink_uuid set from storage coc:temp sinks[-1].uuid

        execute function ~/get_capacity with storage coc:temp {}:
            $execute store result score #c coc.dummy run data get storage coc:energy sinks."$(sink_uuid)".capacity
        
        scoreboard players operation #total_capacity coc.dummy += #c coc.dummy

        data remove storage coc:temp sinks[-1]

        if data storage coc:temp sinks[] function ~/

    $execute store result storage coc:energy bubbles[{uuid: "$(bubble_uuid)"}].max_capacity int 1 run scoreboard players get #total_capacity coc.dummy

# Get the first bubble that the execution context is within
function ./get_bubble:
    data modify storage coc:temp bubbles set value []
    # Fill bubbles with *all* registered bubbles 
    data modify storage coc:temp bubbles set from storage coc:energy bubbles.keys

    data remove storage coc:temp bubble_uuid

    function ~/check_distance:
        # If we are in the cylinder defined by the bubble, radius is variable,
        # height is always +/- 3 blocks
        $execute                                                                    \
            positioned $(x) ~ $(z) if entity @s[distance=..$(radius)]               \
            at @s positioned ~-0.5 $(y) ~-0.5 positioned ~ ~-1 ~ if entity @s[dy=3] \
            run return 1

        return 0

    execute function ~/iter with storage coc:temp bubbles[-1]:

        $data modify storage coc:temp bubble set from storage coc:energy bubbles."$(uuid)"

        store result score #temp coc.dummy function ~/../check_distance with storage coc:temp bubble

        if score #temp coc.dummy matches 1 return:
            data modify storage coc:temp bubble_uuid set from storage coc:temp bubbles[-1].uuid

        data remove storage coc:temp bubbles[-1]
        if data storage coc:temp bubbles[] function ~/ with storage coc:temp bubbles[-1]

    if data storage coc:temp bubble_uuid return 1
    return fail