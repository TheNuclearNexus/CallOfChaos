
class Gear:
    def __init__(self, id, nbt={}):
        self.id = id

        self.nbt = nbt

    def replace(self, slot):
        if slot == 'weapon.armory':
            self.nbt['smithed'] = {id: "coc:armory"}
            if 'coc' not in self.nbt:
                self.nbt['coc'] = {transformed: 1b}
            else:
                self.nbt['coc'].transformed = 1b
                
            for slot in range(9):
                if score $slot coc.dummy matches slot item replace entity @s f"hotbar.{slot}" with self.id{**(self.nbt)}
        else: 
            if 'coc' not in self.nbt:
                self.nbt['coc'] = {armory: 1b}
            item replace entity @s slot with self.id{**(self.nbt)}
        


class Skill:
    conditions = []

    def __init__(self, pretty_name, description, conditions=[]):
        self.pretty_name = pretty_name
        self.description = description
        self.conditions = conditions

    def to_component(self):
        raise NotImplementedError("Not Implemented for base skill")

class ActiveSkill(Skill):
    def __init__(self, pretty_name, description, conditions = []):
        super().__init__(pretty_name, description, conditions)

    def to_component(self):
        return [
            {"text": self.pretty_name},"\n",
            {"text": "Type", "color": "gray"}," ",
            {"text": "Active", "color": "red"}, "\n",
            {"text": self.description}
        ]
    

class PassiveSkill(Skill):
    def __init__(self, pretty_name, description, body = None, conditions = []):
        super().__init__(pretty_name, description, conditions)
        if body != None:
            self.run = body

    def to_component(self):
        return [
            {"text": f"- {self.pretty_name} -"},"\n",
            {"text": "Type", "color": "gray"}," ",
            {"text": "Passive", "color": "green"}, "\n",
            {"text": self.description}
        ]

    def run(self):
        pass


VALID_SLOTS = ['armor.head','armor.chest','armor.legs','armor.feet','weapon.armory','weapon.offhand']

class Branch:
    skills = {}
    gear = {}

    def __init__(self, skills, gear={}):
        self.skills = skills

        self.gear = {
            "armor.head": Gear("netherite_helmet"),
            "armor.chest": Gear("netherite_chestplate"),
            "armor.legs": Gear("netherite_leggings"),
            "armor.feet": Gear("netherite_boots"),
            "weapon.armory": Gear("netherite_sword")
        }

        
        for k in gear:
            if k not in VALID_SLOTS:
                raise ValueError(f'{k} not one of {", ".join(VALID_SLOTS)}')
            self.gear[k] = gear[k]
        

class PlayerClass:
    branches = {}

    def __init__(self, branches):
        self.branches = branches