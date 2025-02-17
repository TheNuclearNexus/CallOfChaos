data modify storage coc:crucible recipes set value {}

data modify storage coc:crucible colors set value {
    "coc:ichor": [187, 0, 255],
    "minecraft:redstone": [170,15,1]
}

for location, recipe in ctx.data.recipes.items():
    if recipe.data.type != "coc:crucible":
        continue 

    path = []
    for process in recipe.data.process:
        path.extend([f'"{process.id}"', process.progress])

    path.append(f'"{recipe.data.infusion}"')

    namespace, id = recipe.data.output.split(":")

    if namespace != "minecraft": 
        command = f"loot spawn ~ ~ ~ loot {namespace}:items/{id}"
    else:
        command = f"summon item ~ ~ ~ {{Item:{{id: '{recipe.data.output}', count: 1 }}}}"


    data modify storage coc:crucible ("recipes.solid." + ".".join(path)) set value command

function #coc:crucible/setup

append function coc:technical/load:
    function ./setup
 