unless entity @e[type=snowball,tag=coc.natural_rift.display,distance=..2.5] function ./1second/respawn_display:
    scoreboard players operation $id coc.rift_id = @s coc.rift_id
    as @e[type=snowball,tag=coc.natural_rift.display] if score @s coc.rift_id = $id coc.rift_id kill @s
    summon snowball ~ ~2.25 ~ {Tags:["coc.natural_rift.display","coc.setup"],Item:{id:"minecraft:snowball",tag:{CustomModelData:4260001},Count:1b},NoGravity:1b,Invulnerable:1b}
    positioned ~ ~2.25 ~ scoreboard players operation @e[tag=coc.natural_rift.display,tag=coc.setup] coc.rift_id = @s coc.rift_id
    tag @e remove coc.setup


