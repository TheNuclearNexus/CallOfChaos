from beet import LootTable
from coc:modules/coas import use

ctx.data["coc:technical/syringe/set_vial_id"] = LootTable({
    "pools": [
        {
            "rolls": 1,
            "entries": [
                {
                    "type": "minecraft:loot_table",
                    "name": "coc:item/blood_vial",
                    "functions": [
                        {
                            "function": "minecraft:copy_nbt",
                            "source": {
                                "type": "minecraft:storage",
                                "source": "coc:temp"
                            },
                            "ops": [
                                {
                                "source": "PlayerId",
                                "target": "coc.player",
                                "op": "replace"
                                },
                                {
                                    "source": "Lore",
                                    "target": "display.Lore",
                                    "op": "replace"
                                }
                            ]
                        }
                    ]
                }
            ],
        }
    ]
})

with use("syringe"):
    store result score $bottles coc.dummy clear @s glass_bottle 0
    if score $bottles coc.dummy matches 1.. function ./syringe/_give_vial:
        store result storage coc:temp PlayerId int 1 scoreboard players get @s coc.player_id 

        execute summon text_display:
            data modify entity @s text set value '{"translate": "text.coc.blood_vial","fallback":"Belongs to %s","color":"gray","italic": false,"with": [{"selector": "@p","color": "white"}]}'
            data modify storage coc:temp Lore set value []
            data modify storage coc:temp Lore append from entity @s text
            kill @s
        loot give @s loot coc:technical/syringe/set_vial_id
        damage @s[gamemode=!creative,gamemode=!spectator] 3
        clear @s glass_bottle 1