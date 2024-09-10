
# Spawn the mob and remove the item_display
function ~/start_spawn:
    execute function ~/spawn with entity @s item.components."minecraft:custom_data".coc:
        $summon $(mob) ~ ~ ~ {Tags: ["coc.rift.spawned"], DeathLootTable: "coc:technical/empty"}
    kill @s

# Spawns the mob at the correct item displays
function ~/schedule:
    store result score #gametime coc.dummy time query gametime
    as @e[type=item_display,tag=coc.rift.wild.spawner]:
        if score @s coc.dummy = #gametime coc.dummy at @s function ~/../start_spawn

# This is a conditional tick function, it'll only run when there are spawners still alive
function ~/tick:
    as @e[type=item_display,tag=coc.rift.wild.spawner] at @s function ~/internal
    if entity @e[type=item_display,tag=coc.rift.wild.spawner] schedule function ~/ 1t replace

# This is ran as the display entities
function ~/tick/internal:
    tp @s ~ ~ ~ ~2 ~

    data merge entity @s[tag=!coc.animating] {
        transformation: [1f,0f,0f,0f,0f,0f,-1f,0.01f,0f,1f,0f,0f,0f,0f,0f,1f],
        interpolation_duration: 120,
        start_interpolation: 1
    }
    tag @s add coc.animating

# Set all the data for the display entities
function ~/init:
    data merge entity @s {
        item: {
            id: "minecraft:stone",
            components: {
                "minecraft:item_model": "coc:technical/small_rift"
            },
        },
        transformation: [0.001f,0f,0f,0f,0f,0f,-0.001f,0.01f,0f,0.001f,0f,0f,0f,0f,0f,1f],
        brightness: {
            block: 15,
            sky: 15
        },
        teleport_duration: 2,
        Tags: ["coc.entity", "coc.rift.wild.spawner"]
    }

    

    data modify entity @s item.components."minecraft:custom_data".coc.mob set from storage coc:temp mob

    store result score @s coc.dummy schedule function ~/../schedule 6s append

    # Start the ticking function if it hasn't already been started
    schedule function ~/../tick 1t replace

execute summon item_display function ~/init