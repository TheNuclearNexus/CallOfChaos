from beet import Context, Model


def beet_default(ctx: Context):
    angle = 360 / 14
    for i in range(14):
        ctx.assets.models[f"coc:entity/rift_circle/{i}"] = Model({
            "parent": "coc:entity/rift_circle",
            "display": {
                "fixed": {
                    "rotation": [0, i * angle, 0],
                    "translation": [0, (4 * 8) + .01, 0],
                    "scale": [16/35, 4, 16/35]
                }
            }
        })