from ./shared import PlayerClass, Branch, PassiveSkill, Gear
from nbtlib import Compound



class LuminousSkill(PassiveSkill):
    def __init__(self):
        super().__init__("Luminous", "Provide faint light in dark areas")
    def run(self):
        align xyz positioned ~.5 ~1 ~.5 if block ~ ~ ~ #coc:air unless entity @e[type=marker,tag=coc.luminous,distance=..0.5] summon marker:
            tag @s add coc.luminous
            tag @s add coc.marker
            setblock ~ ~ ~ light[level=6]

        append function coc:entity/marker/tick:
            if entity @s[tag=coc.luminous] function ./guardian/luminous:
                positioned ~-.5 ~ ~-.5 unless entity @a[dx=0] if block ~ ~ ~ light function ./guardian/luminous/reset:
                    setblock ~ ~ ~ air
                    kill @s


GUARDIAN = PlayerClass({
    "radiant": Branch(
        skills = {
            "luminous": LuminousSkill()
        }, 
        gear = {
            "weapon.armory": Gear("netherite_sword", Compound({display: {Name: '{"text":"shit"}'}}))
        }),
    "infernal": Branch({
        "flame_retardant": PassiveSkill("Flame Retardant", "Damage received from flames is reduced by 10%")
    })
})