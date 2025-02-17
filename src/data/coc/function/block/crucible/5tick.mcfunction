from ./recipes import STAGE_DURATION, CHECKED_TAG


CUSTOM_DATA = 'components."minecraft:custom_data"'

ITEM = @e[type=item,distance=..0.5,tag=!CHECKED_TAG]

if items block ~ ~ ~ container.* * function ./return_items 

align xyz positioned ~.5 ~.5 ~.5 if entity ITEM function ~/check:
    data remove storage coc:temp crucible
    data modify storage coc:temp crucible set from entity @s f"item.{CUSTOM_DATA}.coc.crucible" 
    unless data storage coc:temp crucible.recipe:
        data modify storage coc:temp crucible.progress set value "solid"
        data modify storage coc:temp crucible.recipe set from storage coc:crucible recipes


    as (ITEM | @s[limit=1]) function ~/tag:
        tag @s add CHECKED_TAG
        tag @s add coc.crucible.pending

        data modify storage coc:temp item set from entity @s Item
        data modify storage coc:temp crucible.new_item set from storage coc:temp item.id

        if data storage coc:temp f"item.{CUSTOM_DATA}.smithed.id":
            data modify storage coc:temp crucible.new_item set from storage coc:temp f"item.{CUSTOM_DATA}.smithed.id"

    store result score #temp coc.dummy function ./validate_drop with storage coc:temp crucible
    if score #temp coc.dummy matches 1 function ~/../success:
        kill @e[tag=coc.crucible.pending,distance=..1]

        on passengers kill @s

        execute summon item_display function ~/../add_item_display:
            tag @s add coc.crucible.item
            tag @s add coc.no_animation
            ride @s mount @n[type=item_display, tag=coc.crucible]

            data modify entity @s item set from storage coc:temp item

            data merge entity @s {
                item_display: "ground",
                transformation: {
                    translation: [0f, 0.25f, 0f],
                    left_rotation: [0f,1f,0f,0f],
                    right_rotation: [0f,0f,0f,1f],
                    scale: [1f, 1f, 1f]
                }
            } 

            store result entity @s Rotation[0] float 1 random value 0..360

            schedule function ~/animate 1t:
                as @e[type=item_display, tag=coc.no_animation] data merge entity @s {
                    transformation: {
                        translation: [0f, 0f, 0f],
                        left_rotation: [0f,0f,0f,1f],
                        right_rotation: [0f,0f,0f,1f],
                        scale: [0f, 0f, 0f]
                    },
                    interpolation_duration: (STAGE_DURATION),
                    start_interpolation: 0
                }
                tag @e[type=item_display] remove coc.no_animation




    tag @e remove coc.crucible.pending

