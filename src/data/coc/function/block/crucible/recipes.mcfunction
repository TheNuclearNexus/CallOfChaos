
from nbtlib import Compound

# -------------------------------
# System Constants
# -------------------------------
STAGE_DURATION = 300
ACTIVE_TAG = "coc.has_recipe"
CHECKED_TAG = "coc.crucible.checked"

# -------------------------------
# Score Constants
# -------------------------------
set_const(3)
set_const(256)
set_const(65536)

# -------------------------------
# Common Implementation Utilities
# -------------------------------
CUSTOM_DATA = 'components."minecraft:custom_data"'

function ./reset:
    tag @s remove ACTIVE_TAG
    data modify entity @s item.components."minecraft:custom_model_data" merge value {strings: [], colors: []}
    on passengers kill @s
    function ./reset_progress

function ./reset_progress:
    scoreboard players set @s coc.dummy 0
    data modify storage coc:temp crucible.progress set value "solid"

function ./calculate_color:
    scoreboard players set #color coc.dummy 0
    data modify storage coc:temp colors set from storage coc:temp crucible.colors

    store result score #length coc.dummy if data storage coc:temp colors[]
    scoreboard players operation #length coc.dummy /= #3 coc.const

    scoreboard players set #r coc.dummy 0
    scoreboard players set #g coc.dummy 0
    scoreboard players set #b coc.dummy 0

    execute function ~/iter:
        store result score #temp coc.dummy data get storage coc:temp colors[-3]
        scoreboard players operation #r coc.dummy += #temp coc.dummy 

        store result score #temp coc.dummy data get storage coc:temp colors[-2]
        scoreboard players operation #g coc.dummy += #temp coc.dummy 
        
        store result score #temp coc.dummy data get storage coc:temp colors[-1]
        scoreboard players operation #b coc.dummy += #temp coc.dummy 

        data remove storage coc:temp colors[-1]
        data remove storage coc:temp colors[-1]
        data remove storage coc:temp colors[-1]
        if data storage coc:temp colors[] function ~/

    scoreboard players operation #r coc.dummy /= #length coc.dummy
    scoreboard players operation #g coc.dummy /= #length coc.dummy
    scoreboard players operation #b coc.dummy /= #length coc.dummy

    scoreboard players operation #r coc.dummy *= #65536 coc.const
    scoreboard players operation #g coc.dummy *= #256 coc.const
    
    scoreboard players operation #color coc.dummy += #r coc.dummy
    scoreboard players operation #color coc.dummy += #g coc.dummy
    scoreboard players operation #color coc.dummy += #b coc.dummy

    data modify entity @s item.components."minecraft:custom_model_data".colors set value [0]
    store result entity @s item.components."minecraft:custom_model_data".colors[0] int 1 scoreboard players get #color coc.dummy


function ./validate_drop:
    $execute unless data storage coc:temp crucible.recipe."$(progress)"."$(new_item)" run return 0

    $data modify storage coc:temp new_recipe set from storage coc:temp crucible.recipe."$(progress)"."$(new_item)"
    
    data remove storage coc:temp crucible.new_item
    
    function ./reset_progress

    data remove storage coc:temp color
    $data modify storage coc:temp color set from storage coc:crucible colors."$(new_item)"

    if data storage coc:temp color function ~/update_color:
        data modify storage coc:temp crucible.colors append from storage coc:temp color[]
        function ./calculate_color

    data modify storage coc:temp crucible.recipe set from storage coc:temp new_recipe
    data modify entity @s f"item.{CUSTOM_DATA}.coc.crucible" set from storage coc:temp crucible

    tag @s add ACTIVE_TAG
    data modify entity @s item.components."minecraft:custom_model_data".strings set value ["fluid"]

    return 1
 

function ./validate_infusion:
    $execute unless data storage coc:temp crucible.recipe."$(progress)"."$(new_item)" run return 0
    $execute if data storage coc:temp crucible.recipe."$(progress)"."$(new_item)"{} run return 0
    $data modify storage coc:temp function set from storage coc:temp crucible.recipe."$(progress)"."$(new_item)"
    execute function ~/give with storage coc:temp {}:
        $$(function)

    function ./reset

    data remove storage coc:temp crucible.recipe 
    data remove storage coc:temp crucible.new_item

    data modify entity @s f"item.{CUSTOM_DATA}.coc.crucible" set from storage coc:temp crucible

    return 1