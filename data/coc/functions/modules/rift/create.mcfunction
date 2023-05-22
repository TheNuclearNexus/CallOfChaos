from bolt_expressions import Scoreboard
from ../relation_stack import create, add

rift_id = Scoreboard("coc.rift_id")

align xyz positioned ~0.5 ~1 ~0.5 summon item_display function ./rift/create/_item_display:
    data merge entity @s {item:{id:"minecraft:snowball",Count:1,tag:{CustomModelData:4260002,ritual:{items:[]}}},billboard: "center", transformation: {translation:[0f,1f,0f],left_rotation:[0f,0f,0f,1f],scale:[1f,1f,1f],right_rotation:[0f,0f,0f,1f]}}
    tag @s add coc.rift
    tag @s add coc.to_push

    rift_id["$total"] += 1
    rift_id["@s"] = rift_id["$total"]

    # Create a unique relation stack for this rift
    # and add the rift to it so we can iterate only
    # on the stack and cut down @e's
    with create():
        tag @s add coc.rift_stack
        add("@e[type=item_display,tag=coc.to_push,tag=coc.rift,limit=1]")
    tag @s remove coc.to_push

    # Create an interaction entity that encompasses the rift
    execute summon interaction function ./rift/create/_interaction:
        data merge entity @s {width:1, height: 2, Tags:["coc.rift_interaction"]}
        ride @s mount @e[type=item_display,distance=..0.1,tag=coc.rift,limit=1]
