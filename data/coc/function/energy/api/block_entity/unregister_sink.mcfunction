
ENERGY_DATA = 'item.components."minecraft:custom_data".coc.energy'

unless data entity @s f"{ENERGY_DATA}.bubble_uuid" return 0

data modify storage coc:temp sink_uuid set from entity @s f"{ENERGY_DATA}.uuid"

function ./../remove_sink with storage coc:temp {} 