
MAX_DISTANCE = 16


function ~/worn:
    as @e[type=item_display, distance=f"..{MAX_DISTANCE}", tag=coc.energy.sink] align xyz at @s if score @s coc.powered matches 1:
        for x in [-0.5, 0, 0.5]:
            for y in [-0.5, 0, 0.5]:
                for z in [-0.5, 0, 0.5]:
                    particle minecraft:reverse_portal ~x ~y ~z 0.01 0.01 0.01 0 3