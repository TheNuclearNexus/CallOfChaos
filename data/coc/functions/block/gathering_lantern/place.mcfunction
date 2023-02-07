from plugins.smithed.custom_items import get_item
gathering_lantern = get_item(ctx, 'coc:gathering_lantern').models

if block ~ ~-1 ~ #coc:no_collision unless block ~ ~1 ~ #coc:no_collision function ./place/hanging:
    setblock ~ ~ ~ lantern[hanging=true]
    summon armor_stand ~ ~-0.5 ~ {
        Tags:["coc.gathering_lantern","coc.energy.transferer",'coc.ticking'],
        Invisible:1b, Invulnerable:1b, Marker:1b, NoGravity:1b,
        ArmorItems:[{},{},{},{
            id:"minecraft:furnace",
            Count:1b,
            tag:{CustomModelData:gathering_lantern.disabled_hanging}
        }]
    }


if block ~ ~ ~ furnace function ./place/sitting:
    setblock ~ ~ ~ lantern
    summon armor_stand ~ ~-0.5 ~ {
        Tags:["coc.gathering_lantern","coc.energy.transferer",'coc.ticking'],
        Invisible:1b, Invulnerable:1b, Marker:1b, NoGravity:1b,
        ArmorItems:[{},{},{},{
            id:"minecraft:furnace",
            Count:1b,
            tag:{CustomModelData:gathering_lantern.disabled}
        }]
    }


