
store result storage coc:temp network_id int 1 scoreboard players get @n[tag=coc.rift.stable] coc.rift_id
as @n[tag=debug_bubble] function ~/delete:
    function gu:generate

    data modify storage coc:temp bubble_uuid set from storage gu:main out

    function ./../api/remove_bubble with storage coc:temp {}

    on passengers kill @s
    kill @s