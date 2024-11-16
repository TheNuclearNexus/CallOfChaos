RIFT_HEIGHT = 4.5

def create_rift(tags: list[str]):
    summon interaction ~ ~ ~ {
        Tags: ["coc.rift.interaction", "coc.lower", *SMITHED_STRICT],
        height: (RIFT_HEIGHT / 3),
        width: (RIFT_HEIGHT / 2),

        Passengers: [
            {
                id: "minecraft:item_display",
                item: {
                    id: "minecraft:stone",
                    components: {
                        "minecraft:item_model": "coc:entity/rift"
                    }
                },
                item_display: "fixed",
                Tags: [*tags, "coc.entity", "coc.rift", *SMITHED_STRICT],
                billboard: "vertical",
                brightness: {block: 15, sky: 15}
            },
            {
                id: "minecraft:interaction",
                Tags:["coc.rift.interaction", "coc.upper", *SMITHED_STRICT],
                height: (2 * RIFT_HEIGHT / 3),
                width: (RIFT_HEIGHT / 2)
            }
        ]
    }

    store result score @n[type=item_display,tag=coc.rift] coc.rift_id scoreboard players add #id coc.rift_id 1