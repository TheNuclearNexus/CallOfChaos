
def add_to_stack():
    summon item ~ ~ ~ {Tags:["coc.entry", "coc.unassigned"],Item:{id: "minecraft:diamond_sword", Count: 1},PickupDelay:32765}
    ride @e[type=item,tag=coc.unassigned,dx=0,limit=1] mount @s
    on passengers function ./finialize:
        tag @s remove coc.unassigned
        data modify entity @s Thrower set from entity @e[sort=random,limit=1] UUID

function ./create_stack:
    execute summon item_display:
        tag @s add coc.create_stack
        add_to_stack()
        on passengers:
            add_to_stack()
        
function ./iterate_stack:
    on passengers function ./iterate_stack/iter:
        on origin say I'm the value
        on vehicle say I'm the previous node
        on passengers say I'm the next node
        on passengers if entity @s function ./iterate_stack/iter

function ./pop:
    on passengers store result score $test coc.dummy if entity @s function ./pop
    if score $test coc.dummy matches 0 kill @s