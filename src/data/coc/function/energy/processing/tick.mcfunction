

predicate coc:technical/chance/10 {
    "condition": "minecraft:random_chance",
    "chance": 0.1
}


BASE_PRODUCTION = 32

set_const(0)

function ~/networks:

    scoreboard players reset * coc.powered
    
    unless data storage coc:energy networks.keys[]:
        return 0
    
    
    data modify storage coc:temp networks set from storage coc:energy networks.keys

    # for cur_network in networks
    execute function ~/iter with storage coc:temp networks[-1]:
        data modify storage coc:temp network set from storage coc:energy networks.$(uuid)
        data remove storage coc:temp networks[-1]

        store result score #fuel_duration coc.dummy data get storage coc:temp network.fuel.duration

        # If there is fuel burning, use it's production stat
        if score #fuel_duration coc.dummy matches 1.. function ~/../handle_fuel:
            store result score #remaining_production coc.dummy:
                data get storage coc:temp network.fuel.production  

            store result storage coc:temp network.fuel.duration int 1:
                scoreboard players remove #fuel_duration coc.dummy 1

        # Otherwise use the base rift production stat
        unless score #fuel_duration coc.dummy matches 1..:
            scoreboard players set #remaining_production coc.dummy BASE_PRODUCTION

        # Iterate through all bubbles
        if data storage coc:temp network.bubbles[]:
            function ~/../../bubbles

        if data storage coc:temp networks[]:
            function ~/ with storage coc:temp networks[-1]

function ~/bubbles:
    data modify storage coc:temp bubbles set from storage coc:temp network.bubbles

    # for cur_network in networks
    execute function ~/iter with storage coc:temp bubbles[-1]:
        data modify storage coc:temp bubble set from storage coc:energy bubbles.$(uuid)
        data remove storage coc:temp bubbles[-1]

        store result score #max_capacity coc.dummy:
            data get storage coc:temp bubble.max_capacity

        store result score #capacity coc.dummy:
            data get storage coc:temp bubble.capacity

        store result score #transfer coc.dummy:
            data get storage coc:temp bubble.transfer

        execute function ~/transfer_energy:
            if score #remaining_production coc.dummy matches ..0:
                return 0
            if score #capacity coc.dummy >= #max_capacity coc.dummy:
                return 1

            # transfer == -1 is reserved for the rift and makes sure that the rift receives all the scraps
            if score #transfer coc.dummy matches -1:
                return run function ~/steal_all:
                    scoreboard players operation #capacity coc.dummy += #remaining_production coc.dummy
                    scoreboard players set #remaining_production coc.dummy 0

            # If transfer <= remaining_production, apply only our transfer stat
            if score #transfer coc.dummy <= #remaining_production coc.dummy:
                return run function ~/apply_transfer:
                    scoreboard players operation #capacity coc.dummy += #transfer coc.dummy
                    scoreboard players operation #remaining_production coc.dummy -= #transfer coc.dummy

            # If transfer > remaining_production, take all thats left in the pool
            function ~/steal_all 

        scoreboard players operation #capacity coc.dummy < #max_capacity coc.dummy


        # handle sinks
        if data storage coc:temp bubble.sinks[]:
            function ~/../../sinks with storage coc:temp bubble

        store result storage coc:energy bubbles.$(uuid).capacity int 1:
            scoreboard players get #capacity coc.dummy

        
        if data storage coc:temp bubbles[]:
            function ~/ with storage coc:temp bubbles[-1]


function ~/sinks:
    execute store success score #loaded coc.dummy if loaded $(x) $(y) $(z)

    # store result score #len coc.dummy 
    data modify storage coc:temp sinks set from storage coc:temp bubble.sinks

    # for cur_sink in sinks
    execute function ~/iter with storage coc:temp sinks[-1]:
        data modify storage coc:temp sink set from storage coc:energy sinks.$(uuid)
        data remove storage coc:temp sinks[-1]

        # if predicate coc:technical/chance/10 unless data storage coc:temp sink.scrambled return run function ~/scramble with storage coc:temp {}:
        #     data modify storage coc:temp sink.scrambled set value 1b

        #     $execute store result storage coc:temp j int 1 run random value 0..$(i)

        #     execute function ~/../swap with storage coc:temp {}:
        #         $data modify storage coc:temp cur_bubble.sinks[$(i)] set from storage coc:temp cur_bubble.sinks[$(j)]
        #         $data modify storage coc:temp cur_bubble.sinks[$(j)] set from storage coc:temp cur_sink

        #     function ~/../ with storage coc:temp {}

        store result score #consumption coc.dummy data get storage coc:temp sink.consumption

        if score #capacity coc.dummy < #consumption coc.dummy:
            return 0

        scoreboard players operation #capacity coc.dummy -= #consumption coc.dummy

        # log_score("#capacity", "coc.dummy")
        $scoreboard players set $(uuid) coc.powered 1

        if data storage coc:temp sinks[] function ~/ with storage coc:temp sinks[-1]

    store result storage coc:temp bubble.capacity int 1 scoreboard players operation #capacity coc.dummy > #0 coc.const

execute function ~/networks