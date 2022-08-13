from beet import Advancement

def register(id, fiveTick=False, oneSecond=False):
    append function ./generic_place:
        if data storage smithed.custom_block:main blockApi{id:f"coc:{id}"} function f'coc:block/{id}/place'

    append function ./tick:
        if entity @s[tag=f'coc.{id}'] function f'coc:block/{id}/tick'
    if fiveTick:
        append function ./5tick:
            if entity @s[tag=f'coc.{id}'] function f'coc:block/{id}/5tick'
    if oneSecond:
        append function ./1second:
            if entity @s[tag=f'coc.{id}'] function f'coc:block/{id}/1second'

register('amalgam_forge',           fiveTick=True,  oneSecond=True)
register('entropic_accelerator',    fiveTick=True,  oneSecond=True)
register('eternal_burner',          fiveTick=True,  oneSecond=true)
register('crystalizer',             fiveTick=True,  oneSecond=true)
register('rift_stabilizer')
register('focusing_crystal')
register('gathering_lantern')
register('offering_altar')

def interact(id, lock=None):
    if lock == None:
        lock = id
    ctx.data[f'coc:technical/interact/{id}'] = Advancement({
        "criteria": {
            "requirement": {
                "trigger": "minecraft:item_used_on_block",
                "conditions": {
                    "location": {
                        "block": {  
                            "nbt": "{Lock:\"\\\\uf001coc." + lock + "\"}"
                        }
                    }
                }
            }
        },
        "rewards": {
            "function": f"coc:block/{id}/interact"
        }
    })

    advancement revoke @s only f'coc:technical/interact/{id}'
    title @s actionbar ""
    stopsound @a * minecraft:block.chest.locked
