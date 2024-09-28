

from typing import Any

from beet import LootTable

def model_path_to_component(path: str):
    namespace, path = path.split(":")

    return f"{namespace}:{'/'.join(path.split('/')[1:])}"

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

def merge(a: dict[str, Any], b: dict[str, Any]):
    for key in b:
        
        if key not in a:
            a[key] = b[key]
        elif isinstance(a[key], dict) and isinstance(b[key], dict):
            a[key] = merge(a[key], b[key])
        else:
            a[key] = b[key]

    return a

def merge_components(a: dict[str,Any], b: dict[str, Any]):
    for component, data in b.items():
        if "minecraft" not in component:
            if component.startswith("!"):
                component = "!minecraft:" + component[1:]
            else:
                component = "minecraft:" + component

        if "!" + component in a:
            del a["!" + component]

        existing_data = a.setdefault(component, {})

        if isinstance(data, dict) and isinstance(existing_data, dict):
            a[component] = merge(existing_data, data)
        else:
            a[component] = data

