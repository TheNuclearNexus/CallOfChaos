ENERGY_DATA = 'item.components."minecraft:custom_data".coc.energy'

unless function ./../get_bubble return fail

function gu:generate

data modify storage coc:temp sink_uuid set from storage gu:main out
data modify entity @s f'{ENERGY_DATA}.uuid' set from storage gu:main out

data modify entity @s f'{ENERGY_DATA}.bubble_uuid' set from storage coc:temp bubble_uuid

function ./../add_sink with storage coc:temp {}

function ./sync_storage with entity @s ENERGY_DATA

return 1