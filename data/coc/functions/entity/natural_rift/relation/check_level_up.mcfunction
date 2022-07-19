append function ./level_up:
    scoreboard players operation $id coc.pact_id = @s coc.pact_id
    scoreboard players add @s coc.relation.lvl 1
    scoreboard players set @s coc.relation.pts 1

    as @a if score @s coc.pact_id = $id coc.pact_id:
        tellraw @s [{"translate":"text.coc.natural_rift.relation.level_up","italic":true,"color":"gray"}]

    particle dragon_breath ~ ~1 ~ 1 1 1 1 20

maxLevel = 20

for lvl in range(1,maxLevel):
    if lvl > 0 and lvl <= 7:
        reqPts = 2 * lvl + 7
    elif lvl > 7 and lvl <= 14:
        reqPts = 5 * lvl + 35
    elif lvl > 14 and lvl <= 21:
        reqPts = 10 * lvl + 100
    
    if score @s coc.relation.lvl matches lvl if score @s coc.relation.pts matches f'{reqPts}..' function ./level_up
        
