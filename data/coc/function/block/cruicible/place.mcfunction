# called by the item generator
setblock ~ ~ ~ hopper{
    TransferCooldown: (pow(2, 31) - 1),
    lock: {components:{custom_data:{impossible:"impossible"}}},
    components: {
        "minecraft:custom_data": {
            smithed: {
                id: "coc:cruicble",
            },
            coc: {
                silent: 1
            }
        }
    }
}

summon item_display ~ ~ ~ {
    item: {
        id: "minecraft:hopper",
        components: {
            "minecraft:item_model": "coc:block/cruicible",
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
    Tags: ["coc.block", "coc.cruicible", "coc.energy.sink", *SMITHED_BLOCK],
    transformation: {
        translation: [0,0,0],
        scale: [1.002, 1.002, 1.002],
        left_rotation: [0,0,0,1],
        right_rotation: [0,0,0,1]
    }
}

as @n[tag=coc.cruicible] function ~/setup:
    if function coc:energy/api/block/register_sink:
        data modify entity @s item.components."minecraft:custom_model_data" set value {
            floats: [1]
        }
