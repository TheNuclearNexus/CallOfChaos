import logging
from typing import cast
from beet import Context
from mecha import Diagnostic, DiagnosticCollection, DiagnosticErrorSummary
from pydantic import ValidationError
from pydantic_core import ErrorDetails

from plugins.smithed.items.registry import ItemRegistry
from plugins.smithed.items.resource import ItemFile, ItemData

logger = logging.getLogger("smithed")


def format_error(err: ErrorDetails):
    match err["type"]:
        case "missing":
            return "Missing required field(s): " + ", ".join(
                [f'"{k}"' for k in err["loc"]]
            )

        case _:
            return err["msg"]


def validate_items(ctx: Context):
    registry = ctx.inject(ItemRegistry)

    logger.debug("Validating Items...")
    diagnostics: list[Diagnostic] = []
    for location, item in cast(list[tuple[str, ItemFile]], ctx.data[ItemFile].items()):
        try:
            item.data = ItemData.model_validate(item.data)
        except ValidationError as err:
            errors = [format_error(k) for k in err.errors()]

            for err in errors:
                diagnostics.append(
                    Diagnostic("error", err, filename=location, file=item)
                )

            continue

        if item.data.type not in registry.generators:
            diagnostics.append(
                Diagnostic(
                    "error",
                    f'Generator type "{item.data.type}" does not exist.',
                    filename=location,
                    file=item,
                    notes=[
                        "Expected values are: "
                        + ", ".join([f'"{k}"' for k in registry.generators.keys()])
                    ],
                )
            )

        errors = registry.generators[item.data.type].validate(
            location.split(":")[0], item
        )

        for error in errors:
            diagnostics.append(
                Diagnostic("error", error, filename=location, file=item)
            )

    if len(diagnostics) > 0:
        for diag in diagnostics:
            message = diag.format_message()
            extra = {"annotate": f'Item Defintion "{diag.filename}"'}

            if diag.notes:
                message += f"\n\n{diag.format_notes()}\n"

            logger.error("%s", message, extra=extra)

        raise DiagnosticErrorSummary(DiagnosticCollection(diagnostics))
