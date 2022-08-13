from beet import Model
ores = ['diamond','emerald','redstone','lapis','chaos']

cmd = 4260001
predicates = []

models = {'block': {}, 'crystal': {}}

for ore in ores:
    models['crystal'][ore] = {small: cmd, medium: cmd+1, large: cmd+2, cluster: cmd+3}
    for size in ['small', 'medium', 'large']:
        ctx.assets[f'coc:block/crystalizer/bud/{size}/{ore}'] = Model({
            "parent": "coc:block/crystalizer/bud",
            "textures": {
                "cross": f"coc:block/{ore}_{size}_bud",
            }
        })
        predicates.append({"predicate": { "custom_model_data": cmd }, "model": f"coc:block/crystalizer/bud/{size}/{ore}"})
        cmd += 1

    ctx.assets[f'coc:block/crystalizer/cluster/{ore}'] = Model({
        "parent": "coc:block/crystalizer/bud",
        "textures": {
            "cross": f"coc:block/{ore}_cluster",
        }
    })
    predicates.append({"predicate": { "custom_model_data": cmd }, "model": f"coc:block/crystalizer/cluster/{ore}"})
    cmd += 1
ctx.assets[f'minecraft:item/amethyst_cluster'] = Model({"parent": "minecraft:item/generated", "textures": { "layer0": "minecraft:block/amethyst_cluster" }, "display": { "head": { "translation": [ 0, 14, -5 ] } }, "overrides": predicates })


cmd = 4260001
predicates = []
blocks = ['diamond_ore', 'deepslate_diamond_ore', 'emerald_ore', 'deepslate_emerald_ore', 'redstone_ore', 'deepslate_redstone_ore', 'lapis_ore', 'deepslate_lapis_ore', 'nether_quartz_ore', 'crying_obsidian']
for block in blocks:
    models['block'][block] = {0: cmd, 1: cmd+1}
    for state in [0,1]:
        ctx.assets[f'coc:block/crystalizer/used/{state}/{block}'] = Model({
            "parent": "coc:block/crystalizer/used",
            "textures": {
                "0": f"coc:block/{block}_used_{state}",
            }
        })
        predicates.append({"predicate": { "custom_model_data": cmd }, "model": f"coc:block/crystalizer/used/{state}/{block}"})
        cmd += 1
ctx.assets[f'minecraft:item/stone'] = Model({"parent": "minecraft:block/stone", "overrides": predicates })


def spawnBroken(block):
    cmd = models['block'][block][0]
    id = 'coc.stone'
    if 'deepslate' in block:
        id = 'coc.deepslate'
    elif block == 'crying_obsidian':
        id = 'coc.crying_obsidian'

    align xyz summon armor_stand ~.5 ~ ~.5 {Tags:["coc.crystalizer.block", f"coc.{block}", id],ArmorItems:[{},{},{},{id:"minecraft:stone",Count:1b,tag:{CustomModelData:cmd}}],Invisible:1b,Invulnerable:1b,NoGravity:1b,Marker:1b}
def spawnCrystal(crystal):
    cmd = models['crystal'][crystal]['small']
    align xyz summon armor_stand ~.5 ~1 ~.5 {Tags:["coc.crystalizer.crystal", f"coc.{crystal}"],ArmorItems:[{},{},{},{id:"minecraft:amethyst_cluster",Count:1b,tag:{CustomModelData:cmd}}],Invisible:1b,Invulnerable:1b,NoGravity:1b,Marker:1b}

def handleBlock(block, crystal, hasIf= True):
    def content():
        spawnBroken(block)
        spawnCrystal(crystal)
        setblock ~ ~1 ~ small_amethyst_bud[waterlogged=true]
    if hasIf:
        if block ~ ~ ~ f'minecraft:{block}' function f'coc:block/crystalizer/setup/{block}':
            content()
    else:
        content()
if entity @s[tag=coc.up]  rotated 0 -90 positioned ^ ^ ^0.5001 function ./shoot_beam
if entity @s[tag=coc.down] rotated 0 90 positioned ^ ^ ^0.5001 function ./shoot_beam
if entity @s[tag=!coc.up,tag=!coc.down] positioned ^ ^ ^0.5001 function ./shoot_beam:
    particle minecraft:dust 0.82745 0.21568 0.82745 0.5 ^ ^ ^0.00 0 0 0 0 1
    particle minecraft:dust 0.82745 0.21568 0.82745 0.5 ^ ^ ^0.25 0 0 0 0 1
    particle minecraft:dust 0.82745 0.21568 0.82745 0.5 ^ ^ ^0.50 0 0 0 0 1
    particle minecraft:dust 0.82745 0.21568 0.82745 0.5 ^ ^ ^0.75 0 0 0 0 1

    if block ~ ~ ~ #coc:crystalizer/substrate if block ~ ~1 ~ water function ./try_grow:
        if block ~ ~ ~ #coc:crystalizer/deepslate_base function ./setup/deepslate:
            handleBlock('deepslate_diamond_ore', 'diamond')
            handleBlock('deepslate_emerald_ore', 'emerald')
            handleBlock('deepslate_redstone_ore', 'redstone')
            handleBlock('deepslate_lapis_ore', 'lapis')
            setblock ~ ~ ~ deepslate
        if block ~ ~ ~ #coc:crystalizer/stone_base function ./setup/stone:
            handleBlock('diamond_ore', 'diamond')
            handleBlock('emerald_ore', 'emerald')
            handleBlock('redstone_ore', 'redstone')
            handleBlock('lapis_ore', 'lapis')
            setblock ~ ~ ~ stone
        if block ~ ~ ~ crying_obsidian function ./setup/crying_obsidian:
            handleBlock('crying_obsidian', 'chaos', hasIf=False)
            setblock ~ ~ ~ obsidian
    if block ~ ~ ~ #coc:air unless entity @s[tag=coc.done] if entity @s[distance=..5] positioned ^ ^ ^1 function ./shoot_beam

tag @s remove coc.done

scoreboard players set @s coc.rift_energy 0
