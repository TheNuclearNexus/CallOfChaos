as @e[type=item] if items entity @s contents *[custom_data~{coc:{rift_mob:1b}}] function ~/handle_kill:
    as @n[type=item_display,tag=coc.rift.wild] function ./directors/wave/increase_points
    kill @s

if entity @e[tag=coc.rift.wild,limit=1] schedule function ~/ 1t replace