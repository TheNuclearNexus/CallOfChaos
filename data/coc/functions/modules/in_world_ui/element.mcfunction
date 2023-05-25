from bolt_expressions import Scoreboard, Data
VIEW_RANGE = Float(0.000005)

dummy = Scoreboard("coc.dummy")
atSelf = Data.entity("@s")

def fix_rotation():
    rotation = atSelf.Rotation(type='float')
    rotation[0] = dummy["$r"] / 1000

class Element:
    def __init__(self, x, y, w, h):
        self.x = int(x)
        self.y = int(y)
        self.w = int(w)
        self.h = int(h)

    def get_translate(self, screen, depth, offset=0.5):
        return [Float(((screen.w/2) - self.x - (self.w/2)) / 16), Float((self.y - (screen.h/2)) / 16), Float(screen.d - depth)]

    def render(self, screen, depth=0):
        pass

    def tick(self, screen, parent, path):
        pass

    @classmethod
    def generic_tick(self):
        pass
