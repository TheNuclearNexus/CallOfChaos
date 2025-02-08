
$data modify storage coc:temp radius set value $(radius)

store result storage coc:temp network_id int 1 scoreboard players get @n[tag=coc.rift.stable] coc.rift_id

align xyz positioned ~.5 ~ ~.5 summon armor_stand function ~/setup:
    data merge entity @s {Tags: ["debug_bubble"], CustomName: '{"text": "Bubble"}', Marker: 1b, NoGravity: 1b}

    data modify storage coc:temp pos set from entity @s Pos
    store result storage coc:temp x int 1 data get storage coc:temp pos[0] 
    store result storage coc:temp y int 1 data get storage coc:temp pos[1] 
    store result storage coc:temp z int 1 data get storage coc:temp pos[2] 

    data modify storage coc:temp transfer set value 16

    function gu:generate
    data modify storage coc:temp bubble_uuid set from storage gu:main out

    summon item_display ~ ~ ~ {
        item: {
            id: "minecraft:stick", 
            components: {
                "minecraft:item_model": "coc:entity/rift_circle"
            }
        },
        item_display: "fixed",
        Tags: ["debug_bubble_display"],
        teleport_duration: 60
    }

    data modify storage coc:temp transformation set value {
        translation: [0,0,0],
        scale: [1,1,1],
        left_rotation: [0,0,0,1],
        right_rotation: [0,0,0,1]
    }

    store result storage coc:temp transformation.scale[0] int 2 data get storage coc:temp radius
    store result storage coc:temp transformation.scale[2] int 2 data get storage coc:temp radius

    as @n[type=item_display] function ~/../setup_circle:
        data modify entity @s transformation set from storage coc:temp transformation
        ride @s mount @n[tag=debug_bubble]
    function ./../api/add_bubble with storage coc:temp {}

    execute function ~/../set_radius with storage coc:temp {}:
        $data modify storage coc:energy networks[].bubbles[{uuid: "$(bubble_uuid)"}].radius set from storage coc:temp radius