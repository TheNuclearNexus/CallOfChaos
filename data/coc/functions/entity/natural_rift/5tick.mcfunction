positioned ~-.5 ~ ~-.5 if entity @a[dx=0,dy=2,dz=0] as @a[dx=0,dy=2,dz=0,gamemode=!creative,gamemode=!spectator,nbt=!{Health:0f}] function ./damage_player:
    scoreboard players set @s smithed.damage 3
    tag @s add coc.die_to_nat_rift
    function #smithed.damage:entity/apply
    tag @s remove coc.die_to_nat_rift

if entity @s[tag=coc.pact_formed]:
    function ./energy/main