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

as @e[type=armor_stand,tag=coc.natural_rift,sort=nearest,limit=1,distance=..8] at @s function ./place/check_count:
    store result score $altars coc.dummy if entity @e[type=armor_stand,tag=coc.offering_altar,sort=nearest,distance=..8]

    numAltars = [1,2,3,4,5]

    for i in range(len(numAltars)):
        if score @s coc.relation.lvl matches (i+1) function f'coc:block/offering_altar/place/lvl/{i+1}':
            unless score $altars coc.dummy matches f'..{numAltars[i]}' function ./place/disable
            if score $altars coc.dummy matches f'..{numAltars[i]}' function ./place/enable

unless entity @e[type=armor_stand,tag=coc.natural_rift,distance=..8] data modify entity @e[type=armor_stand,tag=coc.offering_altar,distance=..1,sort=nearest,limit=1] ArmorItems[3].tag.CustomModelData set value 0


append function ./place/disable:
    as @e[type=armor_stand,tag=coc.offering_altar,sort=nearest,distance=..8] function ./place/clean_altars:
        tag @s add coc.disabled
        tag @s remove coc.has_item
        data modify entity @s ArmorItems[3].tag.CustomModelData set value 0

    positioned ~ ~1 ~ as @e[type=item,tag=coc.offering_item,sort=nearest,distance=..8] function ./place/clean_items:
        tag @s remove coc.offering_item
        data merge entity @s {PickupDelay:5s}

append function ./place/enable:
    as @e[type=armor_stand,tag=coc.offering_altar,sort=nearest,distance=..8] function ./place/enable_altars:
        tag @s remove coc.disabled
        data modify entity @s ArmorItems[3].tag.CustomModelData set value 4260001

    