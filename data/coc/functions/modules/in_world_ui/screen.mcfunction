from bolt_expressions import Scoreboard, Data

dummy = Scoreboard("coc.dummy")

CURSOR_X = dummy["$x"]
CURSOR_Y = dummy["$y"]

class Screen:
    def __init__(self, name, w, h, d, children=[]):
        self.name = name.lower()
        self.w = int(w)
        self.h = int(h)
        self.d = int(d)
        self.children = children

    def generate(self):
        append function f"coc:modules/ui/{self.name}/create":
            execute summon text_display function f"coc:modules/ui/{self.name}/setup":
                tag @s add coc.world_ui
                tag @s add f"coc.ui.{self.name}"
                for c in self.children:
                    c.render(self)

        tick_path = f"coc:modules/ui/{self.name}/tick"
        append function tick_path:
            store result entity @s Air byte 1 time query gametime
            for c in self.children:
                c.tick(self, self, tick_path)

        append function ./track_player:
            if entity @s[tag=f"coc.ui.{self.name}"] on passengers function tick_path
