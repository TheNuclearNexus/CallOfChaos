from plugins.smithed.custom_items import get_item

setblock ~ ~ ~ dropper{Lock:"\\uf001coc.rift_stabilizer",CustomName:'{"translate":"block.coc.rift_stabilizer"}'}
summon armor_stand ~ ~ ~ {
    Tags:["coc.rift_stabilizer","coc.ticking"],
    Marker:1b,Invulnerable:1b,Invisible:1b,NoGravity:1b,
    ArmorItems:[{},{},{},{
        id:"minecraft:furnace",
        Count:1b,
        tag:{CustomModelData: get_item(ctx, 'coc:rift_stabilizer').models.default }
    }]
}
