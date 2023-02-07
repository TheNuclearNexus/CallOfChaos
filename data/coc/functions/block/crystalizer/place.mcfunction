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
        
    summon armor_stand ~ ~ ~ {
        Tags:tags,
        Invisible:1b,Invulnerable:1b,Marker:1b,NoGravity:1b,
        ArmorItems:[{},{},{},{
            id:"minecraft:dropper",
            Count:1b,
            tag:{CustomModelData: model}
        }],
        Rotation:[rot,0f]
    } 

if block ~ ~ ~ dropper[facing=south]:
    summonStand(crystalizer.disabled, 0f)

if block ~ ~ ~ dropper[facing=north]:
    summonStand(crystalizer.disabled, 180f)

if block ~ ~ ~ dropper[facing=west]:
    summonStand(crystalizer.disabled, 90f)

if block ~ ~ ~ dropper[facing=east]:
    summonStand(crystalizer.disabled, -90f)

if block ~ ~ ~ dropper[facing=up]:
    summonStand(crystalizer.disabled_up, 0f)

if block ~ ~ ~ dropper[facing=down]:
    summonStand(crystalizer.disabled_down, 0f)

setblock ~ ~ ~ furnace{Lock:'\\uf001coc.crystalizer',CustomName:'{"translate":"block.coc.crystalizer"}'}

