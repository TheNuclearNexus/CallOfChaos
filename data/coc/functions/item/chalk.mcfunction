from beet import LootTable
from coc:modules/coas import use
from coc:modules/rift/ritual import ItemCircle, OutputCircle, MIRROR_NAMES, MIRROR_MULTIS
from bolt_expressions import Data, Scoreboard

self = Data.entity("@s")
itemConversion = self.item.tag.coc.conversion
tempStorage = Data.storage("coc:temp")
dummy = Scoreboard("coc.dummy")

with use("chalk"):
    scoreboard players set $suc coc.dummy 0
    anchored eyes positioned ^ ^ ^ function ./chalk/find_block:
        if block ~ ~ ~ #coc:solid align xyz positioned ~.5 ~1 ~.5 
            if block ~ ~ ~ #coc:air unless entity @e[type=item_display,tag=coc.chalk,distance=..0.5,limit=1] function ./chalk/place
        if score $suc coc.dummy matches 0 as @e[type=item_display,tag=coc.chalk,distance=..0.5,limit=1] function ./chalk/cycle
        if score $suc coc.dummy matches 0 positioned ^ ^ ^0.1 if entity @s[distance=..6] function ./chalk/find_block 

append function ./chalk/cycle:
    scoreboard players set $suc coc.dummy 1
    

    if entity @s[tag=coc.activation,tag=!coc.cycled] function ./chalk/cycle/item:
        tag @s remove coc.activation
        tag @s add coc.item
        tag @s add coc.cycled

        data modify entity @s item.tag.CustomModelData set value 4260017

    
    if entity @s[tag=coc.item,tag=!coc.has_item,tag=!coc.cycled] function ./chalk/cycle/output:
        tag @s remove coc.item
        tag @s add coc.output
        tag @s add coc.cycled

        data modify entity @s item.tag.CustomModelData set value 4260018

    if entity @s[tag=coc.output,tag=!coc.has_item,tag=!coc.cycled] function ./chalk/cycle/dot:
        tag @s remove coc.output
        tag @s add coc.dot
        tag @s add coc.cycled

        store result entity @s item.tag.CustomModelData int 1 scoreboard players get @s coc.dummy
        on passengers kill @s


    if entity @s[tag=coc.dot,tag=!coc.cycled] function ./chalk/cycle/activation:
        tag @s remove coc.dot
        tag @s add coc.activation
        tag @s add coc.cycled

        data modify entity @s item.tag.CustomModelData set value 4260016

        execute summon interaction function ./chalk/cycle/give_interaction:
            data merge entity @s {width: 0.5, height: 0.01, Tags:["coc.chalk_interaction"]}
            ride @s mount @e[type=item_display,tag=coc.chalk,tag=coc.cycled,limit=1,distance=..0.5]

    tag @s remove coc.cycled

append function ./chalk/place:
    scoreboard players set $suc coc.dummy 1
    execute summon item_display function ./chalk/setup:
        data merge entity @s {Tags:["coc.chalk","coc.dot"],item:{id: "minecraft:string", tag:{CustomModelData:4260000}, Count:1b},transformation: {translation: [0f,0.5001f, 0f], scale:[1f,1f,1f], left_rotation: [0f,0f,0f,1f], right_rotation: [0f,0f,0f,1f]}}  
        function ./chalk/update_lines
        tag @e remove coc.checked

advancement coc:item/chalk/interact {
  "criteria": {
    "requirement": {
      "trigger": "minecraft:player_interacted_with_entity",
      "conditions": {
        "entity": {
          "type": "minecraft:interaction",
          "nbt": "{Tags:[\"coc.chalk_interaction\"]}"
        }
      }
    }
  },
  "rewards": {
    "function": "coc:item/chalk/interact"
  }
}

append function ./chalk/interact:
    advancement revoke @s only coc:item/chalk/interact
    data remove storage coc:temp Mainhand
    data modify storage coc:temp Mainhand set from entity @s SelectedItem

    dummy["$riftId"] = Scoreboard("coc.rift_id")["@s"]

    anchored eyes positioned ^ ^ ^ function ./chalk/interact/_get_entity:
        # Run the function on the interaction's vehicle; the rift entity
        # particle happy_villager ~ ~ ~ 0 0 0 0 1
        scoreboard players set $suc coc.dummy 0
        positioned ~-.5 ~-.5 ~-.5 as @e[type=interaction,tag=coc.chalk_interaction,dx=0] at @s on vehicle function ./chalk/interact/_found:
            scoreboard players set $suc coc.dummy 1
            if data storage coc:temp Mainhand.tag.smithed{id:"coc:chalk"} function ./chalk/cycle
            unless entity @s[tag=!coc.item,tag=!coc.output] unless data storage coc:temp Mainhand.tag.smithed{id:"coc:chalk"} function ./chalk/interact/item:
                if entity @s[tag=coc.has_item] if data storage coc:temp Mainhand function ./chalk/interact/swap_item
                if entity @s[tag=!coc.has_item] if data storage coc:temp Mainhand function ./chalk/interact/add_item
                if entity @s[tag=coc.has_item] unless data storage coc:temp Mainhand function ./chalk/interact/remove_item

            if entity @s[tag=coc.activation] unless data storage coc:temp Mainhand.tag.smithed{id:"coc:chalk"} function ./chalk/interact/activation

        if score $suc coc.dummy matches 0 positioned ^ ^ ^0.1 if entity @s[distance=..6] function ./chalk/interact/_get_entity

