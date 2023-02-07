import nbtlib
from plugins.smithed.custom_items import get_item
entropic_accelerator = get_item(ctx, 'coc:entropic_accelerator').models

def summonStand(model, rot):
    rot = nbtlib.Float(rot)

    tags = ["coc.entropic_accelerator","coc.ticking","coc.energy.receiver"]
    if model == entropic_accelerator.disabled_up:
        tags.append("coc.up")
    elif model == entropic_accelerator.disabled_down:
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
    summonStand(entropic_accelerator.disabled, 0f)

if block ~ ~ ~ dropper[facing=north]:
    summonStand(entropic_accelerator.disabled, 180f)

if block ~ ~ ~ dropper[facing=west]:
    summonStand(entropic_accelerator.disabled, 90f)

if block ~ ~ ~ dropper[facing=east]:
    summonStand(entropic_accelerator.disabled, -90f)

if block ~ ~ ~ dropper[facing=up]:
    summonStand(entropic_accelerator.disabled_up, 0f)

if block ~ ~ ~ dropper[facing=down]:
    summonStand(entropic_accelerator.disabled_down, 0f)

setblock ~ ~ ~ furnace{Lock:'\\uf001coc.entropic_accelerator',CustomName:'{"translate":"block.coc.entropic_accelerator"}'}

