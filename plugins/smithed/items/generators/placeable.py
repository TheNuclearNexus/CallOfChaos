from typing import Callable, ClassVar
from beet import (
    BlockTag,
    DataPackNamespace,
    Function,
    LootTable,
    Model,
    Namespace,
    Predicate,
)
from plugins.smithed.items.generators.constants import OPAQUE_BLOCKS
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

    def __init__(self, ctx, registry):
        super().__init__(ctx, registry)

        self.ctx.data["smithed.item_gen:opaque"] = OPAQUE_BLOCKS

        self.ctx.data["smithed.item_gen:update_light"] = Function(
            """
            data remove entity @s brightness
            scoreboard players set #light smithed.item_gen.dummy 0
            if block ~ ~ ~ #smithed.item_gen:opaque align xyz positioned ~ ~-0.5 ~ function ./update_light/edit_brightness
        """
        )

        self.ctx.data["smithed.item_gen:update_light/edit_brightness"] = Function(
            """
            data merge entity @s { brightness: {sky: 0,block: 0} }
            positioned ~1 ~ ~ positioned over motion_blocking_no_leaves positioned ~-1 ~ ~ if entity @s[dx=0,dy=1000,dz=0] data modify entity @s brightness.sky set value 15
            positioned ~ ~ ~1 positioned over motion_blocking_no_leaves positioned ~ ~ ~-1 if entity @s[dx=0,dy=1000,dz=0] data modify entity @s brightness.sky set value 15
            positioned ~-1 ~ ~ positioned over motion_blocking_no_leaves positioned ~1 ~ ~ if entity @s[dx=0,dy=1000,dz=0] data modify entity @s brightness.sky set value 15
            positioned ~ ~ ~-1 positioned over motion_blocking_no_leaves positioned ~ ~ ~1 if entity @s[dx=0,dy=1000,dz=0] data modify entity @s brightness.sky set value 15
            positioned ~1 ~ ~ function ./check_light
            positioned ~ ~ ~1 function ./check_light
            positioned ~-1 ~ ~ function ./check_light
            positioned ~ ~ ~-1 function ./check_light
            positioned ~ ~-1 ~ function ./check_light
            if score #light smithed.item_gen.dummy matches 1.. scoreboard players remove #light smithed.item_gen.dummy 1
            store result entity @s brightness.block int 1 run scoreboard players get #light smithed.item_gen.dummy
        """
        )

        self.ctx.data["smithed.item_gen:update_light/check_light"] = Function(
            """
            unless score #light smithed.item_gen.dummy matches 1.. if predicate smithed.item_gen:location_check/light/0 scoreboard players set #light smithed.item_gen.dummy 0
            unless score #light smithed.item_gen.dummy matches 2.. if predicate smithed.item_gen:location_check/light/1 scoreboard players set #light smithed.item_gen.dummy 1
            unless score #light smithed.item_gen.dummy matches 3.. if predicate smithed.item_gen:location_check/light/2 scoreboard players set #light smithed.item_gen.dummy 2
            unless score #light smithed.item_gen.dummy matches 4.. if predicate smithed.item_gen:location_check/light/3 scoreboard players set #light smithed.item_gen.dummy 3
            unless score #light smithed.item_gen.dummy matches 5.. if predicate smithed.item_gen:location_check/light/4 scoreboard players set #light smithed.item_gen.dummy 4
            unless score #light smithed.item_gen.dummy matches 6.. if predicate smithed.item_gen:location_check/light/5 scoreboard players set #light smithed.item_gen.dummy 5
            unless score #light smithed.item_gen.dummy matches 7.. if predicate smithed.item_gen:location_check/light/6 scoreboard players set #light smithed.item_gen.dummy 6
            unless score #light smithed.item_gen.dummy matches 8.. if predicate smithed.item_gen:location_check/light/7 scoreboard players set #light smithed.item_gen.dummy 7
            unless score #light smithed.item_gen.dummy matches 9.. if predicate smithed.item_gen:location_check/light/8 scoreboard players set #light smithed.item_gen.dummy 8
            unless score #light smithed.item_gen.dummy matches 10.. if predicate smithed.item_gen:location_check/light/9 scoreboard players set #light smithed.item_gen.dummy 9
            unless score #light smithed.item_gen.dummy matches 11.. if predicate smithed.item_gen:location_check/light/10 scoreboard players set #light smithed.item_gen.dummy 10
            unless score #light smithed.item_gen.dummy matches 12.. if predicate smithed.item_gen:location_check/light/11 scoreboard players set #light smithed.item_gen.dummy 11
            unless score #light smithed.item_gen.dummy matches 13.. if predicate smithed.item_gen:location_check/light/12 scoreboard players set #light smithed.item_gen.dummy 12
            unless score #light smithed.item_gen.dummy matches 14.. if predicate smithed.item_gen:location_check/light/13 scoreboard players set #light smithed.item_gen.dummy 13
            unless score #light smithed.item_gen.dummy matches 15.. if predicate smithed.item_gen:location_check/light/14 scoreboard players set #light smithed.item_gen.dummy 14
            if predicate smithed.item_gen:location_check/light/15 run scoreboard players set #light smithed.item_gen.dummy 15
        """
        )

        for i in range(16):
            self.ctx.data[f"smithed.item_gen:location_check/light/{i}"] = Predicate(
                {
                    "condition": "minecraft:location_check",
                    "predicate": {"light": {"light": i}},
                }
            )

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
            f"{namespace}:block/{item.data.id}/5tick", Function("")
        )

        self.ctx.data.functions.setdefault(
            f"{namespace}:block/{item.data.id}/1second", Function("")
        ).prepend("function smithed.item_gen:update_light")

        self.ctx.data.functions.setdefault(
            f"{namespace}:block/{item.data.id}/place", Function("")
        ).append("function smithed.item_gen:update_light")

        self.ctx.data.functions.setdefault(
            f"{namespace}:block/tick", Function()
        ).append(
            f"if entity @s[tag={namespace}.{item.data.id}] return run function ./{item.data.id}/tick"
        )

        self.ctx.data.functions.setdefault(
            f"{namespace}:block/5tick", Function()
        ).append(
            f"if entity @s[tag={namespace}.{item.data.id}] return run function ./{item.data.id}/5tick"
        )

        self.ctx.data.functions.setdefault(
            f"{namespace}:block/1second", Function()
        ).append(
            f"if entity @s[tag={namespace}.{item.data.id}] return run function ./{item.data.id}/1second"
        )
