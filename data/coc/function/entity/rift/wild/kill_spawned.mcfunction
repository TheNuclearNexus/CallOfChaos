scoreboard players operation #id coc.dummy = @s coc.rift_id
execute as @e[tag=coc.rift.spawned] if score @s coc.rift_id = #id coc.dummy run kill @s

