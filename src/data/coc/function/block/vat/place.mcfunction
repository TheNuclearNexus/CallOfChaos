from ./creatures import IDLE_CONSUMPTION

unless block ~ ~1 ~ #coc:air return:
    loot spawn ~ ~ ~ loot coc:blocks/vat
    setblock ~ ~ ~ air
    kill @s


# called by the item generator
setblock ~ ~ ~ minecraft:dropper{
    lock: {components:{custom_data:{impossible:"impossible"}}},
    components: {
        "minecraft:custom_data": {
            smithed: {
                id: "coc:vat",
            },
            coc: {
                silent: 1
            }
        }
    }
}

setblock ~ ~1 ~ barrier

function gu:generate
data modify block ~ ~ ~ components."minecraft:custom_data".coc.uuid set from storage gu:main out

data merge entity @s {
    item: {
        id: "minecraft:tinted_glass",
        components: {
            "minecraft:custom_data": {
                coc: {
                    sink: {
                        capacity: 50,
                        consumption: IDLE_CONSUMPTION
                    }
                }
            }
        }
    },
    Tags: ["coc.block", "coc.vat", "coc.energy.sink", *SMITHED_BLOCK],
}


at @s function coc:energy/api/sink/register