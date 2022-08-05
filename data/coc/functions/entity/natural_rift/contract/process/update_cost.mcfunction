from bolt_expressions import Data, Scoreboard

advancement revoke @s only coc:technical/contract/kill_enemy

dummy = Scoreboard("coc.dummy")
temp = Data.storage("coc:temp")
rift = Data.storage("coc:rift")

tag @s add coc.contract.killer
schedule function ./schedule 1t append:
    as @a[tag=coc.contract.killer] at @s function ./main:
        scoreboard players set $totalCost coc.dummy 0
        as @e[type=item,nbt={Age:0s,Item:{id:"minecraft:stone",tag:{coc:{}}}},distance=..128] function ./process/update_cost/as_item:
            store result score $cost coc.dummy data get entity @s Item.tag.coc.cost
            store result score $count coc.dummy data get entity @s Item.Count
            scoreboard players operation $cost coc.dummy *= $count coc.dummy
            scoreboard players operation $totalCost coc.dummy += $cost coc.dummy
            kill @s

        temp.Contracts = rift.Contracts
        rift.Contracts = []
        execute function ./process/mobs/update_contract:
            temp.Contract = temp.Contracts[-1]
            temp.Contracts.remove(-1)
            dummy["$riftId"] = temp.Contract.pactId
            if score $riftId coc.dummy = $id coc.dummy function ./process/mobs/add_cost:
                dummy["$acquiredCost"] = temp.Contract.acquiredCost
                dummy["$acquiredCost"] -= dummy["$totalCost"]
                temp.Contract.acquiredCost = dummy["$acquiredCost"]
            rift.Contracts.append(temp.Contract)
        tellraw @a {"nbt":"Contracts","storage": "coc:rift"}
    tag @a remove coc.killer