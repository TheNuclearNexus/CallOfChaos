maxLevel = 20

levelRequirements = []

for lvl in range(1,maxLevel):
    if lvl > 0 and lvl <= 7:
        reqPts = 2 * lvl + 7
    elif lvl > 7 and lvl <= 14:
        reqPts = 5 * lvl + 35
    elif lvl > 14 and lvl <= 21:
        reqPts = 10 * lvl + 100
    levelRequirements.append(reqPts)

append function ./give_advancements:
    for lvl in range(len(levelRequirements)):
        if score $lvl coc.relation.lvl matches f'{lvl+1}..' advancement grant @s only f'coc:main/level{lvl+1}'
        if score $lvl coc.relation.lvl matches f'{lvl+1}..' advancement grant @s only f'coc:knowledge/level{lvl+1}/root'

append function ./level_up:
    scoreboard players operation $id coc.pact_id = @s coc.pact_id
    scoreboard players add @s coc.relation.lvl 1
    scoreboard players set @s coc.relation.pts 1

    scoreboard players operation $lvl coc.relation.lvl = @s coc.relation.lvl
    as @a if score @s coc.pact_id = $id coc.pact_id:
        tellraw @s [{"translate":"text.coc.natural_rift.relation.level_up","italic":true,"color":"light_purple"}]
        function ./give_advancements
    particle dragon_breath ~ ~1 ~ 1 1 1 1 20

for lvl in range(len(levelRequirements)):    
    reqPts = levelRequirements[lvl]
    if score @s coc.relation.lvl matches (lvl+1) if score @s coc.relation.pts matches f'{reqPts}..' function ./level_up
