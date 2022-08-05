unless entity @e[tag=coc.natural_rift,distance=..196] align xyz positioned ~.5 ~ ~.5 function ./summon/valid:
    summon armor_stand ~ ~ ~ {Tags:["coc.natural_rift","coc.ticking","coc.setup"],Marker:1b,Invisible:1b,NoGravity:1b}
    summon snowball ~ ~2.25 ~ {Tags:["coc.natural_rift.display","coc.setup"],Item:{id:"minecraft:snowball",tag:{CustomModelData:4260001},Count:1b},NoGravity:1b,Invulnerable:1b}

    as @e[type=armor_stand,tag=coc.natural_rift,tag=coc.setup,sort=nearest,limit=1] function ./setup:
        scoreboard players add $global coc.rift_id 1
        scoreboard players operation @s coc.rift_id = $global coc.rift_id
        positioned ~ ~2.25 ~ scoreboard players operation @e[tag=coc.natural_rift.display,tag=coc.setup] coc.rift_id = $global coc.rift_id


        scoreboard players set @s coc.relation.lvl 1
        scoreboard players set @s coc.pact_members 1
        
    tag @e remove coc.setup