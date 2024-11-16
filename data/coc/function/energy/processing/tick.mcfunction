
BASE_PRODUCTION = 10

function ~/networks:
    unless data storage coc:energy networks[] return 0

    data modify storage coc:temp networks set from storage coc:energy networks
    data modify storage coc:energy networks set value []


    # for cur_network in networks
    execute function ~/iter:
        data modify storage coc:temp cur_network set from storage coc:temp networks[-1]
        data remove storage coc:temp networks[-1]

        store result score #fuel_duration coc.dummy data get storage coc:temp cur_network.fuel.duration

        # If there is fuel burning, use it's production stat
        if score #fuel_duration coc.dummy matches 1.. function ~/../handle_fuel:
            store result score #remaining_production coc.dummy data get storage coc:temp cur_network.fuel.production  
            store result storage coc:temp cur_network.fuel.duration int 1 scoreboard players remove #fuel_duration coc.dummy 1
        # Otherwise use the base rift production stat
        unless score #fuel_duration coc.dummy matches 1.. scoreboard players set #remaining_production coc.dummy BASE_PRODUCTION

        # Iterate through all bubbles
        function ~/../../bubbles


        data modify storage coc:energy networks prepend from storage coc:temp cur_network
        if data storage coc:temp networks[] function ~/

function ~/bubbles:
    data modify storage coc:temp bubbles set from storage coc:temp cur_network.bubbles
    data modify storage coc:temp cur_network.bubbles set value []


    # for cur_network in networks
    execute function ~/iter:
        data modify storage coc:temp cur_bubble set from storage coc:temp bubbles[-1]
        data remove storage coc:temp bubbles[-1]

        store result score #max_capacity coc.dummy data get storage coc:temp cur_bubble.max_capacity
        store result score #capacity coc.dummy data get storage coc:temp cur_bubble.capacity
        store result score #transfer coc.dummy data get storage coc:temp cur_bubble.transfer

        execute function ~/transfer_energy:
            if score #remaining_production coc.dummy matches ..0 return 0
            if score #capacity coc.dummy >= #max_capacity coc.dummy return 1

            # transfer == -1 is reserved for the rift and makes sure that the rift receives all the scraps
            if score #transfer coc.dummy matches -1 return run function ~/steal_all:
                scoreboard players operation #capacity coc.dummy += #remaining_production coc.dummy  
                scoreboard players set #remaining_production coc.dummy 0

            # If transfer <= remaining_production, apply only our transfer stat
            if score #transfer coc.dummy <= #remaining_production coc.dummy return run function ~/apply_transfer:
                scoreboard players operation #capacity coc.dummy += #transfer coc.dummy
                scoreboard players operation #remaining_production coc.dummy -= #transfer coc.dummy

            # If transfer > remaining_production, take all thats left in the pool
            function ~/steal_all 

        scoreboard players operation #capacity coc.dummy < #max_capacity coc.dummy

        # handle sinks

        store result storage coc:temp cur_bubble.capacity int 1 scoreboard players get #capacity coc.dummy

        data modify storage coc:temp cur_network.bubbles prepend from storage coc:temp cur_bubble
        if data storage coc:temp bubbles[] function ~/

execute function ~/networks