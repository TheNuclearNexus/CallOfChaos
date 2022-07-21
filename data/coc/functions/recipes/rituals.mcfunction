from contextlib import contextmanager

@contextmanager
def ritual(name, ingredients, counts):
    # print(name,ingredients,counts,loot)
    if score $suc coc.dummy matches 0 if data storage coc:temp {Items:ingredients} function f'coc:recipes/rituals/{name}':
        scoreboard players set $validIngredients coc.dummy 0
        for idx in range(len(ingredients)):
            ingredient = ingredients[idx]
            store result score f'${idx}' coc.dummy if data storage coc:temp f'Items[{ingredient}]'
            if score f'${idx}' coc.dummy matches counts[idx] scoreboard players add $validIngredients coc.dummy 1
        if score $validIngredients coc.dummy matches len(ingredients) function f'coc:recipes/rituals/{name}/matched':
            yield

if entity @s[tag=!coc.has_contract] if data storage coc:temp Items[{id:"minecraft:writable_book"}] function ./rituals/contract:
    scoreboard players set $suc coc.dummy 1
    function ../../entity/natural_rift/contract/generate

with ritual(
    name='chaos_flame', 
    ingredients=[{'id':"minecraft:blaze_powder"},{'id':"minecraft:furnace",'tag':{smithed:{'id': "coc:offering_altar"}}}],
    counts=[1,1]):
    scoreboard players set $suc coc.dummy 1
    loot spawn ~ ~ ~ loot coc:item/chaos_flame
    
    
    