
data modify storage coc:temp bubbles set value []
# Fill bubbles with *all* registered bubbles 
data modify storage coc:temp bubbles append from storage coc:energy networks[].bubbles[]

function ~/check_distance:
    $execute positioned $(x) ~ $(z) if entity @s[distance=..$(radius)] at @s positioned ~-0.5 $(y) ~-0.5 positioned ~ ~-1 ~ if entity @s[dy=3] run summon marker ~ ~ ~ {Tags: ["coc.bubble.root"], data: {bubble_uuid: "$(uuid)"}}

execute function ~/iter:
    function ~/../check_distance with storage coc:temp bubbles[-1]
    data remove storage coc:temp bubbles[-1]

    if data storage coc:temp bubbles[] function ~/

data remove storage coc:temp bubble_uuid
as @n[type=marker, tag=coc.bubble.root] data modify storage coc:temp bubble_uuid set from entity @s data.bubble_uuid
kill @e[type=marker, tag=coc.bubble.root]

if data storage coc:temp bubble_uuid return 1
return fail