from typing import Callable, ClassVar
from beet import DataPackNamespace, Function, LootTable, Model, Namespace
from plugins.smithed.items.generators.shared import (
    merge_components,
    populate_loot_table,
)
from plugins.smithed.items.registry import ItemGenerator
from plugins.smithed.items.resource import ItemData, ItemFile


CONTAINER_TEMPLATE = lambda id: [
    {
        "slot": 0,
        "item": {
            "id": "minecraft:stone",
            "components": {"minecraft:custom_data": {"smithed": {"block": {"id": id}}}},
        },
    }
]

MODEL_TEMPLATE = lambda model: {
    "__comment__": "Generated from the item's defintion file by type 'smithed:placeable'",
    "parent": model,
    "overrides": [],
}

SUMMON_TEMPLATE: Callable[[str, ItemData, float], str] = (
    lambda namespace, data, rotation: """summon item_display ~ ~ ~ {{
            Rotation: [{rotation}f, 0f], 
            Tags: ["smithed.block", "smithed.entity", "{namespace}.block", "{namespace}.{id}", "gen.unsetup"], 
            transformation: [1.002f,0f,0f,0f,0f,1.002f,0f,0f,0f,0f,1.002f,0f,0f,0f,0f,1f],
            brightness: {{block: 15, sky: 15}},
            item: {{id: "{base}", components: {{ \'minecraft:item_model\': "{item_model}" }} }}
        }}""".format(
        rotation=float(rotation),
        namespace=namespace,
        id=data.id,
        base=data.base,
        item_model=data.model,
    )
)

PLACE_TEMPLATE: Callable[[str, ItemData], Function] = (
    lambda namespace, data: f"""
    append function_tag smithed.custom_block:event/on_place {{
        "values": [
            "{namespace}:block/{data.id}/_place"
        ]
    }}

    unless data storage smithed.custom_block:main {{blockApi:{{id:"{namespace}:{data.id}"}}}} return 0

    if block ~ ~ ~ {data.base}[facing=east] run {SUMMON_TEMPLATE(namespace, data, -90)}
    if block ~ ~ ~ {data.base}[facing=west] run {SUMMON_TEMPLATE(namespace, data, 90)}
    if block ~ ~ ~ {data.base}[facing=north] run {SUMMON_TEMPLATE(namespace, data, 180)}
    if block ~ ~ ~ {data.base}[facing=south] run {SUMMON_TEMPLATE(namespace, data, 0)}

    as @n[type=item_display,tag=gen.unsetup] at @s run function {namespace}:block/{data.id}/place
    tag @n[type=item_display,tag=gen.unsetup] remove gen.unsetup
"""
)


TICK_TEMPLATE: Callable[[str, ItemData], Function] = (
    lambda namespace, data: f"""
    if block ~ ~ ~ #{namespace}:air return run function ./_drop:
        as @n[type=item,nbt={{Item:{{components: {{"minecraft:custom_name": '{{"translate":"block.{namespace}.{data.id}"}}' }} }} }}, distance=..0.5] function ~/drop_item:
            data modify storage {namespace}:temp count set from entity @s Item.count

            loot replace entity @s contents loot {namespace}:blocks/{data.id}

            data modify entity @s Item.count set from storage {namespace}:temp count           
        function ./break
        kill @s
"""
)


class PlaceableItemGenerator(ItemGenerator):
    type: ClassVar[str] = "smithed:placeable"

    def validate(self, namespace: str, item: ItemFile) -> list[str]:
        if item.data.model is None:
            item.data.model = f"{namespace}:block/{item.data.id}"

        if item.data.model not in self.ctx.assets.models:
            self.ctx.assets.models[item.data.model] = Model(
                MODEL_TEMPLATE(f"{namespace}:block/{item.data.id}")
            )

        errors = super().validate(namespace, item)

        return errors

    def generate(self, namespace: str, item: ItemFile):
        super().generate(namespace, item)

        components = {
            "minecraft:item_model": item.data.model,
            "minecraft:item_name": f'{{"translate": "block.{namespace}.{item.data.id}"}}',
            "minecraft:container": CONTAINER_TEMPLATE(f"{namespace}:{item.data.id}"),
            "!minecraft:food": {},
            "!minecraft:consumable": {},
            "minecraft:custom_data": {"smithed": {"id": f"{namespace}:{item.data.id}"}},
        }

        merge_components(components, item.data.components)

        self.ctx.data[f"{namespace}:blocks/{item.data.id}"] = populate_loot_table(
            entry={
                "type": "minecraft:item",
                "name": item.data.base,
                "functions": [
                    {"function": "minecraft:set_components", "components": components}
                ],
            }
        )

        self.ctx.data[f"{namespace}:block/{item.data.id}/_place"] = Function(
            PLACE_TEMPLATE(namespace, item.data)
        )

        self.ctx.data.functions.setdefault(
            f"{namespace}:block/{item.data.id}/tick", Function("")
        ).prepend(TICK_TEMPLATE(namespace, item.data))

        self.ctx.data.functions.setdefault(
            f"{namespace}:block/tick", Function()
        ).append(f"if entity @s[tag={namespace}.{item.data.id}] return run function ./{item.data.id}/tick")
