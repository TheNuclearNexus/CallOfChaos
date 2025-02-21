from ./creatures import ACTIVE_TAG, CREATURE_DATA, CUSTOM_DATA

ADVANCEMENT_PATH = coc:technical/default_block_use/small_vat 

advancement ADVANCEMENT_PATH {
    "criteria": {
        "requirement": {
            "trigger": "minecraft:default_block_use",
            "conditions": {
                "location": [
                    {
                        "condition": "minecraft:location_check",
                        "predicate": {
                            "block": {
                                "nbt": "{components:{\"minecraft:custom_data\":{smithed:{id: \"coc:small_vat\"}}}}"
                            }
                        }
                    }
                ]
            }
        }
    },
    "rewards": {
        "function": (~/)
    }
}

advancement revoke @s only ADVANCEMENT_PATH


data modify storage coc:temp item set from entity @s SelectedItem

store result storage coc:temp block_interaction_range double 1 attribute @s minecraft:block_interaction_range get 
anchored eyes positioned ^ ^ ^0.1 function ~/find_block with storage coc:temp {}


function ~/find_block:
    if data block ~ ~ ~ f'{CUSTOM_DATA}.smithed{{id: "coc:small_vat"}}':
        return run function ~/../get_entity with block ~ ~ ~ f"{CUSTOM_DATA}.coc":
            at @s as $(uuid) run function ~/../as_entity

    positioned ^ ^ ^0.1 if entity @s[distance=..$(block_interaction_range)]:
        function ~/ with storage coc:temp {}


function ~/as_entity:
    if entity @s[tag=ACTIVE_TAG] return:
        function ./remove_contents

    function ./insert_seed