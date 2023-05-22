from bolt_expressions import Scoreboard, Data

dummy = Scoreboard("coc.dummy")
atSelf = Data.entity("@s")
temp = Data.storage("coc:temp")

VIEW_RANGE = pow(1, -4)

CURSOR_X = dummy["$x"]
CURSOR_Y = dummy["$y"]
CURSOR_D = Scoreboard("coc.cursor.d")["@s"]
CURSOR_R = Scoreboard("coc.cursor.r")["@s"]

SCREEN_W = Scoreboard("coc.screen.w")["@s"]
SCREEN_H = Scoreboard("coc.screen.h")["@s"]

append function ./in_world_ui/start_tracking:
    CURSOR_R = atSelf.Rotation[0] * 1000
    CURSOR_D = 200

    SCREEN_W = 64
    SCREEN_H = 64

    tag @s add coc.has_tracked_ui

append function coc:entity/player/tick:
    if entity @s[tag=coc.has_tracked_ui] function ./in_world_ui/process:
        tag @s add coc.root_player
        temp.rotation = atSelf.Rotation
        rotation = temp.rotation(type='float')
        rotation[0] = (rotation[0] * 1000 - CURSOR_R) / 1000

        dummy["$d"] = CURSOR_D
        dummy["$w"] = SCREEN_W
        dummy["$h"] = SCREEN_H

        positioned 0.0 0.0 0.0 summon marker function ./in_world_ui/do_plane_math:
            atSelf.Rotation = temp.rotation
            at @s function ./in_world_ui/iterate_ray:
                tp @s ^ ^ ^0.1 ~ ~
                particle happy_villager ~ ~ ~ 0 0 0 0 1
                dummy["$z"] = atSelf.Pos[2] * 100

                if score $z coc.dummy < $d coc.dummy positioned 0.0 0.0 0.0 if entity @s[distance=..8] at @s function ./in_world_ui/iterate_ray
                if score $z coc.dummy >= $d coc.dummy function ./in_world_ui/set_scores:

                    # Calculate the screen bounds, ex. width = 64, lower = -34, upper = 33, offset = 32
                    # Add 2 pixels of padding so moving the cursor of screen doesn't leave buttons hovered
                    dummy["$positiveXBound"] = dummy["$w"] / 2 + 1
                    dummy["$negativeXBound"] = (dummy["$w"] / 2 + 2) * -1 
                    dummy["$xOffset"] = dummy["$w"] / 2

                    # Same as above but for the y component
                    dummy["$positiveYBound"] = dummy["$h"] / 2 + 1
                    dummy["$negativeYBound"] = (dummy["$h"] / 2 + 2) * -1 
                    dummy["$yOffset"] = dummy["$h"] / 2

                    # Round to the nearest coordinate
                    dummy["$x"] = atSelf.Pos[0] * -16
                    dummy["$y"] = atSelf.Pos[1] * 16

                    def clamp(low, value, high):
                        return max(low, min(value, high))

                    dummy["$x"] = clamp(dummy["$negativeXBound"], dummy["$x"], dummy["$positiveXBound"]) + dummy["$xOffset"]
                    dummy["$y"] = clamp(dummy["$negativeYBound"], dummy["$y"], dummy["$positiveYBound"]) + dummy["$yOffset"]

            kill @s

        tag @s remove coc.root_player

        dummy["$r"] = CURSOR_R
        anchored eyes positioned ^ ^ ^ as @e[type=text_display,tag=coc.world_ui,distance=..3] function ./in_world_ui/track_player:
            rotation = atSelf.Rotation(type='float')
            rotation[0] = dummy["$r"] / 1000
            tp @s ~ ~ ~
            

        
def fix_rotation():
    rotation = atSelf.Rotation(type='float')
    rotation[0] = dummy["$r"] / 1000

class Screen:
    def __init__(self, name, w, h, d, children=[]):
        self.name = name.lower()
        self.w = w
        self.h = h
        self.d = d
        self.children = children

    def generate(self):
        append function f"coc:modules/ui/{self.name}/create":
            execute summon text_display:
                tag @s add coc.world_ui
                tag @s add f"coc.ui.{self.name}"
                for c in self.children:
                    c.render(self)

        tick_path = f"coc:modules/ui/{self.name}/tick"
        append function tick_path:
            for c in self.children:
                c.tick(self, tick_path)

        append function ./in_world_ui/track_player:
            if entity @s[tag=f"coc.ui.{self.name}"] on passengers function tick_path


class Element:
    def __init__(self, x, y, w, h):
        self.x = x
        self.y = y
        self.w = w
        self.h = h

    def get_translate(self, screen, depth):
        return [Float(((screen.w/2) - self.x) / 16) - 0.5, Float((self.y - (screen.h/2)) / 16), Float(screen.d - depth)]

    def render(self, screen, depth=0):
        pass

    def tick(self, parent, path):
        pass

    @classmethod
    def generic_tick(self):
        pass

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
                text: ('{"text": "' + self.default + '","font":"coc:default_ui"}'),
                alignment: "left",
                background: 0,
                Tags: ["coc.element", "coc.button", f"coc.button.{self.key}"],
                CustomName: ('{"text": "button.' + self.key + '"}')
            }  
            ride @s mount @e[type=text_display,tag=coc.parent,distance=..0.5,limit=1]
        tag @s remove coc.parent
    
    def tick(self, parent, path):
        if entity @s[tag=f"coc.button.{self.key}"] function (path + f"/{self.key}_tick"):
            fix_rotation()
            atSelf.text = '{"text": "' + self.default + '","font":"coc:default_ui"}'
            if score var CURSOR_X matches (self.x, self.x + self.w):
                if score var CURSOR_Y matches (self.y, self.y + self.h):
                    atSelf.text = '{"text": "' + self.hover + '","font":"coc:default_ui"}'



class Group(Element):
    def __init__(self, key, children=[]):
        super().__init__(0,0,0,0)
        self.children = children
        self.key = key

    def render(self, screen, depth=0):
        tag @s add coc.parent
        execute summon text_display:
            tag @s add coc.group
            tag @s add coc.element
            tag @s add f"coc.group.{self.key}"

            ride @s mount @e[type=text_display,tag=coc.parent,distance=..0.5,limit=1]
            tag @e[type=text_display,tag=coc.parent,distance=..0.5,limit=1] remove coc.parent
            for c in self.children:
                c.render(screen, depth + 0.0001) 
        tag @s remove coc.parent

    def tick(self, parent, path):
        if entity @s[tag=f"coc.group.{self.key}"] on passengers function (path + f"/{self.key}_tick"): 
            for c in self.children:
                c.tick(self, path + f"/{self.key}_tick")


Screen("test", 64f, 64f, 2, children=[
    Group("buttons", children=[
        Button("test", '\\uf001', '\\uf002',  0,  0,  16, 8),
        Button("test2", '\\uf001', '\\uf002', 48, 0,  16, 8),
        Button("test3", '\\uf001', '\\uf002', 0,  56, 16, 8),
        Button("test4", '\\uf001', '\\uf002', 48, 56, 16, 8),
        Button("test5", '\\uf001', '\\uf002', 32, 32, 16, 8)
    ])
]).generate()
