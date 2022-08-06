from ../api import interact
interact('entropic_accelerator')

tag @s add coc.activator
anchored eyes function ./raycast:
    if block ^ ^ ^0.01 minecraft:furnace{Lock:"\\uf001coc.entropic_accelerator"} positioned ^ ^ ^0.01 align xyz as @e[type=armor_stand,tag=coc.entropic_accelerator,dx=0] at @s function ./activate

    if entity @s[distance=..5] unless block ^ ^ ^0.01 minecraft:furnace{Lock:"\\uf001coc.entropic_accelerator"} positioned ^ ^ ^0.01 run function ./raycast

tag @s remove coc.activator


