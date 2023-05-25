from ./element import Element, fix_rotation, VIEW_RANGE
from bolt_expressions import Scoreboard, Data

dummy = Scoreboard("coc.dummy")
atSelf = Data.entity("@s")

class Group(Element):
    def __init__(self, key, children=[], x=0, y=0, w=0, h=0, background=''):
        super().__init__(x,y,w,h)
        self.children = children
        self.key = key
        self.background = background

    def render(self, screen, depth=0):
        tag @s add coc.parent
        execute summon text_display:
            tag @s add coc.group
            tag @s add coc.element
            tag @s add f"coc.group.{self.key}"

            if self.background != '':
                data merge entity @s {
                    view_range: VIEW_RANGE,
                    transformation: {
                        translation: self.get_translate(screen, depth, offset=0),
                        scale: [2.5f,2.5f,2.5f],
                        left_rotation: [0f,1f,0f,0f],
                        right_rotation: [0f,0f,0f,1f]
                    },
                    text: ('{"text": "' + self.background + '","font":"coc:ui/' + screen.name + '"}'),
                    alignment: left,
                    background: 0,
                    CustomName: ('{"text": "group.' + self.key + '"}')
                }  


            ride @s mount @e[type=text_display,tag=coc.parent,distance=..0.5,limit=1]
            tag @e[type=text_display,tag=coc.parent,distance=..0.5,limit=1] remove coc.parent
            for c in self.children:
                c.render(screen, depth + 0.0001) 
        tag @s remove coc.parent

    def tick(self, screen, parent, path):
        if self.background != '':
            fix_rotation()

        if entity @s[tag=f"coc.group.{self.key}"] on passengers function (path + f"/{self.key}_tick"): 
            for c in self.children:
                c.tick(screen, self, path + f"/{self.key}_tick")

