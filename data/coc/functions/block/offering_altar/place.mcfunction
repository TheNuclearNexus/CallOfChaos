setblock ~ ~ ~ air
setblock ~ ~ ~ furnace{Lock:"\\uf001coc.offering_altar",CustomName:'{"translate":"block.coc.offering_altar"}'}
summon armor_stand ~ ~ ~ {
    Tags:["coc.offering_altar","coc.ticking"],
    Marker:1b,Invulnerable:1b,Invisible:1b,NoGravity:1b,
    ArmorItems:[{},{},{},{
        id:"minecraft:furnace",
        Count:1b,
        tag:{CustomModelData:4260001}
    }]
}
