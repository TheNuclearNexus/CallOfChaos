from pathlib import Path
class Ritual:
    def createCheck(self):
        checkFunctionPath = coc:modules/ritual + f"/{self.id}"


        append function_tag coc:rift/ritual {
            "values": [
                checkFunctionPath
            ]
        }

        append function checkFunctionPath:
            scoreboard players set $passed coc.dummy 0
            for idx in range(len(self.ingredients)):
                ingredient = self.ingredients[idx]

                tempScore = f"$ingr_{idx}"

                if "tag" in ingredient:
                    store result score tempScore coc.dummy if data storage coc:temp ingredients[{id: ingredient.id, tag: ingredient.tag}]
                else:
                    store result score tempScore coc.dummy if data storage coc:temp ingredients[{id: ingredient.id}]


                if score tempScore coc.dummy matches f"{ingredient.Count}":
                    scoreboard players add $passed coc.dummy 1

            if score $passed coc.dummy matches len(self.ingredients) 
                    function (checkFunctionPath + "/success"):
                scoreboard players set $suc coc.dummy 1
                if self.loot_table != None:
                        loot replace entity @s container.0 loot self.loot_table
                if self.function != None:
                    function self.function

    def __init__(self, id, ingredients, loot_table=None, function=None, knowledge_level=0):
        self.id = id
        self.ingredients = ingredients
        self.loot_table = loot_table
        self.function = function
        self.knowledge_level = knowledge_level
        
        self.createCheck()


Ritual("binding", 
    ingredients=[{id: "minecraft:potion", tag:{smithed:{id: "coc:blood_vial"}}, Count: 1}], 
    function='coc:modules/ritual/binding/bind'
)
append function coc:modules/ritual/binding/bind:
    store result score $playerId coc.dummy data get storage coc:temp ingredients[{tag: {smithed: {id: "coc:blood_vial"}}}].tag.coc.player

    as @a if score $playerId coc.dummy = @s coc.player_id unless score @s coc.rift_id matches 0..:
        scoreboard players operation @s coc.rift_id = $riftId coc.dummy

Ritual("test_item",
    ingredients=[{id: 'minecraft:stone', Count: 1}],
    loot_table="coc:item/chaos_crystal"
)
