from bolt_expressions import Data, Scoreboard
from beet import LootTable

say processing

dummy = Scoreboard("coc.dummy")
temp = Data.storage("coc:temp")
rift = Data.storage("coc:rift")

temp.Contracts = rift.Contracts
rift.Contracts = []

mobs = [
    {"id": "minecraft:zombie", cost: 1, weight:7, nbt: {}},
    {"id": "minecraft:skeleton", cost: 3, weight:10, nbt: {}}
]






execute function ./process/each:
    temp.Contract = temp.Contracts[-1]
    temp.Contracts.remove(-1)

    dummy["$endTime"] = temp.Contract.endTime
    store result score $time coc.dummy time query gametime

    if score $endTime coc.dummy <= $time coc.dummy function ./process/fail 
    dummy["$cycle"] = dummy["$time"] % 5
    unless score $endTime coc.dummy <= $time coc.dummy function ./process/continue:
        # if score $cycle coc.dummy matches 0 
        dummy["$remainingCost"] = temp.Contract.remainingCost
        execute function ./process/try_spawn:
            temp.MasterMobs = rift.Mobs
            function ./process/spawn
            temp.Contract.remainingCost = dummy["$remainingCost"]

        if score $remainingCost coc.dummy matches 1..:
            rift.Contracts.append(temp.Contract)

append function ./process/spawn:
    loot replace block -30000000 3 1600 container.0 loot coc:technical/generate_attribute 
    store result score $rand coc.dummy data get block -30000000 3 1600 Items[0].tag.AttributeModifiers[0].UUID[0]
    tellraw @a ["\n\nRandom: ",{"score":{"objective":"coc.dummy","name":"$rand"}}]


    dummy["$sumWeight"] = 0
    temp.Mobs = temp.MasterMobs
    execute function ./process/sum_weight:
        dummy["$sumWeight"] += temp.Mobs[-1].weight
        temp.Mobs.remove(-1)
        if data storage coc:temp Mobs[] function ./process/sum_weight
    tellraw @a ["Summed Weight: ",{"score":{"objective":"coc.dummy","name":"$sumWeight"}}]


    dummy["$randWeight"] = dummy["$rand"] % dummy["$sumWeight"]
    if score $randWeight coc.dummy matches ..-1:
        dummy["$randWeight"] = dummy["$randWeight"] * -1

    tellraw @a ["Rand Weight: ",{"score":{"objective":"coc.dummy","name":"$randWeight"}}]

    temp.Mobs = temp.MasterMobs
    execute function ./process/find_index:
        temp.Mob = temp.Mobs[0]
        temp.Mobs.remove(0)
        dummy["$randWeight"] -= temp.Mob.weight
        tellraw @a [" - ",{"nbt":"Mob","storage":"coc:temp"}]
        tellraw @a [" - ",{"score":{"objective":"coc.dummy","name":"$randWeight"}}]
        if score $randWeight coc.dummy matches ..0 function ./process/found_index
        unless score $randWeight coc.dummy matches ..0 if data storage coc:temp Mobs[] function ./process/find_index

    append function ./process/found_index:
        dummy["$index"] = temp.Mob.index
        tellraw @a ["Index: ",{"score":{"objective":"coc.dummy","name":"$index"}}]
        tellraw @a ["Remaining Cost: ",{"score":{"objective":"coc.dummy","name":"$remainingCost"}}]
        for i in range(len(mobs)):
            if score $index coc.dummy matches i function f'coc:entity/natural_rift/contract/process/found_mob/{i}':
                dummy["$suc"] = 0
                if score $remainingCost coc.dummy matches f'{mobs[i].cost}..' function f'coc:entity/natural_rift/contract/process/spawn/{i}':
                    dummy["$suc"] = 1
                    tellraw @a "  - Summon"
                    at @r summon mobs[i].id ~ ~ ~ mobs[i].nbt
                    dummy["$remainingCost"] -= mobs[i].cost
                if score $suc coc.dummy matches 0 function f'coc:entity/natural_rift/contract/process/remove/{i}':
                    tellraw @a "  - Remove"
                    data remove storage coc:temp MasterMobs[{index: i}]
                    if data storage coc:temp MasterMobs[] function ./process/spawn






            


    



if data storage coc:rift Contracts[] schedule function ./process 1s replace