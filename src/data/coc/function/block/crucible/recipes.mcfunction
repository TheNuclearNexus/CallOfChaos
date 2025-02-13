
CUSTOM_DATA = 'components."minecraft:custom_data"'

function ./reset:
    scoreboard players set @s coc.dummy 0
    data modify storage coc:temp crucible.progress set value "solid"

function ./validate_drop:
    $execute unless data storage coc:temp crucible.recipe."$(progress)"."$(new_item)" run return 0

    $data modify storage coc:temp new_recipe set from storage coc:temp crucible.recipe."$(progress)"."$(new_item)"
    
    data remove storage coc:temp crucible.new_item
    
    function ./reset

    data modify storage coc:temp crucible.recipe set from storage coc:temp new_recipe
    data modify entity @s f"item.{CUSTOM_DATA}.coc.crucible" set from storage coc:temp crucible

    return 1
 

function ./validate_infusion:
    $execute unless data storage coc:temp crucible.recipe."$(progress)"."$(new_item)" run return 0
    $execute if data storage coc:temp crucible.recipe."$(progress)"."$(new_item)"{} run return 0
    $data modify storage coc:temp function set from storage coc:temp crucible.recipe."$(progress)"."$(new_item)"
    execute function ~/give with storage coc:temp {}:
        $function $(function)

    function ./reset

    data remove storage coc:temp crucible.recipe 
    data modify entity @s f"item.{CUSTOM_DATA}.coc.crucible" set from storage coc:temp crucible

    return 1