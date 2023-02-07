from beet import Context
from . import custom_items, nbt_recipes


def extend(ctx: Context):
    custom_items.inject_resource(ctx)

def beet_default(ctx: Context):
    extend(ctx)
    yield 
    # custom_items.create_items(ctx)
    nbt_recipes.create_recipes(ctx)
    