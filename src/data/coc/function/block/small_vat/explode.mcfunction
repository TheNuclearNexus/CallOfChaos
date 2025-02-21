setblock ~ ~ ~ minecraft:air
function ./break
kill @s

particle minecraft:explosion ~ ~1 ~ 0.5 1 0.5 0 5
particle minecraft:reverse_portal ~ ~1 ~ 0 0.5 0 25 100

playsound minecraft:entity.dragon_fireball.explode block @a ~ ~ ~ 1 2
