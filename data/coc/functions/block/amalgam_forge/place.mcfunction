import nbtlib
from plugins.smithed.custom_items import get_item

def summon(rotation):
    summon armor_stand ~ ~ ~ {
        Tags:["coc.amalgam_forge","coc.ticking","coc.energy.receiver"],
        Marker:1b,Invulnerable:1b,Invisible:1b,NoGravity:1b,
        ArmorItems:[{},{},{},{
            id:"minecraft:furnace",
            Count:1b,
            tag:{CustomModelData: get_item(ctx,'coc:amalgam_forge').models.disabled}
        }],
        Rotation:[nbtlib.Float(rotation), 0.0f]
    }

if block ~ ~ ~ furnace[facing=south] function ./place/s:
    summon(0)
if block ~ ~ ~ furnace[facing=north] function ./place/n:
    summon(180)
if block ~ ~ ~ furnace[facing=west] function ./place/w:
    summon(90)
if block ~ ~ ~ furnace[facing=east] function ./place/e:
    summon(-90)


setblock ~ ~ ~ air
setblock ~ ~ ~ furnace{Lock:"\\uf001coc.amalgam_forge",CustomName:'{"translate":"block.coc.amalgam_forge"}'}
