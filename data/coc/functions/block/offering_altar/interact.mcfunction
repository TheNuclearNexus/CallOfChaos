from coc:block/api import interact
interact('offering_altar')

data remove storage coc:temp Item
data modify storage coc:temp Item set from entity @s SelectedItem

tag @s add coc.activator
anchored eyes function ./raycast:
    if block ^ ^ ^0.01 minecraft:furnace{Lock:"\\uf001coc.offering_altar"} positioned ^ ^ ^0.01 align xyz run function ./at_block:
        unless predicate coc:player/sneaking function ./insert_item
        if predicate coc:player/sneaking function ./activate
    if entity @s[distance=..5] unless block ^ ^ ^0.01 minecraft:furnace{Lock:"\\uf001coc.offering_altar"} positioned ^ ^ ^0.01 run function ./raycast

tag @s remove coc.activator
