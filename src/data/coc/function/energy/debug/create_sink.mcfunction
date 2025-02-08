
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

    function gu:generate

    data modify storage coc:temp sink_uuid set from storage gu:main out

    function ./../api/add_sink with storage coc:temp {}