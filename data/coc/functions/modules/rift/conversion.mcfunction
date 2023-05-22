from bolt_expressions import Data, Scoreboard
from ./rates import CONVERSION_COST, CONVERSION_BURST_TIME

self = Data.entity("@s")
itemConversion = self.item.tag.coc.conversion
tempStorage = Data.storage("coc:temp")
dummy = Scoreboard("coc.dummy")


class Conversion:
    def generateValidation(self):
        append function_tag coc:rift/conversion/validate {
            "values": [
                f"coc:modules/conversion/{self.id}/validate"
            ]
        }

        append function f"coc:modules/conversion/{self.id}/validate":
            if "tag" in self.input:
                if data storage coc:temp input{id: self.input.id, tag: self.input.tag} 
                    data modify storage coc:temp conversion set value {id: self.id, decay: self.decay, target: self.target}
            else:
                if data storage coc:temp input{id: self.input.id}:
                    data modify storage coc:temp conversion set value {id: self.id, decay: self.decay, target: self.target}

    def generateConvert(self):
        append function_tag coc:rift/conversion/convert {
            "values": [
                f"coc:modules/conversion/{self.id}/convert"
            ]
        }

        append function f"coc:modules/conversion/{self.id}/convert":
            if data storage coc:temp conversion{id: self.id}:
                loot replace entity @s container.0 loot self.output

    def __init__(self, id, input, decay, target, output):
        self.id = id
        self.input = input
        self.decay = decay
        self.target = target
        self.output = output

        self.generateValidation()
        self.generateConvert()

#> CONVERSION DEFINITIONS
Conversion('chaos_crystal', {id: "minecraft:diamond"}, 1, 400, coc:item/chaos_crystal)
# ####################################

# Copy all the conversion params into scores
tempStorage.conversion = itemConversion
dummy["$decay"] = tempStorage.conversion.decay
dummy["$target"] = tempStorage.conversion.target
dummy["$current"] = tempStorage.conversion.current

# We use another variable for rate so we don't mutate the originals state
dummy["$rate"] = 0
dummy["$step"] = dummy["$gameTime"] % CONVERSION_BURST_TIME
if score $capacity coc.dummy matches f"{CONVERSION_COST}.."function ./conversion/consume_capacity:
    dummy["$capacity"] -= CONVERSION_COST
    
    dummy["$rate"] = dummy["$productionRate"]

if score $step coc.dummy matches 0:
    dummy["$current"] = max(0, dummy["$current"] + (dummy["$rate"] * CONVERSION_BURST_TIME))
unless score $step coc.dummy matches 0:
    dummy["$current"] = max(0, dummy["$current"] - dummy["$decay"])

if score $current coc.dummy >= $target coc.dummy function ./conversion/complete:
    function #coc:rift/conversion/convert
    tempStorage.output = self.item

    # We use relative coords here in order to run from the apparent position of the item display
    summon item ^2 ^1 ^ {Item:{id: "minecraft:stone", Count:1b},Tags:["coc.converted_item"]}
    positioned ^2 ^1 ^ as @e[type=item,tag=coc.converted_item,distance=..0.5] data modify entity @s Item set from storage coc:temp output
    particle minecraft:flash ^2 ^1 ^ 0 0 0 0 1

    # Remove the tag from the item so it isn't included in the rotation calculation
    tag @s remove coc.conversion_item
    on vehicle function ./conversion/correct_rotations
    on passengers kill @s
    kill @s
if score $current coc.dummy < $target coc.dummy function ./conversion/still_processing:
    itemConversion.current = dummy["$current"]

    # Only update the bar every 5 ticks and if theres a player nearby 
    if score $playerNear coc.dummy matches 1 function ./conversion/generate_bar

