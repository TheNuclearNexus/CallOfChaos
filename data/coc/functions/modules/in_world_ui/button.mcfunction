from ./element import Element, fix_rotation, VIEW_RANGE
from ./screen import CURSOR_X, CURSOR_Y

from bolt_expressions import Scoreboard, Data

dummy = Scoreboard("coc.dummy")
atSelf = Data.entity("@s")

class Button(Element):

    def __init__(self, key, default, hover, x, y, w, h):
        super().__init__(x,y,w,h)
        self.key = key
        self.default = default
        self.hover = hover

    def render(self, screen, depth=0):
        tag @s add coc.parent
        execute summon text_display:
            data merge entity @s {
                view_range: VIEW_RANGE,
                transformation: {
                    translation: self.get_translate(screen, depth),
                    scale: [2.5f,2.5f,2.5f],
                    left_rotation: [0f,1f,0f,0f],
                    right_rotation: [0f,0f,0f,1f]
                },
                text: ('{"text": "' + self.default + '","font":"coc:ui/' + screen.name + '"}'),
                alignment: "left",
                background: 0,
                Tags: ["coc.element", "coc.button", f"coc.button.{self.key}"],
                CustomName: ('{"text": "button.' + self.key + '"}')
            }  
            ride @s mount @e[type=text_display,tag=coc.parent,distance=..0.5,limit=1]
        tag @s remove coc.parent
    
    def tick(self, screen, parent, path):
        if entity @s[tag=f"coc.button.{self.key}"] function (path + f"/{self.key}_tick"):
            fix_rotation()
            atSelf.text = '{"text": "' + self.default + '","font":"coc:ui/' + screen.name + '"}'
            if score var CURSOR_X matches (self.x, self.x + self.w):
                if score var CURSOR_Y matches (self.y, self.y + self.h):
                    atSelf.text = '{"text": "' + self.hover + '","font":"coc:ui/' + screen.name + '"}'

