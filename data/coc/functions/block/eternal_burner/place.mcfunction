from plugins.smithed.custom_items import get_item

setblock ~ ~ ~ air
setblock ~ ~ ~ furnace{Lock:"\\uf001coc.eternal_burner",CustomName:'{"translate":"block.coc.eternal_burner"}'}
summon item_display ~ ~ ~ {
    Tags:["coc.eternal_burner","coc.ticking","coc.energy.receiver"],
    transformation:{translation:[0f,0f,0f],scale:[1.005f,1.005f,1.005f],left_rotation:[0f,0f,0f,1f],right_rotation:[0f,0f,0f,1f]},
    brightness: {sky: 15, block: 15},
    item:{
        id:"minecraft:furnace",
        Count:1b,
        tag:{CustomModelData: get_item(ctx, 'coc:eternal_burner').models.disabled}
    },view_range:64f,
    item_display: "head"
}
