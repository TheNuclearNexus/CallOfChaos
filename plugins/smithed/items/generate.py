import logging
from beet import Context

from .registry import ItemRegistry
from .resource import ItemFile

logger = logging.getLogger("smithed")

def generate_items(ctx: Context):
    items: list[tuple[str, ItemFile]] = list(ctx.data[ItemFile].items())
    registry = ctx.inject(ItemRegistry)

    for location, item in items:
        generator = registry.generators[item.data.type]
        logger.debug(f"Generating item " + location + " with generator " + item.data.type)
        generator.generate(location.split(":")[0], item)
