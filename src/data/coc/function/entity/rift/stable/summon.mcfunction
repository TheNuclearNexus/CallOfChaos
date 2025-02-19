from ../default import create_rift

NETWORK_INFO = "item.components.\"minecraft:custom_data\".coc.network_info"

create_rift(["coc.rift.stable"])

as @n[tag=coc.rift.stable] function ~/../setup:
    function coc:energy/api/network/register
