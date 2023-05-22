from nbtlib import Byte, Compound
from coc:modules/playerdb import PlayerDB

from ./armory/shared import PassiveSkill
from ./armory/guardian import GUARDIAN



class ClassRegistry:
    registered_classes = {
        "guardian": GUARDIAN
    }

    @classmethod
    def set_gear(self):
        player_data = PlayerDB.selected.data
        armory_data = player_data.armory

        for c in self.registered_classes:
            cur_class = self.registered_classes[c]
            for b in cur_class.branches:
                branch = cur_class.branches[b]
                if data var armory_data({"class": c, "branch": b}) function (./armory/classes/ + f"/{c}/{b}/set_gear"):
                    for g in branch.gear:
                        branch.gear[g].replace(g)

    @classmethod
    def run_passives(self):
        armory_data = PlayerDB.selected.data.armory

        for c in self.registered_classes:
            cur_class = self.registered_classes[c]
            for b in cur_class.branches:
                branch = cur_class.branches[b]
                if data var armory_data({"class": c, "branch": b}) function (./armory/classes/ + f"/{c}/{b}/passives"):
                    for s in branch.skills:
                        skill = branch.skills[s]

                        if isinstance(skill,PassiveSkill):
                            skill.run()