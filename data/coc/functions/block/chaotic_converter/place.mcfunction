import nbtlib

def summonStand(model, rot):
    rot = nbtlib.Float(rot)

    tags = ["coc.chaotic_converter","coc.ticking","coc.energy.receiver"]
    if model == 4260003:
        tags.append("coc.up")
    elif model == 4260005:
        tags.append("coc.down")
        
    summon armor_stand ~ ~-0.5 ~ {
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
    summonStand(4260001, 0f)

if block ~ ~ ~ dropper[facing=north]:
    summonStand(4260001, 180f)

if block ~ ~ ~ dropper[facing=west]:
    summonStand(4260001, 90f)

if block ~ ~ ~ dropper[facing=east]:
    summonStand(4260001, -90f)

if block ~ ~ ~ dropper[facing=up]:
    summonStand(4260003, 0f)

if block ~ ~ ~ dropper[facing=down]:
    summonStand(4260005, 0f)

setblock ~ ~ ~ furnace{Lock:'\\\\uf001coc.chaotic_converter',CustomName:'{"translate":"block.coc.chaotic_converter"}'}

