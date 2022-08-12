if score @s coc.refresh_knowledge matches 1.. function ./refresh_knowledge:
    scoreboard players reset @s coc.refresh_knowledge

    scoreboard players operation $id coc.pact_id = @s coc.pact_id
    scoreboard players set $lvl coc.relation.lvl -1
    as @e[type=armor_stand,tag=coc.natural_rift] if score @s coc.pact_id = $id coc.pact_id scoreboard players operation $lvl coc.relation.lvl = @s coc.relation.lvl
    if score $lvl coc.relation.lvl matches 0.. function ../natural_rift/relation/give_advancements
    tellraw @s {"translate":"text.coc.refresh_knowledge","color": "gray"}


scoreboard players enable @s coc.refresh_knowledge