from bolt_expressions import Data, Scoreboard
from beet import LootTable
from ./mobs import leveledMobs

# say processing

dummy = Scoreboard("coc.dummy")
temp = Data.storage("coc:temp")
rift = Data.storage("coc:rift")

temp.Contracts = rift.Contracts
rift.Contracts = []

cheapness = 40 # How many times more remaining cost is than desired card



defaultNbt = {
    Tags:["coc.contract_enemy", "coc.setup", "smithed.entity"],
    ArmorItems:[
        {tag:{coc: {cost: 0}}},
        {},{},
        {id: "minecraft:stone_button", Count:1b}
    ],
    ArmorDropChances:[2f,0f,0f,0f]
}

def merge(a, b):
    # print(a,b)
    if isinstance(a, dict) and isinstance(b, dict):
        r = {}
        r.update(a)
        for key, value in b.items():
            if key == 'ArmorItems':
                r[key] = b[key].copy()
            else:
                r[key] = merge(r.get(key), value)
        return r
    if isinstance(a, list) and isinstance(b, list):
        return a + b
    else:
        return b

mobs = []

for lvl in range(len(leveledMobs)):    
    for i in range(len(leveledMobs[lvl])):
        mob = leveledMobs[lvl][i]
        mob['nbt'] = merge(mob['nbt'], defaultNbt)
        mob.nbt.ArmorItems[0] = {id:"minecraft:stone",Count:1b,tag:{coc:{contract:1b,cost: mob['cost']}}}
        mob['weight'] *= (len(leveledMobs) - lvl)
        mobs.append(mob)

execute function ./process/each:
    temp.Contract = temp.Contracts[-1]
    temp.Contracts.remove(-1)

    dummy["$acquiredCost"] = temp.Contract.acquiredCost
    if score $acquiredCost coc.dummy matches 1.. function ./process/each/active:
        dummy["$endTime"] = temp.Contract.endTime
        store result score $time coc.dummy time query gametime

        if score $endTime coc.dummy <= $time coc.dummy function ./process/fail:
            # TODO: Add contract lost message 
            dummy["$id"] = temp.Contract.pactId
            as @a if score @s coc.pact_id = $id coc.pact_id tellraw @s {"translate":"text.coc.natural_rift.contract.loss","color":"gray"}
            as @e[tag=coc.contract_enemy] if score @s coc.pact_id = $id coc.dummy tp @s ~ -128 ~

        dummy["$cycle"] = dummy["$time"] % 5
        unless score $endTime coc.dummy <= $time coc.dummy function ./process/continue:
            dummy["$remainingCost"] = temp.Contract.remainingCost 
            if score $cycle coc.dummy matches 0 if predicate coc:technical/contract/spawn_mob function ./process/try_spawn: 
                temp.MasterMobs = rift.Mobs
                function ./process/spawn
            if score $cycle coc.dummy matches 0 if predicate coc:technical/contract/gain_cost function ./process/gain_cost:
                dummy["$maxCost"] = temp.Contract.goalCost / 2
                dummy["$gainedCost"] = max(dummy["$maxCost"] / 20, 5)
                if score $remainingCost coc.dummy < $maxCost coc.dummy:
                    dummy["$remainingCost"] += dummy["$gainedCost"]

            temp.Contract.remainingCost = dummy["$remainingCost"]
            rift.Contracts.append(temp.Contract)

    # ____    __    ____  __  .__   __. 
    # \   \  /  \  /   / |  | |  \ |  | 
    #  \   \/    \/   /  |  | |   \|  | 
    #   \            /   |  | |  . `  | 
    #    \    /\    /    |  | |  |\   | 
    #     \__/  \__/     |__| |__| \__| 
    #
    if score $acquiredCost coc.dummy matches ..0 function ./process/win:
        # TODO: add win message
        dummy["$id"] = temp.Contract.pactId
        as @a if score @s coc.pact_id = $id coc.pact_id tellraw @s {"translate":"text.coc.natural_rift.contract.win","color":"gray"}
        as @e[type=minecraft:armor_stand,tag=coc.natural_rift]:
            scoreboard players add @s coc.relation.pts 5
            function coc:entity/natural_rift/relation/check_level_up

        as @e[tag=coc.contract_enemy] if score @s coc.pact_id = $id coc.dummy tp @s ~ -128 ~

