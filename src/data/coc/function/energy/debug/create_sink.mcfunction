
unless function ./../api/get_bubble return run tellraw @s {"text": "You aren't inside of a bubble", "color": "red"}

execute summon item_display function ~/setup:
    data merge entity @s {
        Tags: ["debug_sink", "coc.energy.sink"],
        Marker: 1b,
        NoGravity: 1b,
        Small: 1b,
        item: {
            id: "minecraft:observer"
        }
    }
    
    function ./../api/sink/register with storage coc:temp {}