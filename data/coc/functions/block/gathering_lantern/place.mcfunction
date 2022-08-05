if block ~ ~-1 ~ #coc:no_collision unless block ~ ~1 ~ #coc:no_collision function ./place/hanging:
    setblock ~ ~ ~ lantern[hanging=true]
    summon armor_stand ~ ~-0.5 ~ {
        Tags:["coc.gathering_lantern","coc.energy.transferer",'coc.ticking'],
        Invisible:1b, Invulnerable:1b, Marker:1b, NoGravity:1b,
        ArmorItems:[{},{},{},{
            id:"minecraft:furnace",
            Count:1b,
            tag:{CustomModelData:4260016}
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
            tag:{CustomModelData:4260014}
        }]
    }


