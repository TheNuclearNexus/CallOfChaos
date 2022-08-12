from ../relation/check_level_up import maxLevel
from bolt_expressions import Data, Scoreboard

dummy = Scoreboard("coc.dummy")
members = Scoreboard("coc.pact_members")
temp = Data.storage("coc:temp")
rift = Data.storage("coc:rift")

for i in range(1,maxLevel+1):
    # if i < 10:
    spawnCost = (6 * i + (i * -5 // 7)) * 40
    # else:
    #     spawnCost = (10 * i + (i * -5 // 4)) * 40

    if score @s coc.relation.lvl matches i:
        dummy["$baseCost"] = spawnCost

dummy["$costMultiplier"] = dummy["$baseCost"] / 2
dummy["$baseCost"] += dummy["$costMultiplier"] * (members["@s"] - 1)
 
temp.Contract.acquiredCost = dummy["$baseCost"] * 2
temp.Contract.goalCost = dummy["$baseCost"] * 2
temp.Contract.remainingCost = dummy["$baseCost"]

store result storage coc:temp Contract.pactId int 1 scoreboard players get @s coc.pact_id

store result score $time coc.dummy time query gametime
store result storage coc:temp Contract.startTime int 1 scoreboard players get $time coc.dummy

scoreboard players add $time coc.dummy (10*60*20)

store result storage coc:temp Contract.endTime int 1 scoreboard players get $time coc.dummy

rift.Contracts.append(temp.Contract)

schedule function ./process 1t replace
