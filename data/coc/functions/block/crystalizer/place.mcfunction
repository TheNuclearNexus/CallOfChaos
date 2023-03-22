import nbtlib
from plugins.smithed.custom_items import get_item
crystalizer = get_item(ctx, 'coc:crystalizer').models
def summonStand(model, rot):
    rot = nbtlib.Float(rot)

    tags = ["coc.crystalizer","coc.ticking","coc.energy.receiver"]
    if model == crystalizer.disabled_up:
        tags.append("coc.up")
    elif model == crystalizer.disabled_down:
        tags.append("coc.down")
        
    summon item_display ~ ~ ~ {
        Tags:tags,
        transformation:{translation:[0f,0f,0f],scale:[2.005f,2.005f,2.005f],left_rotation:[0f,0f,0f,1f],right_rotation:[0f,0f,0f,1f]},
        brightness: {sky: 15, block: 15},
        item:{
            id:"minecraft:dropper",
            Count:1b,
            tag:{CustomModelData: model}
        },
        Rotation:[rot,0f]
    } 

if block ~ ~ ~ dropper[facing=south]:
    summonStand(crystalizer.disabled, 180f)

if block ~ ~ ~ dropper[facing=north]:
    summonStand(crystalizer.disabled, 0f)

if block ~ ~ ~ dropper[facing=west]:
    summonStand(crystalizer.disabled, -90f)

if block ~ ~ ~ dropper[facing=east]:
    summonStand(crystalizer.disabled, 90f)

if block ~ ~ ~ dropper[facing=up]:
    summonStand(crystalizer.disabled_up, 0f)

if block ~ ~ ~ dropper[facing=down]:
    summonStand(crystalizer.disabled_down, 0f)

setblock ~ ~ ~ furnace{Lock:'\\uf001coc.crystalizer',CustomName:'{"translate":"block.coc.crystalizer"}'}

