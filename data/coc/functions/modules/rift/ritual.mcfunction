from bolt_expressions import Data, Scoreboard

thisEntity = Data.entity("@s")
tempStorage = Data.storage("coc:temp")
dummy = Scoreboard("coc.dummy")

class ItemCircle:
    type='item'
    def test(self, id, center, x, z):
        if data storage coc:temp chalk[{type: self.type, x: (x - center[0]), z: (z - center[1]), item: self.data}]:
            scoreboard players add $valid coc.dummy 1

    @classmethod
    def resolve(self):
        if entity @s[tag=f"coc.{self.type}"] function f"coc:item/chalk/interact/resolve_{self.type}":
            tempStorage.chalk.append({type: self.type, x: 0, z: 0, item: {}})
            on passengers if entity @s[type=item]:
                tempStorage.chalk[-1].item = thisEntity.Item

    def __init__(self, data):
        self.data = data


class OutputCircle(ItemCircle):
    type='output'
    def test(self, id, center, x, z):
        super().test(id, center, x, z)

        for name, multi in zip(MIRROR_NAMES, MIRROR_MULTIS):
            append function f"coc:modules/ritual/{id}/spawn_output_{name}":
                loot spawn f"~{(x - center[0]) * multi[0]} ~ ~{(z - center[1]) * multi[1]}" loot self.loot_table

    def __init__(self, data, loot_table):
        self.data = data
        self.loot_table = loot_table









MIRROR_NAMES = ['default', 'x_mirror', 'z_mirror', 'xz_mirror']
MIRROR_MULTIS = [(1, 1),(-1, 1),(1, -1),(-1, -1)]

class Ritual:
    def generate(self):
        append function_tag coc:ritual/run {
            "values": [
                f"coc:modules/ritual/{self.id}"
            ]
        }

        append function f"coc:modules/ritual/{self.id}":
            total = 0
            scoreboard players set $valid coc.dummy 0
            for z in range(len(self.pattern)):
                for x in range(len(self.pattern[z])):
                    cell = self.pattern[z][x]
                    if cell == ' ' or cell == 'A':
                        continue
                    
                    total += 1
                    if cell == '.':
                        if data storage coc:temp chalk[{type: 'dot', x: (x - self.center[0]), z: (z - self.center[1])}]:
                            scoreboard players add $valid coc.dummy 1
                    else:
                        circle = self.dictionary[cell]

                        circle.test(self.id, self.center, x, z)

            if score $valid coc.dummy matches total function f"coc:modules/ritual/{self.id}/passed":
                    scoreboard players set $passed coc.dummy 1

                    for idx, name in zip(range(len(MIRROR_NAMES)), MIRROR_NAMES):
                        if score $mode coc.dummy matches idx function f"coc:modules/ritual/{self.id}/spawn_output_{name}"

                    if self.function != None:
                        function self.function
    def __init__(self, id, pattern, dictionary, loot_table=None, function=None):
        activators = 0
        self.center = (0,0)
        self.id = id
        for z in range(len(pattern)):
            for x in range(len(pattern[z])):
                if pattern[z][x] not in dictionary and pattern[z][x] not in [" ", "\n", ".", "A"]:
                    raise ValueError(f"{pattern[z][x]} not in dict!")
                if pattern[z][x] == "A":
                    if activators == 0:
                        self.center = (x,z)
                    activators += 1
        if activators == 0 or activators > 1:
            raise ValueError("Pattern must contain one Activator!")

        self.pattern = pattern
        self.dictionary = dictionary
        self.function = function
        self.loot_table = loot_table
        self.generate()

test = Ritual(
    id='test', 
    pattern=[
        '.A.',
        'O O',
        '. .',
        'C.I'
    ],
    dictionary={
        "C": ItemCircle({tag:{smithed:{id: "coc:chaos_crystal"}}}),
        "O": ItemCircle({id: "minecraft:obsidian"}),
        "I": ItemCircle({id: "minecraft:iron_ingot"})
    },
    function=./ritual/test/on_pass
)
append function test.function:
    loot spawn ~ ~ ~ loot coc:item/blight_steel