from beet import Context, subproject

from .resources import UiScreen


def beet_default(ctx: Context):
    all_screens = {
        name: screen_file.text for name, screen_file in ctx.data[UiScreen].items()
    }
    ctx.data[UiScreen].clear()

    ctx.require(
        subproject(
            {
                "require": ["bolt", "bolt_expressions", "bolt_expressions.contrib.commands", "plugins.nbt_literals"],
                "data_pack": {"load": {"data/ui/modules": "@ui/modules"}},
                "resource_pack": {"load": "."},
                "pipeline": ["mecha"],
                "meta": {
                    "bolt": {"entrypoint": "ui:main"},
                    "ui": {"all_screens": all_screens},
                },
            }
        )
    )