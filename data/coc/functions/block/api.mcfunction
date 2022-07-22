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

register('amalgam_forge', oneSecond=True)
register('chaotic_converter', oneSecond=True)
register('eternal_burner', oneSecond=True)
register('focusing_crystal')
register('offering_altar')
