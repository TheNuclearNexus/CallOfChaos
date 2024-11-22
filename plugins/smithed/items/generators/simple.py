from typing import ClassVar
from beet import DataPackNamespace, LootTable, Namespace
from plugins.smithed.items.generators.shared import merge_components, populate_loot_table
from plugins.smithed.items.registry import ItemGenerator
from plugins.smithed.items.resource import ItemFile


class SimpleItemGenerator(ItemGenerator):
    type: ClassVar[str] = "smithed:simple"

    def validate(self, namespace: str, item: ItemFile) -> list[str]:
        if item.data.model is None:
            item.data.model = f"{namespace}:item/{item.data.id}" 
        
        errors = super().validate(namespace, item)

        return errors

    def generate(self, namespace: str, item: ItemFile):
        super().generate(namespace, item)

        components = {
            "minecraft:item_model": item.data.model,
            "minecraft:item_name": f'{{"translate": "item.{namespace}.{item.data.id}"}}',
            "!minecraft:food": {},
            "!minecraft:consumable": {},
        }

        merge_components(components, item.data.components)

        self.ctx.data[f"{namespace}:items/{item.data.id}"] = populate_loot_table(
            entry={
                "type": "minecraft:item",
                "name": item.data.base,
                "functions": [
                    {"function": "minecraft:set_components", "components": components}
                ],
            }
        )
    