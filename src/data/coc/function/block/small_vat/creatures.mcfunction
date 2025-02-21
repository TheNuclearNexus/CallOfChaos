from nbtlib import IntArray
# -------------------------------
# System Constants
# -------------------------------
STAGE_DURATION = 300
ACTIVE_TAG = "coc.has_creature"
TEXT_DISPLAY_UUID = "e09fa29a-0d1c-0b98-0d27-45aee6a5e4d8"
TEXT_DISPLAY_UUID_ARRAY = IntArray([-526409062,219941784,220677550,-425335592])

# -------------------------------
# Score Constants
# -------------------------------


# -------------------------------
# Common Implementation Utilities
# -------------------------------
CUSTOM_DATA = 'components."minecraft:custom_data"'
CREATURE_DATA = f'{CUSTOM_DATA}.coc.creature'

function ./reset:
    on passengers kill @s
    scoreboard players set @s coc.dummy 0

    data remove entity @s f"item.{CREATURE_DATA}"
    tag @s remove ACTIVE_TAG

function ./insert_seed:
    unless data storage coc:temp f"item.{CREATURE_DATA}" return 0
    data modify storage coc:temp creature set from storage coc:temp f"item.{CREATURE_DATA}"

    at @s function ~/create_creature with storage coc:temp creature:
        summon item_display ~ ~ ~ {
            item: {
                id: "minecraft:stone",
                components: {
                    "minecraft:item_model": $(seed: string)
                }
            },
            Tags: ["coc.creature"],
            transformation: {
                translation: [0.0, 0.5, 0.0],
                left_rotation: [0,0,0,1],
                right_rotation: [0,0,0,1],
                scale: [1, 1, 1]
            },
            teleport_duration: 5,
            item_display: "ground"
        }

        as @n[type=minecraft:item_display, tag=coc.creature] function ./animate/up

        data modify entity @n[type=item_display, tag=coc.creature] brightness set from entity @s brightness

        ride @n[type=item_display, tag=coc.creature] mount @s

    tag @s add ACTIVE_TAG

    data modify entity @s f'item.{CREATURE_DATA}' set from storage coc:temp f'item.{CREATURE_DATA}'
    data modify entity @s f'item.{CREATURE_DATA}.seed' set from storage coc:temp item
    playsound minecraft:entity.generic.splash block @a ~ ~ ~ 1 2

function ./remove_contents:
    data modify storage coc:temp creature set from entity @s f'item.{CREATURE_DATA}'

    store result score #stage coc.dummy data get storage coc:temp creature.stage

    if score #stage coc.dummy matches 0 return run function ~/drop_seed:
        if entity @p[gamemode=creative] return run function ./reset

        summon item ~ ~ ~ {Tags:["coc.temp"], Item: {id: "minecraft:stone", count: 1}, PickupDelay: 1s}

        as @n[type=item, tag=coc.temp] function ~/../copy_seed:
            data modify entity @s Item.id set from storage coc:temp creature.seed.id
            data modify entity @s Item.components set from storage coc:temp creature.seed.components
            tag @s remove coc.temp

        function ./reset

    if data storage coc:temp f'item.{CUSTOM_DATA}.smithed{{id: "coc:gauntlet"}}':
        unless data storage coc:temp f'item.{CUSTOM_DATA}.coc.held_creature' function ~/take_creature:
            data modify storage coc:temp held_creature set value {id: "", stage: 0}
            data modify storage coc:temp held_creature.id set from storage coc:temp creature.id


            data modify storage coc:temp info.name set from storage coc:temp creature.name
            data modify storage coc:temp info.stage set from storage coc:temp creature.stage

            # summon text_display ~ ~512 ~ {UUID: TEXT_DISPLAY_UUID_ARRAY, text: ""} 
            
            # as TEXT_DISPLAY_UUID function ~/resolve_lore:
            #     data modify entity @s text set value '{"nbt": "info.name", "storage": "coc:temp", "interpret": true}'
            #     data modify storage coc:temp info.name set from entity @s text

            #     data modify entity @s text set value '{"nbt": "info.stage", "storage": "coc:temp", "interpret": true}'
            #     data modify storage coc:temp info.stage set from entity @s text

            #     kill @s



            store result storage coc:temp held_creature.stage int 1:
                scoreboard players get #stage coc.dummy

            item modify entity @p weapon.mainhand {
                "function": "minecraft:copy_custom_data",
                "source": {
                    "type": "minecraft:storage",
                    "source": "coc:temp"
                },
                "ops": [
                    {
                        "source": "held_creature",
                        "target": "coc.held_creature",
                        "op": "replace"
                    }
                ]
            }

            execute function ~/set_lore with storage coc:temp info:
                item modify entity @p weapon.mainhand {
                    "function": "minecraft:set_lore",
                    "lore": [
                        {
                            "translate": "text.coc.gauntlet.creature_name",
                            "with": [
                            {
                                "translate": $(name: string),
                                "color": "white"
                            }
                            ],
                            "color": "gray",
                            "italic": false
                        },
                        {
                            "translate": "text.coc.gauntlet.creature_stage",
                            "with": [
                            {
                                "translate": $(stage: string),
                                "color": "white"
                            }
                            ],
                            "color": "gray",
                            "italic": false
                        }
                    ],
                    "mode": "insert",
                    "offset": 0
                }

            function ./reset