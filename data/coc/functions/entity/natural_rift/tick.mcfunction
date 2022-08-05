# particle dragon_breath ~ ~1 ~ 0.25 0.75 0.25 0.01 4
# particle dust 0 0 0 1 ~ ~1 ~ 0.25 0.5 0.25 0 100

if entity @s[tag=coc.pact_formed]:
    scoreboard players operation $id coc.pact_id = @s coc.pact_id
    tag @s add coc.target
    as @a[distance=..16] if score @s coc.pact_id = $id coc.pact_id function ./show_eyes:
        positioned as @e[tag=coc.natural_rift,tag=coc.target,limit=1] positioned ~ ~2.5 ~ facing entity @s eyes function ./show_eyes/particles:
            particle dust 1 0.7 0 0.4 ^0.125 ^ ^0.25 0 0 0 0 1 force @s
            particle dust 1 0.7 0 0.4 ^-.125 ^ ^0.25 0 0 0 0 1 force @s
    tag @s remove coc.target

unless block ~ ~1 ~ light:
    setblock ~ ~1 ~ light[level=15]