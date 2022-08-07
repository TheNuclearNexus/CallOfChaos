# Ran if start_form succeeds
tag @s add coc.pact_formed
scoreboard players operation @s coc.pact_id = $global coc.pact_id 
scoreboard players set @s coc.rift_energy_pool 1000
scoreboard players set @s coc.relation.lvl 1
scoreboard players set @s coc.relation.pts 0

# Play explosion
tag @s add coc.explode
store result score @s coc.dummy schedule function coc:block/offering_altar/activate/explode 4s append:
    store result score $time coc.dummy time query gametime
    as @e[type=minecraft:armor_stand,tag=coc.natural_rift,tag=coc.explode] at @s if score @s coc.dummy = $time coc.dummy function ./pizzaz:
        particle dragon_breath ~ ~1 ~ 1 1 1 1 200
        particle minecraft:explosion ~ ~1 ~ 0.5 0.5 0.5 1 10
        playsound minecraft:entity.generic.explode master @a ~ ~1 ~ 2 0
        playsound minecraft:block.respawn_anchor.charge master @a ~ ~1 ~ 2 2

        
        as @a at @s playsound minecraft:entity.wither.spawn master @s ~ ~ ~ 0.2 2
        as @a at @s playsound minecraft:block.beacon.power_select master @s ~ ~ ~ 1 1.3
        tag @s remove coc.explode