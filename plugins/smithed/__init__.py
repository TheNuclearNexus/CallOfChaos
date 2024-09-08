from beet import Context
from . import items

def beet_default(ctx: Context):
    ctx.require(items.beet_default)