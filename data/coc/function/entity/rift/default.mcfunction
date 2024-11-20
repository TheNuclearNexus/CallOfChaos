
def create_rift(tags: list[str], model: str ="coc:entity/rift", height = (1.5, 3), width = 4.5/2):
    summon interaction ~ ~ ~ {
        Tags: ["coc.rift.interaction", "coc.lower", *SMITHED_STRICT],
        height: height[0],
        width: width,

        Passengers: [
            {
                id: "minecraft:item_display",
                item: {
                    id: "minecraft:diamond",
                    components: {
                        "minecraft:item_model": model
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
                height: height[1],
                width: width
            }
        ]
    }

    store result score @n[type=item_display,tag=coc.rift] coc.rift_id scoreboard players add #id coc.rift_id 1