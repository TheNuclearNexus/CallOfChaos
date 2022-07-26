from contextlib import contextmanager
from coc:entity/natural_rift/relation/check_level_up import levelRequirements
@contextmanager
def ritual(name, ingredients, counts, level=0):
    # print(name,ingredients,counts,loot)
    if score $suc coc.dummy matches 0 if score @s coc.relation.lvl matches f'{level}..' if data storage coc:temp {Items:ingredients} function f'coc:recipes/rituals/{name}':
        scoreboard players set $validIngredients coc.dummy 0
        for idx in range(len(ingredients)):
            ingredient = ingredients[idx]
            store result score f'${idx}' coc.dummy if data storage coc:temp f'Items[{ingredient}]'
            if score f'${idx}' coc.dummy matches counts[idx] scoreboard players add $validIngredients coc.dummy 1
        if score $validIngredients coc.dummy matches len(ingredients) function f'coc:recipes/rituals/{name}/matched':
            yield
            # if entity @s[tag=!f'coc.{name}'] scoreboard players set $xp coc.dummy 1
            # tag @s add f'coc.{name}'
if entity @s[tag=!coc.has_contract] if data storage coc:temp Items[{id:"minecraft:writable_book"}] function ./rituals/contract:
    scoreboard players set $suc coc.dummy 1
    playsound minecraft:entity.wither.spawn master @a ~ ~ ~ 0.5 2
    playsound minecraft:block.beacon.power_select master @a ~ ~ ~ 1 1.3
    playsound minecraft:entity.ender_dragon.ambient master @a ~ ~ ~ 1 1

    scoreboard players operation $id coc.dummy = @s coc.pact_id
    as @a if score @s coc.pact_id = $id coc.dummy tellraw @s {"translate":"text.coc.natural_rift.contract.start","color":"gray"}

    function ../../entity/natural_rift/contract/generate


with ritual(
    name='binding', 
    level=2,
    ingredients=[{'id':"minecraft:potion",'tag':{smithed:{'id': "coc:blood_vial"}}}],
    counts=[2]):
    
    store result score $playerA coc.dummy data get storage coc:temp Items[0].tag.coc.player
    as @a[distance=..16] if score @s coc.player_id = $playerA coc.dummy tag @s add coc.player.a
    store result score $playerB coc.dummy data get storage coc:temp Items[1].tag.coc.player
    as @a[distance=..16] if score @s coc.player_id = $playerB coc.dummy tag @s add coc.player.b

    scoreboard players operation $pactId coc.dummy = @s coc.pact_id
    scoreboard players operation $lvl coc.relation.lvl = @s coc.relation.lvl

    unless score $playerA coc.dummy = $playerB coc.dummy if entity @p[tag=coc.player.a] if entity @p[tag=coc.player.b] function ./rituals/binding/start:
        if score @p[tag=coc.player.a] coc.pact_id = $pactId coc.dummy:
            unless score @p[tag=coc.player.b] coc.pact_id = $pactId coc.dummy:
                scoreboard players operation @p[tag=coc.player.b] coc.pact_id = $pactId coc.dummy
                execute function ./rituals/binding/setup:
                    scoreboard players add @s coc.pact_members 1
                    scoreboard players set $suc coc.dummy 1
                    for lvl in range(len(levelRequirements)):
                        if score $lvl coc.relation.lvl matches f'{lvl+1}..' advancement grant @s only f'coc:main/level{lvl+1}'
        unless score @p[tag=coc.player.a] coc.pact_id = $pactId coc.dummy:
            if score @p[tag=coc.player.b] coc.pact_id = $pactId coc.dummy:
                scoreboard players operation @p[tag=coc.player.a] coc.pact_id = $pactId coc.dummy
                function ./rituals/binding/setup
    
    tag @a remove coc.player.a
    tag @a remove coc.player.b

with ritual(
    name='eternal_burner', 
    level=2,
    ingredients=[{'id':"minecraft:blaze_powder"},{'id':"minecraft:furnace",'tag':{smithed:{'id': "coc:offering_altar"}}}],
    counts=[1,1]):
    scoreboard players set $suc coc.dummy 1
    loot spawn ~ ~ ~ loot coc:item/eternal_burner
    
with ritual(
    name='blightsight_goggles', 
    level=2,
    ingredients=[{'id':"minecraft:tinted_glass"},{'id':"minecraft:structure_block",'tag':{smithed:{'id': "coc:blight_steel"}}}],
    counts=[1,1]):
    scoreboard players set $suc coc.dummy 1
    loot spawn ~ ~ ~ loot coc:item/blightsight_goggles

with ritual(
    name='focusing_crystal', 
    level=2,
    ingredients=[{'id':"minecraft:diamond"},{'id':"minecraft:structure_block",'tag':{smithed:{'id': "coc:chaos_crystal"}}}],
    counts=[1,1]):
    scoreboard players set $suc coc.dummy 1
    loot spawn ~ ~ ~ loot coc:item/focusing_crystal

with ritual(
    name='flow_tier1', 
    level=2,
    ingredients=[{'id':"minecraft:coal_block"},{'id':"minecraft:structure_block",'tag':{smithed:{'id': "coc:chaos_crystal"}}}],
    counts=[1,1]):
    scoreboard players set $suc coc.dummy 1
    scoreboard players add @s coc.rift.flow (3*60*4)

with ritual(
    name='gathering_lantern', 
    level=3,
    ingredients=[{'id':"minecraft:glass"},{'id':"minecraft:structure_block",'tag':{smithed:{'id': "coc:chaos_crystal"}}},{'id':"minecraft:structure_block",'tag':{smithed:{'id': "coc:blight_steel"}}}],
    counts=[1,1,1]):
    scoreboard players set $suc coc.dummy 1
    loot spawn ~ ~ ~ loot coc:item/gathering_lantern

with ritual(
    name='entropic_lens', 
    level=3,
    ingredients=[{'id':"minecraft:ender_pearl"},{'id':"minecraft:structure_block",'tag':{smithed:{'id': "coc:chaos_crystal"}}},{'id':"minecraft:glass_pane"}],
    counts=[1,1,1]):
    scoreboard players set $suc coc.dummy 1
    loot spawn ~ ~ ~ loot coc:item/entropic_lens


with ritual(
    name='crystaline_lens', 
    level=3,
    ingredients=[{'id':"minecraft:quartz"},{'id':"minecraft:structure_block",'tag':{smithed:{'id': "coc:chaos_crystal"}}},{'id':"minecraft:glass_pane"}],
    counts=[1,1,1]):
    scoreboard players set $suc coc.dummy 1
    loot spawn ~ ~ ~ loot coc:item/crystaline_lens