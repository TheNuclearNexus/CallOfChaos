import nbtlib

def summonStand(model, rot):
    rot = nbtlib.Float(rot)

    tags = ["coc.crystalizer","coc.ticking","coc.energy.receiver"]
    if model == 4260009:
        tags.append("coc.up")
    elif model == 4260011:
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
    summonStand(4260007, 0f)

if block ~ ~ ~ dropper[facing=north]:
    summonStand(4260007, 180f)

if block ~ ~ ~ dropper[facing=west]:
    summonStand(4260007, 90f)

if block ~ ~ ~ dropper[facing=east]:
    summonStand(4260007, -90f)

if block ~ ~ ~ dropper[facing=up]:
    summonStand(4260009, 0f)

if block ~ ~ ~ dropper[facing=down]:
    summonStand(4260011, 0f)

setblock ~ ~ ~ furnace{Lock:'\\uf001coc.crystalizer',CustomName:'{"translate":"block.coc.crystalizer"}'}

