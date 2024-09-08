

from typing import ClassVar, Optional
from beet import Context, FileDeserialize, JsonFileBase
from pydantic import BaseModel


class ItemData(BaseModel):
    id: str
    type: str
    base: str = "minecraft:poisonous_potato" 
    models: dict[str, str] = {}
    components: dict[str, dict | str] = {}


class ItemFile(JsonFileBase[ItemData]):
    scope = {0: ("items",), 45: ("item",)}
    extension = ".json"
    data: ClassVar[FileDeserialize[ItemData]] = FileDeserialize()
    model = ItemData


def inject_resource(ctx: Context):
    ctx.data.extend_namespace.append(ItemFile)


