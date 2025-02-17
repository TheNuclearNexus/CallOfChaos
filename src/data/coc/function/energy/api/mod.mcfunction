

class Networks():
    @staticmethod
    def add():
        data modify storage coc:energy networks.keys append value {uuid: $(network_uuid: string)}
        data modify storage coc:energy networks.$(network_uuid) set from storage coc:temp network
    
    @staticmethod
    def remove():
        data remove storage coc:energy networks.keys[{ uuid: $(network_uuid: string)}]
        data modify storage coc:temp network set from storage coc:energy networks.$(network_uuid)
        data remove storage coc:energy networks.$(network_uuid)
        data modify storage coc:temp network_uuid set value $(network_uuid: string)

        if data storage coc:temp network.bubbles[] function ~/iter:
            data modify storage coc:temp bubble_uuid set from storage coc:temp network.bubbles[-1].uuid
            data remove storage coc:temp network.bubbles[-1]

            execute function ~/remove with storage coc:temp {}:
                Bubbles().remove_network()

            if data storage coc:temp network.bubbles[] function ~/

        function ./destroy_bubble  { bubble_uuid: $(network_uuid: string) } 

    def add_bubble(self):
        data modify storage coc:energy networks.$(network_uuid).bubbles append value {uuid: $(bubble_uuid: string)}
        data modify storage coc:energy bubbles.$(bubble_uuid).networks append value {uuid: $(network_uuid: string)}

    def remove_bubble(self):
        data remove storage coc:energy networks.$(network_uuid).bubbles[{uuid: $(bubble_uuid: string)}]
        data remove storage coc:energy bubbles.$(bubble_uuid).networks[{uuid: $(network_uuid: string)}]

class Bubbles():
    @staticmethod
    def add():
        data modify storage coc:energy bubbles.keys append value {uuid: $(bubble_uuid: string)}
        data modify storage coc:energy bubbles.$(bubble_uuid) set from storage coc:temp bubble
    
    @staticmethod
    def remove():
        data remove storage coc:energy bubbles.keys[{ uuid: $(bubble_uuid: string) }]
        data modify storage coc:temp bubble set from storage coc:energy bubbles.$(bubble_uuid)
        data remove storage coc:energy bubbles.$(bubble_uuid)
        data modify storage coc:temp bubble_uuid set value $(bubble_uuid: string)

        if data storage coc:temp bubble.networks[] function ~/iter_network:
            data modify storage coc:temp network_uuid set from storage coc:temp bubble.networks[-1].uuid
            data remove storage coc:temp bubble.networks[-1]

            execute function ~/remove with storage coc:temp {}:
                Networks().remove_bubble()

            if data storage coc:temp bubble.networks[] function ~/

        if data storage coc:temp bubble.sinks[] function ~/iter_sink:
            data modify storage coc:temp sink_uuid set from storage coc:temp bubble.sinks[-1].uuid
            data remove storage coc:temp bubble.sinks[-1]

            execute function ~/remove with storage coc:temp {}:
                Sinks().remove_bubble()

            if data storage coc:temp bubble.sinks[] function ~/


    def add_sink(self):
        data modify storage coc:energy bubbles.$(bubble_uuid).sinks append value {uuid: $(sink_uuid: string)}
        data modify storage coc:energy sinks.$(sink_uuid).bubbles append value {uuid: $(bubble_uuid: string)}

    def remove_sink(self):
        data remove storage coc:energy bubbles.$(bubble_uuid).sinks[{uuid: $(sink_uuid: string)}]
        data remove storage coc:energy sinks.$(sink_uuid).bubbles[{uuid: $(bubble_uuid: string)}]

    def add_network(self):
        data modify storage coc:energy bubbles.$(bubble_uuid).networks append value {uuid: $(network_uuid: string)}
        data modify storage coc:energy networks.$(network_uuid).bubbles append value {uuid: $(bubble_uuid: string)}

    def remove_network(self):
        data remove storage coc:energy bubbles.$(bubble_uuid).networks[{uuid: $(network_uuid: string)}]
        data remove storage coc:energy networks.$(network_uuid).bubbles[{uuid: $(bubble_uuid: string)}]



