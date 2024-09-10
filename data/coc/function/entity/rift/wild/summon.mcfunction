summon interaction ~ ~ ~ {
    Tags: ["coc.rift.interaction", "coc.lower", *SMITHED_STRICT],
    height: 1,
    width: 0.75,

    Passengers: [
        {
            id: "minecraft:item_display",
            item: {
                id: "minecraft:stone",
                components: {
                    "minecraft:item_model": "coc:technical/rift"
                }
            },
            Tags: ["coc.rift.wild", "coc.entity", "coc.rift", *SMITHED_STRICT],
            billboard: "center",
            brightness: {block: 15, sky: 15}
        },
        {
            id: "minecraft:interaction",
            Tags:["coc.rift.interaction", "coc.upper", *SMITHED_STRICT],
            height: 1,
            width: 0.75
        }
    ]
}

as @n[tag=coc.rift.wild] function ./directors/wave/init