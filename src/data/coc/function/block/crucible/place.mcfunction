# called by the item generator
setblock ~ ~ ~ hopper[enabled=false,facing=north]{
    TransferCooldown: (pow(2, 31) - 1),
    lock: {components:{custom_data:{impossible:"impossible"}}},
    components: {
        "minecraft:custom_data": {
            smithed: {
                id: "coc:crucible",
            },
            coc: {
                silent: 1
            }
        }
    }
}

function gu:generate
data modify block ~ ~ ~ components."minecraft:custom_data".coc.uuid set from storage gu:main out

data merge entity @s {
    item: {
        components: {
            "minecraft:custom_data": {
                coc: {
                    energy: {
                        capacity: 25,
                        consumption: 2
                    }
                }
            }
        }
    },
    Tags: ["coc.block", "coc.crucible", "coc.energy.sink", *SMITHED_BLOCK],
}

summon item_display ~ ~ ~ {
    transformation: {
        translation: [0.0,0.0,(9/16)],
        scale: [0.5,0.5,0.5],
        left_rotation: [0,0,0,1],
        right_rotation: [0,0,0,1]
    },
    Tags: ["coc.crucible.item"]
}

ride @n[tag=coc.crucible.item, distance=..0.25] mount @s  

on passengers rotate @s ~ ~

# summon interaction ^ ^-.275 ^.26 {
#     height: 0.45,
#     width: 0.5,
#     Tags: ["coc.crucible.interaction"]
# }


at @s if function coc:energy/api/block_entity/register_sink:
    data modify entity @s item.components."minecraft:custom_model_data" set value {
        floats: [1]
    }