class Sinks():
    @staticmethod
    def add():
        data modify storage coc:energy sinks.$(sink_uuid) set from storage coc:temp sink
    
    @staticmethod
    def remove():
        data modify storage coc:temp sink set from storage coc:energy sinks.$(sink_uuid)
        data remove storage coc:energy sinks.$(sink_uuid)
        data modify storage coc:temp sink_uuid set value $(sink_uuid)

        if data storage coc:temp sink.bubbles[] function ~/iter:
            data modify storage coc:temp bubble_uuid set from storage coc:temp sink.bubbles[-1].uuid
            data remove storage coc:temp sink.bubbles[-1]

            execute function ~/remove with storage coc:temp {}:
                Bubbles().remove_sink()

            if data storage coc:temp sink.bubbles[] function ~/

    def remove_bubble(self):
        data remove storage coc:energy sinks.$(sink_uuid).bubbles[{ uuid: $(bubble_uuid: string) }]

# ----------------------------
# Create/Register Energy Types
# ----------------------------

# Create a new energy network
function ./create_network:
    data modify storage coc:temp network set value {
        id: $(network_id),                           
        bubbles: []                                  
    }                                                

    Networks.add()

    # Register the network in storage

    data modify storage coc:temp bubble set value { 
        network_uuid: $(network_uuid: string),               
        bubble_uuid: $(network_uuid: string),                
        transfer: -1,                                
        x: 0,                                        
        y: 0,                                        
        z: 0                                         
    }                                                

    # Get the current execution position and set it to the bubble
    execute summon marker function ~/get_pos:
        data modify storage coc:temp pos set from entity @s Pos

        store result storage coc:temp bubble.x int 1 data get storage coc:temp pos[0]
        store result storage coc:temp bubble.y int 1 data get storage coc:temp pos[1]
        store result storage coc:temp bubble.z int 1 data get storage coc:temp pos[2]

        kill @s


    # Register the bubble in the storage
    function ./create_bubble with storage coc:temp bubble    

    return 1

# Add a new bubble to a network
function ./create_bubble:
    data modify storage coc:temp bubble set value {
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

    Bubbles.add()
    Networks().add_bubble()

    data modify storage coc:temp bubble_uuid set value $(bubble_uuid: string)

    # TODO: Update sinks that are within the new bubble
    # raw f"$execute positioned $(x) $(y) $(z) as @e[tag=coc.energy.sink,distance=..16] run function {(./update_bubble)}"
    return 1


# Add a new sink to a bubble
function ./create_sink:
    data modify storage coc:temp sink set value {  
        capacity: 50,                               
        consumption: 2                              
    }                                               

    Sinks.add()
    Bubbles().add_sink()

    return 1
# ----------------------------
# Destroy Energy Types
# ----------------------------

function ./destroy_sink:
    Sinks.remove()
    return 1

function ./destroy_bubble:
    Bubbles.remove()
    return 1

function ./destroy_network:
    Networks.remove()
    return 1

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

    data modify storage coc:temp bubble set from storage coc:energy bubbles.$(bubble_uuid)
    data modify storage coc:temp sinks set from storage coc:temp bubble.sinks

    store result score #total_capacity coc.dummy data get storage coc:temp bubble.base_capacity

    if data storage coc:temp sinks[] function ~/iter with storage coc:temp sinks[-1]:
        store result score #c coc.dummy data get storage coc:energy sinks.$(uuid).capacity
        scoreboard players operation #total_capacity coc.dummy += #c coc.dummy
        data remove storage coc:temp sinks[-1]

        if data storage coc:temp sinks[] function ~/ with storage coc:temp sinks[-1]

    store result storage coc:energy bubbles.$(bubble_uuid).max_capacity int 1 scoreboard players get #total_capacity coc.dummy

# Get the first bubble that the execution context is within
function ./get_bubble:
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

    execute function ~/iter with storage coc:temp bubbles[-1]:

        data modify storage coc:temp bubble set from storage coc:energy bubbles.$(uuid)

        store result score #temp coc.dummy function ~/../check_distance with storage coc:temp bubble

        if score #temp coc.dummy matches 1 return:
            data modify storage coc:temp bubble_uuid set from storage coc:temp bubbles[-1].uuid

        data remove storage coc:temp bubbles[-1]
        if data storage coc:temp bubbles[] function ~/ with storage coc:temp bubbles[-1]

    if data storage coc:temp bubble_uuid return 1
    return fail
