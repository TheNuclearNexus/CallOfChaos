setblock ~ ~ ~ lantern
summon armor_stand ~ ~-0.5 ~ {
    Tags:["coc.focusing_crystal","coc.energy.transferer",'coc.ticking'],
    Invisible:1b, Invulnerable:1b, Marker:1b, NoGravity:1b,
    ArmorItems:[{},{},{},{
        id:"minecraft:furnace",
        Count:1b,
        tag:{CustomModelData:4260002}
    }]
}
