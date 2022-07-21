unless entity @e[tag=coc.natural_rift,distance=..196] function ./summon/valid:
    align xyz summon armor_stand ~.5 ~ ~.5 {Tags:["coc.natural_rift","coc.ticking","coc.setup"],Marker:1b,Invisible:1b,NoGravity:1b}

    as @e[type=armor_stand,tag=coc.natural_rift,tag=coc.setup,sort=nearest,limit=1] function ./setup:
        scoreboard players add $global coc.rift_id 1
        scoreboard players operation @s coc.rift_id = $global coc.rift_id

        scoreboard players set @s coc.relation.lvl 1
        
    