append function ./chalk/interact/add_item:
    tag @s add coc.has_item
    summon item ~ ~ ~ {Tags:["coc.chalk_item"], Age: -32767s, PickupDelay: 32767s, Invulnerable:1b, Item:{id:"minecraft:stone", Count:1}}
    as @e[type=item,tag=coc.chalk_item,distance=..0.5,limit=1] function ./chalk/interact/copy_item:
        data modify entity @s Item set from storage coc:temp Mainhand
        data modify entity @s Item.Count set value 1b
        ride @s mount @e[type=item_display,distance=..0.5,tag=coc.has_item,tag=coc.chalk,limit=1]

    on passengers if entity @s[type=interaction] on target item modify entity @s[gamemode=!creative,gamemode=!spectator] weapon.mainhand coc:reduce_count/1

append function ./chalk/interact/remove_item:
    tag @s remove coc.has_item
    as @e[type=item,tag=coc.chalk_item,distance=..0.5,limit=1] function ./chalk/interact/remove_item_data:
        ride @s dismount
        tag @s remove coc.chalk_item
        data merge entity @s {Age:0s,PickupDelay:10s,Motion:[0d,0.25d,0d], Invulnerable:0b, Air:0b}
        tag @s add coc.return_item
        schedule function coc:global/air_toggle_items 1t

append function ./chalk/interact/swap_item:
    function ./chalk/interact/remove_item
    function ./chalk/interact/add_item

append function ./chalk/interact/activation:
    scoreboard players set $x coc.dummy 0
    scoreboard players set $z coc.dummy 0
    data modify storage coc:temp chalk set value []

    cellX = Scoreboard("coc.x")["@s"]
    cellZ = Scoreboard("coc.z")["@s"]

    execute function ./chalk/interact/resolve:
        tag @s add coc.checked
        if entity @s[tag=coc.dot]:
            tempStorage.chalk.append({type: 'dot', x: 0, z: 0})
        
        ItemCircle.resolve()
        OutputCircle.resolve()

                
        tempStorage.chalk[-1].x = dummy["$x"]
        tempStorage.chalk[-1].z = dummy["$z"]

        cellX = dummy["$x"]
        cellZ = dummy["$z"]

        for pos in [(-1, 0), (1, 0), (0, -1), (0, 1)]:
            positioned f"~{pos[0]} ~ ~{pos[1]}" if entity @e[type=item_display,tag=coc.chalk,distance=..0.5,limit=1]:
                if pos[0] >= 0:
                    dummy["$x"] = cellX + pos[0]
                else:
                    dummy["$x"] = cellX - abs(pos[0])

                if pos[1] >= 0:
                    dummy["$z"] = cellZ + pos[1]
                else:
                    dummy["$z"] = cellZ - abs(pos[1])
                    
                as @e[type=item_display, tag=coc.chalk, distance=..0.5, tag=!coc.checked, limit=1] at @s function ./chalk/interact/resolve

    tempStorage.originalChalk = tempStorage.chalk
    scoreboard players set $passed coc.dummy 0

    scoreboard players set $mode coc.dummy 0
    execute function ./chalk/interact/try:
        function #coc:ritual/run

        if score $passed coc.dummy matches 1 as @e[type=item_display,tag=coc.checked,tag=coc.has_item] function ./chalk/interact/remove_consumed:
            tag @s remove coc.has_item
            on passengers if entity @s[type=item] kill @s

    for mode, name, multi in zip(range(1, 4), MIRROR_NAMES[1:], MIRROR_MULTIS[1:]):
        if score $passed coc.dummy matches 0 function (./chalk/interact/try_ + name):
            scoreboard players set $mode coc.dummy mode
            tempStorage.tempChalk = tempStorage.originalChalk
            tempStorage.chalk = []
            execute function (./chalk/interact/ + name):
                tempStorage.chalk.append(tempStorage.tempChalk[-1])
                tempStorage.tempChalk[-1].remove()

                if multi[0] == -1:
                    tempStorage.chalk[-1].x = tempStorage.chalk[-1].x * -1
                if multi[1] == -1:
                    tempStorage.chalk[-1].z = tempStorage.chalk[-1].z * -1

                if data storage coc:temp tempChalk[] function (./chalk/interact/ + name)

            function ./chalk/interact/try
        

    tag @e remove coc.checked


append function ./chalk/update_lines:
    scoreboard players set @s coc.dummy 4260000
    tag @s add coc.checked
    for idx, pos in zip(range(4), ["~-1 ~ ~", "~1 ~ ~", "~ ~ ~-1", "~ ~ ~1"]):
        positioned pos if entity @e[type=item_display,tag=coc.chalk,distance=..0.5,limit=1]:
            scoreboard players add @s coc.dummy pow(2, idx)
            as @e[type=item_display, tag=coc.chalk, distance=..0.5, tag=!coc.checked, limit=1] at @s function ./chalk/update_lines

    if entity @s[tag=coc.dot] store result entity @s item.tag.CustomModelData int 1 scoreboard players get @s coc.dummy

for i in range(16):
    merge model f"coc:block/chalk/dot/{i}" {
        "credit": "Made with Blockbench",
        "textures": {
            "0": f"coc:block/chalk/dot/{i}",
            "particle": f"coc:block/chalk/dot/{i}"
        },
        "parent": "coc:block/chalk/mark"
    }