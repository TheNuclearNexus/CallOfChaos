unless score @s coc.powered matches 1 return 0

CUSTOM_DATA = 'components."minecraft:custom_data"'
CRUCIBLE_DATA = f'item.{CUSTOM_DATA}.coc.crucible'
STAGE_DURATION = 300

PROGRESS: list[str] = [
    "solid",
    "coagulated",
    "liquid",
    "boiling",
    "evaporated"
]


data remove storage coc:temp crucible
data modify storage coc:temp crucible set from entity @s CRUCIBLE_DATA

unless data storage coc:temp crucible.recipe return 0

if items block ~ ~ ~ container.* * function ~/handle_droppers:
    data modify storage coc:temp crucible.new_item set from block ~ ~ ~ Items[0].id
    data modify storage coc:temp crucible.new_item set from block ~ ~ ~ f"Items[0].{CUSTOM_DATA}.smithed.id"

    execute store result score #temp coc.dummy function ~/validate:
        say validate
        if block ~1 ~ ~ minecraft:dropper[triggered=true] positioned ~-1 ~ ~ return:
            say ~1 ~ ~
            return run function ./validate_interact with storage coc:temp

        if block ~-1 ~ ~ minecraft:dropper[triggered=true] positioned ~1 ~ ~ return:
            say ~-1 ~ ~ 
            return run function ./validate_interact with storage coc:temp
        
        if block ~ ~ ~1 minecraft:dropper[triggered=true] positioned ~ ~ ~-1 return:
            say ~ ~ ~1
            return run function ./validate_interact with storage coc:temp
        
        if block ~ ~ ~-1 minecraft:dropper[triggered=true] positioned ~ ~ ~1 return:
            say ~ ~ ~-1
            return run function ./validate_interact with storage coc:temp

        positioned ~1 ~ ~ return:
            function ./validate_interact with storage coc:temp

    if score #temp coc.dummy matches 1 return:
        store result block ~ ~ ~ Items[0].count int 1 data get block ~ ~ ~ Items[0].count 0.9999999

    if data block ~ ~ ~ Items[] function ~/return_items:
        summon item ~ ~ ~ {Item:{id:"minecraft:stone", count: 1}}
        data modify entity @n[type=item,nbt={Age:0s}] Item set from block ~ ~ ~ Items[-1]
        data remove block ~ ~ ~ Items[-1]

        if data block ~ ~ ~ Items[] function ~/
        

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