

from typing import Any

from beet import LootTable


def populate_loot_table(entry: Any):
    return LootTable({
        "pools": [
            {
                "rolls": 1,
                "entries": [
                    entry
                ]
            }
        ]
    }) 

def merge_components(a: dict[str,Any], b: dict[str, Any]):
    for component, data in b:
        if "minecraft" not in component:
            if component.startswith("!"):
                component = "!minecraft:" + component[1:]
            else:
                component = "minecraft:" + component

        if "!" + component in a:
            del a["!" + component]

        existing_data = a.setdefault(component, {})

        if isinstance(data, dict) and isinstance(existing_data, dict):
            a[component] = {*existing_data, *data}
        else:
            a[component] = data

