
as @n[tag=debug_sink] function ~/delete:
    function gu:generate

    data modify storage coc:temp sink_uuid set from storage gu:main out

    function ./../api/destroy_sink with storage coc:temp {}

    on passengers kill @s
    kill @s