
unless function ./../api/get_bubble return run tellraw @s {"text": "You aren't not inside of a bubble", "color": "red"}

execute summon armor_stand function ~/setup:
    data merge entity @s {
        Tags: ["debug_sink"],
        Marker: 1b,
        NoGravity: 1b,
        Small: 1b
    }

    function gu:generate

    data modify storage coc:temp sink_uuid set from storage gu:main out

    function ./../api/add_sink with storage coc:temp {}