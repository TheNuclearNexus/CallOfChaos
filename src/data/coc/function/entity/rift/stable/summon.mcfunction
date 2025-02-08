from ../default import create_rift

NETWORK_INFO = "item.components.\"minecraft:custom_data\".coc.network_info"

create_rift(["coc.rift.stable"])

as @n[tag=coc.rift.stable] function ~/../setup:
    function gu:generate

    store result storage coc:temp network_id int 1 scoreboard players get @s coc.rift_id
    data modify storage coc:temp network_uuid set from storage gu:main out

    data modify entity @s f"{NETWORK_INFO}.network_id" set from storage coc:temp network_id
    data modify entity @s f"{NETWORK_INFO}.uuid" set from storage gu:main out

    function coc:energy/api/create_network with storage coc:temp {}
