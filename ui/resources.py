from typing import ClassVar

from beet import Context, Function, TextFileBase
import bolt
import mecha


class UiScreen(TextFileBase[str]):
    scope: ClassVar[tuple[str, ...]] = ("ui_screens",)
    extension: ClassVar[str] = ".xml"


def beet_default(ctx: Context):
    ctx.data.extend_namespace.append(UiScreen)
    