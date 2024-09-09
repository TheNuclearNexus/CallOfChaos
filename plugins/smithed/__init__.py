from beet import Context
from . import items

def pipeline(ctx: Context):
    items.inject(ctx)

def beet_default(ctx: Context):
    items.extend(ctx)
    yield
    items.process(ctx)