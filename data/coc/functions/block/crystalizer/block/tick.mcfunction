from ../activate import baseBlocks
for b in baseBlocks:
    if entity @s[tag=f'coc.{b}'] unless block ~ ~ ~ f'minecraft:{b}' kill @s