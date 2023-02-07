from bolt_expressions import Scoreboard

dummy = Scoreboard("coc.dummy")

unless block ~ ~ ~ small_amethyst_bud function ./break:
    positioned ~ ~-1 ~ kill @e[type=armor_stand,tag=coc.crystalizer.block,distance=..0.5]
    kill @e[type=item,nbt={Item:{id:"minecraft:small_amethyst_bud"},Age:0s},distance=..3]
    scoreboard players operation $count coc.dummy = @s coc.dummy

    if entity @s[tag=coc.diamond] loot spawn ~ ~ ~ loot coc:set_item/diamond
    if entity @s[tag=coc.emerald] loot spawn ~ ~ ~ loot coc:set_item/emerald
    if entity @s[tag=coc.redstone] function ./multiply/redstone:
        dummy["$count"] *= 4
        loot spawn ~ ~ ~ loot coc:set_item/redstone
    if entity @s[tag=coc.lapis] function ./multiply/lapis:
        dummy["$count"] *= 6
        loot spawn ~ ~ ~ loot coc:set_item/lapis
    if entity @s[tag=coc.quartz] loot spawn ~ ~ ~ loot coc:set_item/quartz
    if entity @s[tag=coc.chaos] loot spawn ~ ~ ~ loot coc:set_item/chaos_crystal

    kill @s