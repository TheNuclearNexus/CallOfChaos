from nbtlib import IntArray

from coc:energy/api/sink import SINK_DATA

# -------------------------------
# System Constants
# -------------------------------
STAGE_DURATION = 300
ACTIVE_TAG = "coc.has_creature"
LIQUID_TAG = "coc.has_liquid"

TEXT_DISPLAY_UUID = "e09fa29a-0d1c-0b98-0d27-45aee6a5e4d8"
TEXT_DISPLAY_UUID_ARRAY = IntArray([-526409062,219941784,220677550,-425335592])

IDLE_CONSUMPTION = 5
ACTIVE_CONSUMPTION = 10

# -------------------------------
# Score Constants
# -------------------------------


# -------------------------------
# Common Implementation Utilities
# -------------------------------
CUSTOM_DATA = 'components."minecraft:custom_data"'
CREATURE_DATA = f'{CUSTOM_DATA}.coc.creature'

def change_model(state: str, offset: int = 0):
    item modify entity @s contents {
        "function": "minecraft:set_custom_model_data",
        "strings": {
            "values": [
                state
            ],
            "mode": "replace_section",
            "offset": offset,
            "size": 1
        }
    }

function ./reset:
    on passengers kill @s
    scoreboard players set @s coc.dummy 0

    data remove entity @s f"item.{CREATURE_DATA}"
    tag @s remove ACTIVE_TAG

    change_model("off")

    data modify entity @s f"item.{SINK_DATA}.consumption" set value IDLE_CONSUMPTION
    function coc:energy/api/sink/sync_storage with entity @s f"item.{SINK_DATA}"

function ./activate:
    tag @s add ACTIVE_TAG

    data modify entity @s f"item.{SINK_DATA}.consumption" set value ACTIVE_CONSUMPTION
    function coc:energy/api/sink/sync_storage with entity @s f"item.{SINK_DATA}"

    if score @s coc.powered matches 1:
        change_model("on")

function ./fill_vat:
    unless data storage coc:temp f'item.{CUSTOM_DATA}.smithed{{id: "coc:life_bucket"}}' return 0

    as @p item replace entity @s[gamemode=!creative] weapon.mainhand with bucket

    tag @s add LIQUID_TAG
    change_model("filled", 0)
    playsound minecraft:item.bucket.empty block @a

function ./insert_seed:
    say ran
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
            item_display: "ground",
            brightness: {sky: 15, block: 15}
        }

        as @n[type=minecraft:item_display, tag=coc.creature] function ./animate/up

        ride @n[type=item_display, tag=coc.creature] mount @s

    data modify entity @s f'item.{CREATURE_DATA}' set from storage coc:temp f'item.{CREATURE_DATA}'
    data modify entity @s f'item.{CREATURE_DATA}.seed' set from storage coc:temp item
    playsound minecraft:entity.generic.splash block @a ~ ~ ~ 1 2

    as @p item modify entity @s[gamemode=!creative] weapon.mainhand {
        "function": "minecraft:set_count",
        "count": -1,
        "add": True
    }

    function ./activate

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

    