
append function coc:technical/load:
    data modify storage coc:crucible recipes set value {
        "solid": {
            "coc:ichor": {
                "coagulated": {
                    "minecraft:redstone": {
                        "coagulated": {
                            "minecraft:tinted_glass": (./test)
                        }
                    }
                }
            }
        }
    }

function ./test:
    say ran

CUSTOM_DATA = 'components."minecraft:custom_data"'

ITEM = @e[type=item,distance=..0.5,tag=!coc.crucible.checked]

   

align xyz positioned ~.5 ~.5 ~.5 if entity ITEM function ~/check:
    data remove storage coc:temp crucible
    data modify storage coc:temp crucible set from entity @s f"item.{CUSTOM_DATA}.coc.crucible" 
    unless data storage coc:temp crucible.recipe:
        data modify storage coc:temp crucible.progress set value "solid"
        data modify storage coc:temp crucible.recipe set from storage coc:crucible recipes


    as (ITEM | @s[limit=1]) function ~/tag:
        tag @s add coc.crucible.checked
        tag @s add coc.crucible.pending

        data modify storage coc:temp crucible.new_item set from entity @s Item.id

        if data entity @s f"Item.{CUSTOM_DATA}.smithed.id":
            data modify storage coc:temp crucible.new_item set from entity @s f"Item.{CUSTOM_DATA}.smithed.id"

    store result score #temp coc.dummy function ./validate_drop with storage coc:temp crucible
    if score #temp coc.dummy matches 1:
        kill @e[tag=coc.crucible.pending,distance=..1]


