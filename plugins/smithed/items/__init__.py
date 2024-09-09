import logging
import time
from beet import Context
from bolt import Module, bolt



from .generators.placeable import PlaceableItemGenerator
from .generators.simple import SimpleItemGenerator

from .registry import ItemRegistry


from .resource import ItemFile, inject_resource
from .validate import validate_items
from .generate import generate_items

logger = logging.getLogger("smithed")

def inject(ctx: Context):
    start = time.time()
    validate_items(ctx)
    generate_items(ctx)
    logger.debug("Elapsed Time: %s", time.time() - start)

    ctx.data[Module]["smithed:items/prelude"] = Module("""
        from plugins.smithed.items.registry import ItemRegistry
        ITEM_REGISTRY = ctx.inject(ItemRegistry)
    """)

def extend(ctx: Context):
    inject_resource(ctx)
    registry = ctx.inject(ItemRegistry)
    registry.extend_generators(SimpleItemGenerator)
    registry.extend_generators(PlaceableItemGenerator)
    
def process(ctx: Context):
    ctx.data[ItemFile].clear()