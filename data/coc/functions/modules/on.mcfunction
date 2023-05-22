from contextlib import contextmanager

events = ["inventory_changed"]

advancement coc:events/inventory_changed {
  "criteria": {
    "requirement": {
      "trigger": "minecraft:inventory_changed"
    }
  },
  "rewards": {
    "function": "coc:events/inventory_changed"
  }
}



for e in events:
    append function f"coc:events/{e}":
        advancement revoke @s only f"coc:events/{e}"
        function f"#coc:events/{e}"

@contextmanager
def onEvent(event, location):
    if event not in events:
        raise ValueError(f"{event} not in {events}")
    append function_tag f"coc:events/{event}" {
        "values": [
            location
        ]
    }
    append function location:
        yield

    
