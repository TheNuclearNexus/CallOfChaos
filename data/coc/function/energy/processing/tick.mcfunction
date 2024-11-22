from bolt_expressions import Data, Scoreboard

predicate coc:technical/chance/10 {
    "condition": "minecraft:random_chance",
    "chance": 0.1
}


BASE_PRODUCTION = 32

ENERGY_STORAGE = Data.storage(coc:energy)
TEMP_STORAGE = Data.storage(coc:temp)
DUMMY_SCORE = Scoreboard("coc.dummy")

current_network = TEMP_STORAGE.cur_network

bubbles = TEMP_STORAGE.bubbles
current_bubble = TEMP_STORAGE.cur_bubble 

fuel_duration = DUMMY_SCORE["#fuel_duration"]

remaining_production = DUMMY_SCORE["#remaining_production"]
capacity = DUMMY_SCORE["#capacity"]
max_capacity = DUMMY_SCORE["#max_capacity"]
transfer = DUMMY_SCORE["#transfer"]

set_const(0)

function ~/networks:

    if not ENERGY_STORAGE.networks[]:
        return 0
    
    TEMP_STORAGE.networks = ENERGY_STORAGE.networks
    ENERGY_STORAGE.networks = []

    # for cur_network in networks
    execute function ~/iter:
        current_network = TEMP_STORAGE.networks[-1]
        TEMP_STORAGE.networks.remove(-1)

        fuel_duration = current_network.fuel.duration

        # If there is fuel burning, use it's production stat
        if score var fuel_duration matches 1.. function ~/../handle_fuel:
            remaining_production = current_network.fuel.production  
            current_network.fuel.duration = fuel_duration - 1

        # Otherwise use the base rift production stat
        unless score var fuel_duration matches 1..:
            remaining_production = BASE_PRODUCTION

        # Iterate through all bubbles
        if current_network.bubbles[]:
            function ~/../../bubbles


        ENERGY_STORAGE.networks.prepend(current_network)
        if TEMP_STORAGE.networks[]:
            function ~/

function ~/bubbles:
    bubbles = current_network.bubbles

    current_network.bubbles = []


    # for cur_network in networks
    execute function ~/iter:
        current_bubble = bubbles[-1]
        bubbles.remove(-1)

        max_capacity = current_bubble.max_capacity
        capacity = current_bubble.capacity
        transfer = current_bubble.transfer

        execute function ~/transfer_energy:
            if remaining_production <= 0:
                return 0
            if capacity > max_capacity:
                return 1

            # transfer == -1 is reserved for the rift and makes sure that the rift receives all the scraps
            if transfer == -1:
                return run function ~/steal_all:
                    capacity += remaining_production
                    remaining_production = 0

            # If transfer <= remaining_production, apply only our transfer stat
            if transfer <= remaining_production:
                return run function ~/apply_transfer:
                    capacity += transfer
                    remaining_production -= transfer

            # If transfer > remaining_production, take all thats left in the pool
            function ~/steal_all 

        capacity = min(capacity, max_capacity) 



        # handle sinks
        if current_bubble.sinks[]:
            function ~/../../sinks with storage coc:temp cur_bubble

        current_bubble.capacity = capacity

        current_network.bubbles.prepend(current_bubble)
        if bubbles[]:
            function ~/


function ~/sinks:
    $execute store success score #loaded coc.dummy if loaded $(x) $(y) $(z)

    store result score #i coc.dummy if data storage coc:temp cur_bubble.sinks[]

    store result storage coc:temp i int 1 scoreboard players remove #i coc.dummy 1
    store result storage coc:temp len int 1 scoreboard players get #i coc.dummy


    # for cur_sink in sinks
    execute function ~/iter with storage coc:temp {}:
        $data modify storage coc:temp cur_sink set from storage coc:temp cur_bubble.sinks[$(i)]
        # data remove storage coc:temp sinks[-1]

        if predicate coc:technical/chance/10 unless data storage coc:temp cur_sink.scrambled return run function ~/scramble with storage coc:temp {}:
            data modify storage coc:temp cur_sink.scrambled set value 1b

            $execute store result storage coc:temp j int 1 run random value 0..$(i)

            execute function ~/../swap with storage coc:temp {}:
                $data modify storage coc:temp cur_bubble.sinks[$(i)] set from storage coc:temp cur_bubble.sinks[$(j)]
                $data modify storage coc:temp cur_bubble.sinks[$(j)] set from storage coc:temp cur_sink

            function ~/../ with storage coc:temp {}

        store result score #consumption coc.dummy data get storage coc:temp cur_sink.consumption
        scoreboard players operation #capacity coc.dummy -= #consumption coc.dummy

        # log_score("#capacity", "coc.dummy")
        #execute if score #loaded coc.dummy matches 1 function ~/tick with storage coc:temp cur_sink:
        #    $execute as $(uuid) at @s run say hi

        store result storage coc:temp i int 1 scoreboard players remove #i coc.dummy 1
        if score #i coc.dummy matches 0.. function ~/ with storage coc:temp {}

    store result storage coc:temp cur_bubble.capacity int 1 scoreboard players operation #capacity coc.dummy > #0 coc.const
    data remove storage coc:temp cur_bubble.sinks[].scrambled


execute function ~/networks