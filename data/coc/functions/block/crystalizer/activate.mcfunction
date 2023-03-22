from beet import Model
ores = ['diamond','emerald','redstone','lapis','chaos', 'quartz']

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
blocks = ['diamond_ore', 'deepslate_diamond_ore', 'emerald_ore', 'deepslate_emerald_ore', 'redstone_ore', 'deepslate_redstone_ore', 'lapis_ore', 'deepslate_lapis_ore', 'nether_quartz_ore', 'crying_obsidian', 'nether_quartz_ore']
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


baseBlocks = ['stone', 'deepslate', 'obsidian', 'netherrack']

def spawnBroken(block, crystal):
    cmd = models['block'][block][0]
    id = 'coc.stone'
    if 'deepslate' in block:
        id = 'coc.deepslate'
    elif block == 'crying_obsidian':
        id = 'coc.obsidian'
    elif block == 'nether_quartz_ore':
        id = 'coc.netherrack'

    align xyz run summon item_display ~0.5 ~ ~0.5 {Tags:["coc.crystalizer.block", "coc.ticking", f"coc.{block}", f"coc.{crystal}", id],ArmorItems:[{},{},{},{id:"minecraft:stone",Count:1b,tag:{CustomModelData:cmd}}],Invisible:1b,Invulnerable:1b,NoGravity:1b,Marker:1b}
def spawnCrystal(crystal):
    cmd = models['crystal'][crystal]['small']
    align xyz run summon item_display ~.5 ~1 ~.5 {Tags:["coc.crystalizer.crystal", "coc.ticking", f"coc.{crystal}"],ArmorItems:[{},{},{},{id:"minecraft:amethyst_cluster",Count:1b,tag:{CustomModelData:cmd}}],Invisible:1b,Invulnerable:1b,NoGravity:1b,Marker:1b}

def handleBlock(block, crystal, hasIf= True):
    def content():
        playsound minecraft:block.amethyst_block.hit block @s ~ ~ ~ 1 0
        spawnBroken(block, crystal)
        spawnCrystal(crystal)
        setblock ~ ~1 ~ small_amethyst_bud[waterlogged=true]
    if hasIf:
        if block ~ ~ ~ f'minecraft:{block}' function f'coc:block/crystalizer/setup/{block}':
            content()
    else:
        content()

playsound minecraft:block.respawn_anchor.deplete block @a ~ ~ ~ 1 2
if entity @s[tag=coc.up]  rotated 0 -90 positioned ^ ^ ^0.5001 function ./shoot_beam
if entity @s[tag=coc.down] rotated 0 90 positioned ^ ^ ^0.5001 function ./shoot_beam
if entity @s[tag=!coc.up,tag=!coc.down] rotated ~180 ~0 positioned ^ ^ ^0.5001 function ./shoot_beam:
    particle minecraft:dust 0.82745 0.21568 0.82745 0.5 ^ ^ ^0.00 0 0 0 0 1
    particle minecraft:dust 0.82745 0.21568 0.82745 0.5 ^ ^ ^0.25 0 0 0 0 1
    particle minecraft:dust 0.82745 0.21568 0.82745 0.5 ^ ^ ^0.50 0 0 0 0 1
    particle minecraft:dust 0.82745 0.21568 0.82745 0.5 ^ ^ ^0.75 0 0 0 0 1
    
    if block ~ ~ ~ #coc:crystalizer/substrate if block ~ ~1 ~ water function ./setup:
        if block ~ ~ ~ #coc:crystalizer/deepslate_base function ./setup/deepslate:
            handleBlock('deepslate_diamond_ore', 'diamond')
            handleBlock('deepslate_emerald_ore', 'emerald')
            handleBlock('deepslate_redstone_ore', 'redstone')
            handleBlock('deepslate_lapis_ore', 'lapis')
            setblock ~ ~ ~ deepslate
            tag @s add coc.done
        if block ~ ~ ~ #coc:crystalizer/stone_base function ./setup/stone:
            handleBlock('diamond_ore', 'diamond')
            handleBlock('emerald_ore', 'emerald')
            handleBlock('redstone_ore', 'redstone')
            handleBlock('lapis_ore', 'lapis')
            setblock ~ ~ ~ stone
            tag @s add coc.done
        if block ~ ~ ~ crying_obsidian function ./setup/crying_obsidian:
            handleBlock('crying_obsidian', 'chaos', hasIf=False)
            setblock ~ ~ ~ obsidian
            tag @s add coc.done
        if block ~ ~ ~ nether_quartz_ore function ./setup/nether_quartz:
            handleBlock('nether_quartz_ore', 'quartz', hasIf=False)
            setblock ~ ~ ~ netherrack
            tag @s add coc.done
    if entity @s[tag=!coc.done] align xyz positioned ~.5 ~ ~.5 if entity @e[type=item_display,tag=coc.crystalizer.block,distance=..0.5] function ./grow:
        if score @s coc.rift_energy matches 7..12 positioned ~ ~1 ~ function ./grow/add_stage:
            playsound minecraft:block.amethyst_block.fall master @s ~ ~ ~ 1 1
            as @e[type=item_display,tag=coc.crystalizer.crystal,distance=..0.5] function ./grow/as_crystal:
                scoreboard players set $found coc.dummy 1
                unless score @s coc.dummy matches 5.. scoreboard players add @s coc.dummy 1
                if score @s coc.dummy matches ..3 store result entity @s item.tag.CustomModelData int -1 data get entity @s item.tag.CustomModelData -1.0000001
        if score @s coc.rift_energy matches 10..11 function ./grow/add_stage
        as @e[type=item_display,tag=coc.crystalizer.block,distance=..0.5] function ./grow/use_block:
            scoreboard players add @s coc.dummy 1
            if score @s coc.dummy matches 2 store result entity @s item.tag.CustomModelData int -1 data get entity @s item.tag.CustomModelData -1.0000001
            if score @s coc.dummy matches 4 function ./grow/break:
                kill @s
                setblock ~ ~ ~ air
                for b in baseBlocks:
                    if entity @s[tag=f'coc.{b}'] setblock ~ ~ ~ f'minecraft:{b}'
                setblock ~ ~1 ~ small_amethyst_bud[waterlogged=true]
    if block ~ ~ ~ #coc:air unless entity @s[tag=coc.done] if entity @s[distance=..5] positioned ^ ^ ^1 function ./shoot_beam


tag @s remove coc.done

scoreboard players set @s coc.rift_energy 0
