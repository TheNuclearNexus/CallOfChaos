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

CMD_PREDICATE_TEMPLATE = lambda cmd, model: {
    "predicate": {
        "custom_model_data": cmd
    },
    "model": model
}

class ItemGenerator(Protocol):
    type: ClassVar[str]

    registry: "ItemRegistry"
    ctx: Context

    def __init__(self, ctx: Context, registry: "ItemRegistry") -> None:
        self.registry = registry
        self.ctx = ctx

    @abstractmethod
    def validate(self, namespace: str, item: ItemFile):
        errors = []

        for (id, model) in item.data.states.items():
            if model not in self.ctx.assets.models:
                errors.append(f"Item model \"{model}\" does not exist!")

        if item.data.model is None:
            errors.append(f"Item has no model specified!")
        elif item.data.model not in self.ctx.assets.models:
            errors.append(f"Item model \"{item.data.model}\" does not exist!")

        return errors

    @abstractmethod
    def generate(self, namespace: str, item: ItemFile):
        self.registry.items[f"{namespace}:{item.data.id}"] = item.data

        base_model = self.ctx.assets.models[item.data.model]
        
        overrides: list = base_model.data.setdefault("overrides", [])

        states = list(item.data.states.items())

        for i in range(len(states)):
            (id, model) = states[i]
            overrides.append(CMD_PREDICATE_TEMPLATE(i + 1, model))
            item.data.states[id] = i + 1
        item.data.states["default"] = 0

        base_model.data["overrides"] = overrides

@dataclass
class ItemRegistry:
    ctx: Context
    generators: dict[str, ItemGenerator] = extra_field(default_factory=dict)
    items: dict[str, ItemData] = extra_field(default_factory=dict)

    def extend_generators(self, generator: type[ItemGenerator]):
        self.generators[generator.type] = generator(self.ctx, self)
    
    def __getitem__(self, id: str):
        return self.items[id]