setblock ~ ~ ~ air
setblock ~ ~ ~ furnace{Lock:"\\uf001coc.eternal_burner",CustomName:'{"translate":"block.coc.eternal_burner"}'}
summon armor_stand ~ ~ ~ {
    Tags:["coc.eternal_burner","coc.ticking","coc.energy.receiver"],
    Marker:1b,Invulnerable:1b,Invisible:1b,NoGravity:1b,
    ArmorItems:[{},{},{},{
        id:"minecraft:furnace",
        Count:1b,
        tag:{CustomModelData:4260005}
    }]
}
