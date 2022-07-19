from ../relation/check_level_up import maxLevel
from bolt_expressions import Data, Scoreboard

temp = Data.storage("coc:temp")
rift = Data.storage("coc:rift")

for i in range(1,maxLevel+1):
    if i < 10:
        spawnCost = 7 * i + (i * 5 // 2)
    else:
        spawnCost = 10 * i + (i * 7 // 2)

    if score @s coc.relation.lvl matches i:
        temp.Contract = {goalCost: spawnCost, remainingCost: spawnCost, acquiredCost: spawnCost}

store result storage coc:temp Contract.pactId int 1 scoreboard players get @s coc.pact_id

store result score $time coc.dummy time query gametime
scoreboard players add $time coc.dummy (20*60*20)

store result storage coc:temp Contract.endTime int 1 scoreboard players get $time coc.dummy

rift.Contracts.append(temp.Contract)

schedule function ./process 1t replace
