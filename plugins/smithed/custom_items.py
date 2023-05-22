import io
import json
import os
from typing import Any, Dict

from beet import Cache, Context, JsonFile, LootTable, Model
from beet.contrib.vanilla import Vanilla
from pydantic import BaseModel


class Item(JsonFile):
    scope = ("items",)
    extension = ".json"

item_registry = {}

def get_item(ctx: Context, item: str):
    registry = ctx.inject(ItemRegistry)
    return registry.items[item]

def load_model_registry():
    if not os.path.exists("model_registry.json"):
        return
    cached_models_text = open("model_registry.json", "r+").read()
    if cached_models_text == "":
        return
    global model_registry
    model_registry = json.loads(cached_models_text)

def inject_resource(ctx: Context):
    ctx.data.extend_namespace.append(Item)
    





model_registry = {}


def generate_model(ctx: Context, vanilla: Context, namespace: str, item: Any):
    global model_registry
    if item["base"] not in model_registry:
        model_registry[item["base"]] = {}
    base_item_models = model_registry[item["base"]]

    cmds = []

    for model in item["models"]:
        cmd = ctx.meta.get("smithed.items")["starting_cmd"]

        if(item["models"][model] in base_item_models):
            cmd = base_item_models[item["models"][model]]
        else:
            for regModel in base_item_models:
                if cmd < base_item_models[regModel]:
                    cmd = base_item_models[regModel]
            cmd += 1
            model_registry[item["base"]][item["models"][model]] = cmd
        item["models"][model] = cmd
        cmds.append(cmd)
    return cmds[0]


def generate_set_count_table(ctx: Context, namespace: str, folder: str, item: Any):
    ctx.data[namespace + f":{folder}/" + item["id"]] = LootTable(
        {
            "pools": [
                {
                    "rolls": 1,
                    "entries": [
                        {
                            "type": "minecraft:loot_table",
                            "name": f"{namespace}:item/{item['id']}",
                            "functions": [
                                {
                                    "function": "minecraft:set_count",
                                    "count": {
                                        "type": "minecraft:score",
                                        "target": {
                                            "type": "minecraft:fixed",
                                            "name": "$count",
                                        },
                                        "score": ctx.meta.get('smithed.items')["dummy_score"],
                                    },
                                }
                            ],
                        }
                    ],
                }
            ]
        }
    )


def generate_basic_loot(ctx: Context, namespace: str, cmd: int, item: Any):
    ctx.data[namespace + f":item/" + item["id"]] = LootTable(
        {
            "pools": [
                {
                    "rolls": 1,
                    "entries": [
                        {
                            "type": "minecraft:item",
                            "name": item["base"],
                            "functions": [
                                {
                                    "function": "minecraft:set_nbt",
                                    "tag": f"{{CustomModelData:{cmd},display:{{Name:'{{\"translate\":\"item.{namespace}.{item['id']}\",\"italic\":false}}'}},smithed:{{id:\"{namespace}:{item['id']}\"}}{','+item['additional_nbt'] if 'additional_nbt' in item else ''}}}",
                                }
                            ],
                        }
                    ],
                }
            ]
        }
    )
    generate_set_count_table(ctx, namespace, "set_item", item)


def generate_block_loot(ctx: Context, namespace: str, cmd: int, item: Any):
    ctx.data[namespace + f":item/" + item["id"]] = LootTable(
        {
            "pools": [
                {
                    "rolls": 1,
                    "entries": [
                        {
                            "type": "minecraft:item",
                            "name": item["base"],
                            "functions": [
                                {
                                    "function": "minecraft:set_nbt",
                                    "tag": f"{{CustomModelData:{cmd},display:{{Name:'{{\"translate\":\"block.{namespace}.{item['id']}\",\"italic\":false}}'}},smithed:{{id:\"{namespace}:{item['id']}\"}},BlockEntityTag:{{Items:[{{id:\"minecraft:stone\",Count:1b,Slot:0b,tag:{{smithed:{{block:{{id:\"{namespace}:{item['id']}\"}}}}}}}}]}}}}",
                                }
                            ],
                        }
                    ],
                }
            ]
        }
    )
    generate_set_count_table(ctx, namespace, "block", item)



def create_items(ctx: Context):
    load_model_registry()
    vanilla = ctx.inject(Vanilla).mount("assets/minecraft/models/item")

    items = ctx.data[Item]

    item_registry = {}
    for itemPath in items:
        namespace = itemPath.split(":")[0]
        item = items[itemPath].data
        # print(item)
        if item["type"] == "smithed:simple":
            cmd = generate_model(ctx, vanilla, namespace, item)
            generate_basic_loot(ctx, namespace, cmd, item)
        elif item["type"] == "smithed:block":
            cmd = generate_model(ctx, vanilla, namespace, item)
            generate_block_loot(ctx, namespace, cmd, item)
        elif item["type"] == "smithed:existing_loot":
            generate_model(ctx, vanilla, namespace, item)
            generate_set_count_table(ctx, namespace, 'set_item', item)
        item_registry[f'{namespace}:{item["id"]}'] = {"models": item["models"], "base": item["base"]}
                
    global model_registry
    for item in model_registry:
        vanilla_model_path = "minecraft:item/" + item.split(":")[-1]
        vanilla_model = (
            ctx.assets.models.get(vanilla_model_path)
            or vanilla.assets.models.get(vanilla_model_path)
        ).data

        if "overrides" not in vanilla_model:
            vanilla_model["overrides"] = []

        for model in model_registry[item]:
            vanilla_model["overrides"].append(
                {
                    "predicate": {"custom_model_data": model_registry[item][model]},
                    "model": model,
                }
            )

        ctx.assets.models[vanilla_model_path] = Model(vanilla_model)
    ctx.data[Item].clear()
    open("model_registry.json", "w+").write(json.dumps(model_registry, indent=2))
    return item_registry

class ItemRegistry:
    items: Dict[str, Any]
    def __init__(self, ctx: Context):
        self.items = create_items(ctx)