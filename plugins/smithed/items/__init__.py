from beet import Context


from .generators.placeable import PlaceableItemGenerator
from .generators.simple import SimpleItemGenerator

from .registry import ItemRegistry


from .resource import ItemFile, inject_resource
from .validate import validate_items
from .generate import generate_items


def beet_default(ctx: Context):
    registry = ctx.inject(ItemRegistry)

    registry.extend_generators(SimpleItemGenerator)
    registry.extend_generators(PlaceableItemGenerator)

    inject_resource(ctx)
    yield
    validate_items(ctx)
    generate_items(ctx)

    ctx.data[ItemFile].clear()