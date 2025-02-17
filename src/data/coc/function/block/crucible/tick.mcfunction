from ./recipes import STAGE_DURATION, ACTIVE_TAG

unless score @s coc.powered matches 1 return 0

CUSTOM_DATA = 'components."minecraft:custom_data"'
CRUCIBLE_DATA = f'item.{CUSTOM_DATA}.coc.crucible'

PROGRESS: list[str] = [
    "solid",
    "coagulated",
    "liquid",
    "boiling",
    "evaporated"
]

unless entity @s[tag=ACTIVE_TAG] return 0   

data remove storage coc:temp crucible
data modify storage coc:temp crucible set from entity @s CRUCIBLE_DATA


if items block ~ ~ ~ container.* * function ~/handle_droppers:
    data modify storage coc:temp crucible.new_item set from block ~ ~ ~ Items[0].id
    data modify storage coc:temp crucible.new_item set from block ~ ~ ~ f"Items[0].{CUSTOM_DATA}.smithed.id"

    store result score #temp coc.dummy function ~/validate:
        if block ~1 ~ ~ minecraft:dropper[triggered=true] positioned ~-0.75 ~ ~ return:
            function ./validate_infusion with storage coc:temp crucible

        if block ~-1 ~ ~ minecraft:dropper[triggered=true] positioned ~0.75 ~ ~ return:
            function ./validate_infusion with storage coc:temp crucible
        
        if block ~ ~ ~1 minecraft:dropper[triggered=true] positioned ~ ~ ~-0.75 return:
            function ./validate_infusion with storage coc:temp crucible
        
        if block ~ ~ ~-1 minecraft:dropper[triggered=true] positioned ~ ~ ~0.75 return:
            function ./validate_infusion with storage coc:temp crucible

        positioned ~0.75 ~ ~ return:
            function ./validate_infusion with storage coc:temp crucible

    if score #temp coc.dummy matches 1:
        store result score #count coc.dummy data get block ~ ~ ~ Items[0].count
        store result block ~ ~ ~ Items[0].count int 1 scoreboard players remove #count coc.dummy 1
        if score #count coc.dummy matches 0 data remove block ~ ~ ~ Items[0] 

    if items block ~ ~ ~ container.* * function ./return_items

scoreboard players add @s coc.dummy 1

if score @s coc.dummy matches (STAGE_DURATION, None) function ~/next_stage:
    scoreboard players set @s coc.dummy 0
    for i in range(len(PROGRESS) - 1):
        if data storage coc:temp crucible{progress: PROGRESS[i]}:
            return run data modify storage coc:temp crucible.progress set value PROGRESS[i + 1]
    
    if data storage coc:temp crucible{progress: PROGRESS[-1]}:
        function ./reset
        data remove storage coc:temp crucible.recipe

data modify entity @s CRUCIBLE_DATA set from storage coc:temp crucible