
ADVANCEMENT_PATH = coc:technical/default_block_use/crucible 
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
                                "nbt": "{components:{\"minecraft:custom_data\":{smithed:{id: \"coc:crucible\"}}}}"
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

store result storage coc:temp block_interaction_range double 1 attribute @s minecraft:block_interaction_range get 
anchored eyes positioned ^ ^ ^0.1 function ~/find_block with storage coc:temp {}

function ~/find_block:
    if data block ~ ~ ~ components."minecraft:custom_data".smithed{id: "coc:crucible"}:
        return run function ~/../get_entity with block ~ ~ ~ components."minecraft:custom_data".coc:
            raw f"$execute at @s as $(uuid) run function {(~/../as_entity)}"


    raw f"$execute positioned ^ ^ ^0.1 if entity @s[distance=..$(block_interaction_range)] run function {(~/)} with storage coc:temp {{}}"


function ~/as_entity:
    say clicked
