positioned ~-.5 ~ ~-.5 if entity @a[dx=0,dy=2,dz=0] as @a[dx=0,dy=2,dz=0,gamemode=!creative,gamemode=!spectator,nbt=!{Health:0f}] function ./damage_player:
    scoreboard players set @s smithed.damage 3
    tag @s add coc.die_to_nat_rift
    function #smithed.damage:entity/apply
    tag @s remove coc.die_to_nat_rift

if entity @s[tag=coc.pact_formed]:
    function ./energy/main

    scoreboard players operation $id coc.pact_id = @s coc.pact_id
    tag @s add coc.target
    as @a[distance=..16] if score @s coc.pact_id = $id coc.pact_id function ./show_eyes:
        positioned as @e[tag=coc.natural_rift,tag=coc.target,limit=1] positioned ~ ~2.5 ~ particle dust 0 0 0 0.5 ~ ~ ~ 1 1 1 0 5 normal @a
    tag @s remove coc.target