append function ./conversion/generate_bar:
    data modify storage coc:temp segments set value []
    segments = tempStorage.segments

    def add(char, color='white'):
        segments.append('{"text": "' + char + '", "color": "' + color + '"}')

    # We change the arrow if its 1x 2x 3x more or less than the decay rate
    if score $rate coc.dummy > $decay coc.dummy:
        dummy["$2xdecay"] = dummy["$decay"] * 2
        dummy["$3xdecay"] = dummy["$decay"] * 3
        if score $rate coc.dummy >= $3xdecay coc.dummy:
            add('6 ')
        if score $rate coc.dummy >= $2xdecay coc.dummy if score $rate coc.dummy < $3xdecay coc.dummy:
            add('5 ')
        if score $rate coc.dummy < $2xdecay coc.dummy if score $rate coc.dummy < $3xdecay coc.dummy:
            add('4 ')
    if score $rate coc.dummy <= $decay coc.dummy:
        dummy["$2xrate"] = dummy["$rate"] * 2
        dummy["$3xrate"] = dummy["$rate"] * 3
        if score $3xrate coc.dummy <= $decay coc.dummy:
            add('1 ')
        if score $2xrate coc.dummy <= $decay coc.dummy if score $3xrate coc.dummy > $decay coc.dummy:
            add('2 ')
        if score $2xrate coc.dummy > $decay coc.dummy if score $3xrate coc.dummy > $decay coc.dummy:
            add('3 ')

    dummy["$percent"] = dummy["$current"] * 100 / dummy["$target"]

    stepSize = int(100/21)
    beginning = stepSize
    end = 100
    for i in range(beginning, end, stepSize):
        if score $percent coc.dummy matches f"{i}..":
            if i == beginning:
                add('[')
            elif i == end-stepSize:
                add(']')
            elif (i/stepSize) % 2 == 0:
                add('=')
            else:
                add('*')
        unless score $percent coc.dummy matches f"{i}..":
            if i == beginning:
                add('(')
            elif i == end-stepSize:
                add(')')
            elif (i/stepSize) % 2 == 0:
                add('-')
            else:
                add('~')         

    on passengers data modify entity @s text set value '{"nbt": "segments[]", "storage": "coc:temp", "interpret": true, "separator": "S", "font": "coc:conversion"}'

append function ./conversion/correct_rotations:
    scoreboard players set $temp coc.dummy 0
    on passengers if entity @s[tag=coc.conversion_item] scoreboard players add $temp coc.dummy 1

    dummy["$rotationStep"] = 360 / dummy["$temp"]
    dummy["$rotation"] = 0

    on passengers if entity @s[tag=coc.conversion_item] function ./conversion/rotate:   
        rotation = self.Rotation(type="float")

        rotation[0] = dummy["$rotation"]
        on passengers:
            rotation[0] = dummy["$rotation"]
        dummy["$rotation"] += dummy["$rotationStep"]

append function ./conversion/interact:
    scoreboard players set $temp coc.dummy 0
    on passengers if entity @s[tag=coc.conversion_item] scoreboard players add $temp coc.dummy 1

    # Make sure to cap the result to 16 items at any point
    if data storage coc:temp Mainhand if score $temp coc.dummy matches ..15 function ./add_item:
        tempStorage.input = tempStorage.Mainhand
        tempStorage.conversion.remove()
        function #coc:rift/conversion/validate

        # conversion will only be set if validate found a proper result
        if data storage coc:temp conversion function ./conversion/create_display:
            tag @s add coc.parent
            execute summon item_display function ./conversion/setup_display:
                tag @s add coc.conversion_item
                
                self.item = tempStorage.Mainhand
                itemConversion = tempStorage.conversion

                ride @s mount @e[type=item_display,tag=coc.parent,distance=..0.5,limit=1]

                self.transformation = {
                    translation: [2f, 1f, 0f],
                    scale: [0.5f, 0.5f, 0.5f],
                    left_rotation: [0f, 0f, 0f, 1f],
                    right_rotation: [0f, 0f, 0f, 1f]
                }

                tag @s add coc.bound_item

                append function ./convesion/setup_text:
                    self.transformation = tempStorage.transformation
                    self.background = 0
                    # This view_range is approximately 24 blocks
                    self.view_range = 0.1875

                    ride @s mount @e[type=item_display,tag=coc.bound_item,distance=..0.5,limit=1]

                def createText(rotation):
                    tempStorage.transformation = {
                        translation: [2f, 1.5f, 0f],
                        scale: [1f, 1f, 1f],
                        left_rotation: rotation,
                        right_rotation: [0f, 0f, 0f, 1f]
                    }
                    execute summon text_display function ./convesion/setup_text

                # Use 2 text displays so they have a back side
                createText([0f,0f,0f,1f])
                createText([0f,-1f,0f,0f])
                tag @s remove coc.bound_item
            tag @s remove coc.parent

            function ./conversion/correct_rotations

            on passengers if entity @s[type=interaction] on target item modify entity @s[gamemode=!creative,gamemode=!spectator] weapon.mainhand coc:reduce_count/1