append function ./process/spawn:
    loot replace block -30000000 3 1600 container.0 loot coc:technical/generate_attribute 
    store result score $rand coc.dummy data get block -30000000 3 1600 Items[0].tag.AttributeModifiers[0].UUID[0]
    # tellraw @a ["\n\nRandom: ",{"score":{"objective":"coc.dummy","name":"$rand"}}]

    dummy["$sumWeight"] = 0
    temp.Mobs = temp.MasterMobs
    execute function ./process/sum_weight:
        dummy["$sumWeight"] += temp.Mobs[-1].weight
        temp.Mobs.remove(-1)
        if data storage coc:temp Mobs[] function ./process/sum_weight
    # tellraw @a ["Summed Weight: ",{"score":{"objective":"coc.dummy","name":"$sumWeight"}}]


    dummy["$randWeight"] = dummy["$rand"] % dummy["$sumWeight"]
    if score $randWeight coc.dummy matches ..-1:
        dummy["$randWeight"] = dummy["$randWeight"] * -1

    # tellraw @a ["Rand Weight: ",{"score":{"objective":"coc.dummy","name":"$randWeight"}}]

    temp.Mobs = temp.MasterMobs
    execute function ./process/find_index:
        temp.Mob = temp.Mobs[0]
        temp.Mobs.remove(0)
        dummy["$randWeight"] -= temp.Mob.weight
        # tellraw @a [" - ",{"nbt":"Mob","storage":"coc:temp"}]
        # tellraw @a [" - ",{"score":{"objective":"coc.dummy","name":"$randWeight"}}]
        if score $randWeight coc.dummy matches ..0 function ./process/found_index
        unless score $randWeight coc.dummy matches ..0 if data storage coc:temp Mobs[] function ./process/find_index


    append function ./process/tp/x:
        store result score $x coc.dummy loot spawn ~ ~ ~ loot coc:technical/random/0_25
        for i in range(-12,14):
            offset = 3
            if i <= 0:
                offset = -4

            if score $x coc.dummy matches (i+12) positioned f'~{i + offset} ~ ~' function ./process/tp/z

    append function ./process/tp/z:
        store result score $z coc.dummy loot spawn ~ ~ ~ loot coc:technical/random/0_25
        for i in range(-12,14):
            offset = 3
            if i <= 0:
                offset = -4

            if score $z coc.dummy matches (i+12) positioned f'~ ~-256 ~{i + offset}' function ./process/tp/valid

    append function ./process/tp/valid:
        dummy["$limit"] -= 1
        dummy["$valid"] = 0
        unless block ~ ~-1 ~ #coc:no_collision if block ~ ~ ~ #coc:no_collision if block ~ ~1 ~ #coc:no_collision function ./process/tp/sucess:
            scoreboard players set $valid coc.dummy 1
            tp @s ~ ~ ~
        unless score $valid coc.dummy matches 1.. unless block ~ ~ ~ #coc:no_collision function ./process/tp/y/up:
            if block ~ ~ ~ #coc:no_collision if block ~ ~1 ~ #coc:no_collision function ./process/tp/success

            unless score $valid coc.dummy matches 1.. positioned ~ ~1 ~ if entity @s[distance=..8] function ./process/tp/y/up
        
        unless score $valid coc.dummy matches 1.. if block ~ ~-1 ~ #coc:no_collision function ./process/tp/y/down:
            unless block ~ ~-1 ~ #coc:no_collision function ./process/tp/success

            unless score $valid coc.dummy matches 1.. positioned ~ ~-1 ~ if entity @s[distance=..8] function ./process/tp/y/down
        
        unless score $valid coc.dummy matches 1 if score $limit coc.dummy matches 0 function ./process/tp/fail:
            tp @s ~ -128 ~
            scoreboard players operation $remainingCost coc.dummy += @s coc.cost
        unless score $valid coc.dummy matches 1 if score $limit coc.dummy matches 1.. at @s function ./process/tp/x 


    append function ./process/found_index:
        dummy["$index"] = temp.Mob.index
        # tellraw @a ["Index: ",{"score":{"objective":"coc.dummy","name":"$index"}}]
        # tellraw @a ["Remaining Cost: ",{"score":{"objective":"coc.dummy","name":"$remainingCost"}}]
        for i in range(len(mobs)):
            if score $index coc.dummy matches i function f'coc:entity/natural_rift/contract/process/found_mob/{i}':
                dummy["$suc"] = 0
                if score $remainingCost coc.dummy matches f'{mobs[i].cost}..' unless score $remainingCost coc.dummy matches f'{mobs[i].cost * cheapness}..' function f'coc:entity/natural_rift/contract/process/spawn/{i}':
                    dummy["$suc"] = 1
                    # tellraw @a "  - Summon"

                    dummy["$id"] = temp.Contract.pactId
                    as @a[gamemode=!creative,gamemode=!spectator] if score @s coc.pact_id = $id coc.dummy tag @s add coc.in_pact
                    at @r[tag=coc.in_pact] function f'coc:entity/natural_rift/contract/process/spawn/{i}/at_player':
                        summon mobs[i].id ~ ~256 ~ mobs[i].nbt
                        positioned ~ ~256 ~ as @e[tag=coc.contract_enemy,tag=coc.setup,dx=0] at @s function f'coc:entity/natural_rift/contract/process/setup/{i}':
                            scoreboard players operation @s coc.pact_id = $id coc.dummy
                            scoreboard players set @s coc.cost mobs[i].cost
                            if "lifetime" in mobs[i]:
                                scoreboard players set @s coc.lifetime (mobs[i].lifetime * 20)

                            dummy["$limit"] = 8
                            function ./process/tp/x 

                    tag @a remove coc.in_pact
                    dummy["$remainingCost"] -= mobs[i].cost
                if score $suc coc.dummy matches 0 function f'coc:entity/natural_rift/contract/process/remove/{i}':
                    # tellraw @a "  - Remove"
                    data remove storage coc:temp MasterMobs[{index: i}]
                    if data storage coc:temp MasterMobs[] function ./process/spawn




