from abc import abstractmethod
from dataclasses import InitVar, dataclass
from typing import ClassVar, Protocol
from beet import Context, Namespace
from beet.core.utils import extra_field

from .resource import ItemData, ItemFile

# @dataclass
# class Item:


# class ItemRegistry:
#     items: dict[str, Item]
#     def __init__(self, ctx: Context):
#         self.items = create_items(ctx)


class ItemGenerator(Protocol):
    type: ClassVar[str]

    registry: "ItemRegistry"
    ctx: Context

    def __init__(self, ctx: Context, registry: "ItemRegistry") -> None:
        self.registry = registry
        self.ctx = ctx

    @abstractmethod
    def validate(self, namespace: str, item: ItemFile):
        return []

    @abstractmethod
    def generate(self, namespace: str, item: ItemFile):
        self.registry.items[f"{namespace}:{item.data.id}"] = item.data


@dataclass
class ItemRegistry:
    ctx: Context
    generators: dict[str, ItemGenerator] = extra_field(default_factory=dict)
    items: dict[str, ItemData] = extra_field(default_factory=dict)

    def extend_generators(self, generator: type[ItemGenerator]):
        self.generators[generator.type] = generator(self.ctx, self)