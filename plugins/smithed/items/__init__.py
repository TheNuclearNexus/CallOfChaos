import logging
import time
from beet import Context, FunctionTag
from bolt import Module, bolt

from plugins.smithed.items.generators.constants import LOAD_FUNCTION



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
    
    ctx.data.function_tags.setdefault("minecraft:load", FunctionTag()).data["values"].append("smithed.item_gen:load")

def extend(ctx: Context):
    inject_resource(ctx)

    ctx.data["smithed.item_gen:load"] = LOAD_FUNCTION

    registry = ctx.inject(ItemRegistry)
    registry.extend_generators(SimpleItemGenerator)
    registry.extend_generators(PlaceableItemGenerator)
    
def process(ctx: Context):
    ctx.data[ItemFile].clear()