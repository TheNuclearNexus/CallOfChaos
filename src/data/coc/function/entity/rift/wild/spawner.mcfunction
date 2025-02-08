
loot_table coc:technical/rift/mob_death {
    "pools": [
        {
            "rolls": 1,
            "entries": [
                {
                    "type": "minecraft:item",
                    "name": "minecraft:stone",
                    "functions": [
                        {
                            "function": "minecraft:set_custom_data",
                            "tag": "{coc:{rift_mob:1b}}"
                        }
                    ]
                }
            ]
        }
    ]
}


# Spawn the mob and remove the item_display
function ~/start_spawn:
    execute function ~/spawn with entity @s item.components."minecraft:custom_data".coc:
        $summon $(mob) ~ ~ ~ {Tags: ["coc.rift.spawned", "coc.setup"], DeathLootTable: "coc:technical/rift/mob_death"}

        $scoreboard players operation @n[type=$(mob), tag=coc.setup] coc.rift_id = @s coc.rift_id 
        tag @e remove coc.setup

# This is a conditional tick function, it'll only run when there are spawners still alive
function ~/tick:
    append function_tag coc:load {
        "values": [
            (~/)
        ]
    }

    as @e[type=item_display,tag=coc.rift.wild.spawner] at @s function ~/internal

    if entity @e[type=item_display,tag=coc.rift.wild.spawner,limit=1] schedule function ~/ 1t replace

# This is ran as the display entities
function ~/tick/internal:
    tp @s ~ ~ ~ ~10 ~
    particle minecraft:portal ~ ~ ~ 0.5 0 0.5 0 2
    particle minecraft:portal ~ ~ ~ 0.1 0.5 0.1 0 1

    scoreboard players add @s coc.dummy 1

    if score @s coc.dummy matches 1 data merge entity @s {
        transformation: [1f,0f,0f,0f,0f,0f,-1f,3f,0f,1f,0f,0f,0f,0f,0f,1f],
        interpolation_duration: 120,
        start_interpolation: 1
    }

    if score @s coc.dummy matches 120 function ~/../../start_spawn

    if score @s coc.dummy matches 120 data merge entity @s {
        transformation: [0.001f,0f,0f,0f,0f,0f,-0.001f,3f,0f,0.001f,0f,0f,0f,0f,0f,1f],
        interpolation_duration: 10,
        start_interpolation: 1
    }

    if score @s coc.dummy matches 130.. kill @s


# Set all the data for the display entities
function ~/init:
    data merge entity @s {
        item: {
            id: "minecraft:stone",
            components: {
                "minecraft:item_model": "coc:entity/small_rift"
            },
        },
        transformation: [0.001f,0f,0f,0f,0f,0f,-0.001f,0.01f,0f,0.001f,0f,0f,0f,0f,0f,1f],
        brightness: {
            block: 15,
            sky: 15
        },
        teleport_duration: 2,
        Tags: ["coc.entity", "coc.rift.wild.spawner", "coc.rift.spawned"]
    }

    
    scoreboard players operation @s coc.rift_id = #id coc.dummy

    data modify entity @s item.components."minecraft:custom_data".coc.mob set from storage coc:temp mob

    # Start the ticking function if it hasn't already been started
    schedule function ~/../tick 1t replace

execute summon item_display function ~/init