execute function ./process/tick_mobs:
    as @e[tag=coc.contract_enemy] at @s function ./process/mobs/default:
        if score @s coc.lifetime matches 1.. scoreboard players remove @s coc.lifetime 1
        if score @s coc.lifetime matches 0 function ./process/mobs/return_to_pool:
            tp @s ~ -128 ~
            tag @s remove coc.contract_enemy
            scoreboard players operation $id coc.dummy = @s coc.pact_id

            temp.Contracts = rift.Contracts
            rift.Contracts = []
            execute function ./process/mobs/update_contract:
                temp.Contract = temp.Contracts[-1]
                temp.Contracts.remove(-1)
                dummy["$riftId"] = temp.Contract.pactId
                if score $riftId coc.dummy = $id coc.dummy function ./process/mobs/add_cost:
                    dummy["$remainingCost"] = temp.Contract.remainingCost
                    dummy["$goalCost"] = temp.Contract.goalCost
                    dummy["$remainingCost"] += Scoreboard("coc.cost")["@s"]
                    temp.Contract.remainingCost = dummy["$remainingCost"]
                    if score $remainingCost coc.dummy > $goalCost coc.dummy scoreboard players operation $remainingCost coc.dummy = $goalCost coc.dummy
                rift.Contracts.append(temp.Contract)
            # tellraw @a {"nbt":"Contracts","storage": "coc:rift"}

    kill @e[type=item,nbt=!{Age:0s},nbt={Item:{tag:{coc:{contract:1b}}}}]

    



if data storage coc:rift Contracts[] schedule function ./process 1t replace