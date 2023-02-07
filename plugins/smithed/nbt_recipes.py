from typing import Any

from beet import Context, Function
from nbtlib import Byte, Compound, List

from .custom_items import get_item


def serialize(data: Any) -> str:
    if(isinstance(data, str)):
        return f'"{data}"'
    if(isinstance(data, dict)):
        return dict_to_snbt(data)
    if(isinstance(data, list)):
        return list_to_snbt(data)
    if(isinstance(data, Byte)):
        return data.snbt()
    return str(data)
    
def list_to_snbt(list: Any) -> str:
    elements = []
    for i in list:
        elements.append(serialize(i))
    return "[" + ", ".join(elements) + "]"
def dict_to_snbt(dict: Any) -> str:
    key_pairs = []
    for k in dict:
        ser_data = serialize(dict[k])
        key_pairs.append(f"{k}: " + ser_data)
    return "{" + ", ".join(key_pairs) + "}"

shaped_recipes = []
def shaped_recipe(ctx: Context, namespace: str, recipe: Any):
    # Empty setup
    recipeItems = [
        [{"Slot": Byte(0), "id": "minecraft:air"}, {"Slot": Byte(1), "id": "minecraft:air"}, {"Slot": Byte(2), "id": "minecraft:air"}],
        [{"Slot": Byte(0), "id": "minecraft:air"}, {"Slot": Byte(1), "id": "minecraft:air"}, {"Slot": Byte(2), "id": "minecraft:air"}],
        [{"Slot": Byte(0), "id": "minecraft:air"}, {"Slot": Byte(1), "id": "minecraft:air"}, {"Slot": Byte(2), "id": "minecraft:air"}],
    ]
    
    pattern = recipe['pattern']
    key = recipe['key']
    
    # Convert the key to their recipe representation
    # to make building the pattern easier
    for k in key:
        data = key[k]
        if(data['item'].startswith('minecraft') or ':' not in data['item']):
            key[k] = {"id": data['item']}
        elif('tag' in data):
            key[k] = {"item_tag": [data['tag']]}
        else:
            custom_item = get_item(ctx, data['item'])
            key[k] = {
                "id": custom_item['base'],
                "tag": {
                    "smithed": {
                        "id": data['item']
                    }
                }
            }
            
    # Map the pattern and key to recipeItems
    for y in range(len(pattern)):
        # print('Row', y)
        for x in range(len(pattern[y])):
            if (pattern[y][x] == ' '):
                continue
            
            recipeItems[y][x] = dict(key[pattern[y][x]])
            recipeItems[y][x]["Slot"] = Byte(x)
            # print('\t', recipeItems[y][x])

    non_empty_rows = []
    empty_rows = []
    
    # Seperate the rows into empty vs non empty
    for y in range(len(recipeItems)):
        if(recipeItems[y] == [{"Slot":Byte(0),"id": "minecraft:air"}, {"Slot":Byte(1),"id": "minecraft:air"}, {"Slot":Byte(2),"id": "minecraft:air"}]):
            empty_rows.append(y)
        else:
            # Serialize the key data into nbt
            non_empty_rows.append(str(y) + ":[" + ",".join([serialize(k) for k in recipeItems[y]]) + "]")

#execute store result score @s smithed.data if entity @s[scores={smithed.data=0}] if data storage smithed.crafter:input recipe{0:[],1:[],2:[]} run loot replace block ~ ~ ~ container.16 loot
    command = f"execute store result score @s smithed.data if entity @s[scores={{smithed.data=0}}] "
    command += 'if data storage smithed.crafter:input recipe{' + ','.join(non_empty_rows) + '} '
    
    if(len(empty_rows) > 0):
        command += "if data storage smithed.crafter:input recipe{" + ",".join([f"{k}: []" for k in empty_rows]) + "} "
    
    result = recipe['result']
    
    if(result['item'].startswith('minecraft') or ':' not in result['item']):
        command += f"run item replace block ~ ~ ~ container.16 with {result['item']} {result['count'] if 'count' in result else 1}"
    else:
        [item_namespace, item_id] = result['item'].split(':')
        command += f"run loot replace block ~ ~ ~ container.16 loot {item_namespace}:item/{item_id}"
    
    if(f'{namespace}:recipes/shaped' not in ctx.data.functions):
        ctx.data.functions[f'{namespace}:recipes/shaped'] = Function('')
        
    ctx.data.functions[f'{namespace}:recipes/shaped'].append(command)

def process_recipe(ctx: Context, namespace: str, recipe: Any):
    if recipe["type"] == "smithed:crafting_shaped":
        
        shaped_recipe(ctx, namespace, recipe)
    pass


def create_recipes(ctx: Context):

        
    recipes_registry = ctx.data.recipes
    vanilla_recipes = []
    while len(recipes_registry) > 0:
        recipe_entry = recipes_registry.popitem()
        namespace = recipe_entry[0].split(":")[0]

        print(recipe_entry[1].source_path)
        recipe = recipe_entry[1].data
        if recipe["type"].startswith("smithed:"):
            process_recipe(ctx, namespace, recipe)
        else:
            vanilla_recipes.append(recipe_entry)
    ctx.data.recipes = vanilla_recipes
