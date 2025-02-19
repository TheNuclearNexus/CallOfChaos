from contextlib import contextmanager

FIELDS = [
    ("coc:energy", "networks"),
    ("coc:energy", "bubbles"),
    ("coc:energy", "sinks")
]

@contextmanager
def suite(fields):
    positioned 0 0 0 function ~/suite:
        scoreboard players set #tests_ran coc.dummy 0
        scoreboard players set #tests_failed coc.dummy 0

        for field in fields:
            data modify storage coc:tests f'temp."{field[0]}"."{field[1]}"' set from storage field[0] field[1]
            data remove storage field[0] field[1]

        tellraw @a ""

        yield 

        tellraw @a ""

        for field in fields:
            data modify storage field[0] field[1] set from storage coc:tests f'temp."{field[0]}"."{field[1]}"' 
    
        tellraw @a [{"text": "Ran ", "color": "gray"},{"score": {"objective": "coc.dummy", "name": "#tests_ran"}, "color": "white"}, " test(s)."]
        if score #tests_failed coc.dummy matches 1..:
            tellraw @a [{"text": "", "color": "gray"},{"score": {"objective": "coc.dummy", "name": "#tests_failed"}, "color": "red"}, " test(s) failed."]

    
@contextmanager
def test(path: str):    
    data modify storage coc:tests message set value {text: "Failed to execute test"}

    store success score #success coc.dummy function ~/{path}:
        yield

    if score #success coc.dummy matches 0 tellraw @a [
        {"text": "", "color":"gray"},
        {"text":"⬛", "color": "red"},
        " - [",{"text": f"{path}", "color": "white"},"]:\n    ",
        {"nbt": "message", "storage": "coc:tests", "interpret": true, "color": "red"},
    ]
    if score #success coc.dummy matches 0 scoreboard players add #tests_failed coc.dummy 1
    if score #success coc.dummy matches 1 tellraw @a [
        {"text": "", "color":"gray"},
        {"text":"⬛", "color": "green"},
        " - [",{"text": f"{path}", "color": "white"},"]"
    ]

    scoreboard players add #tests_ran coc.dummy 1


def set_message(message_text: str):
    data modify storage coc:tests message set value {text: message_text}

@contextmanager
def try_command(message_text: str, successful: bool = True):
    store success score #success coc.dummy:
        yield

    value = 1
    if not successful:
        value = 0

    unless score #success coc.dummy matches value return:
        fail(message_text)

def fail(message_text: str):
    set_message(message_text)
    return fail


if is_debug():
    with suite(FIELDS):
        NETWORK_UUID = "00000000-0000-0000-0000-000000000001"
        BUBBLE_UUID = "00000000-0000-0000-0000-000000000002"
        SINK_UUID = "00000000-0000-0000-0000-000000000003"

        summon item_display ~ ~ ~ {UUID: [I; 0,0,0,1], item: {id: "minecraft:stone"}} 
        summon item_display ~ 64 ~ {UUID: [I; 0,0,0,2], item: {id: "minecraft:stone"}} 
        summon item_display ~ 64 ~ {UUID: [I; 0,0,0,3], item: {id: "minecraft:stone"}} 
        
        with test("create_network"):
            as NETWORK_UUID at @s:
                with try_command("Failed to instantiate create network"):
                    function ./api/network/register {
                        network_uuid: NETWORK_UUID
                    }

            unless data storage coc:energy networks{keys: [{uuid: NETWORK_UUID}]} return:
                fail(f"Network database is missing key {NETWORK_UUID}")

            unless data storage coc:energy f'networks."{NETWORK_UUID}"' return:
                fail(f"Network database is missing entry {NETWORK_UUID}")

            unless data storage coc:energy f'networks."{NETWORK_UUID}".bubbles[{{uuid: "{NETWORK_UUID}"}}]' return:
                tellraw @a {"nbt": "networks", "storage": "coc:energy"}
                fail(f"Network entry is missing the bubble")

            return 1

        with test("create_bubble"):
            as BUBBLE_UUID at @s:
                with try_command("Failed to instantiate create bubble"):
                    function ./api/bubble/register

            unless data storage coc:energy f'networks."{NETWORK_UUID}".bubbles[{{ uuid: "{BUBBLE_UUID}" }}]' return:
                fail(f"Network entry is missing bubble {BUBBLE_UUID}")

            unless data storage coc:energy bubbles{keys: [{uuid: BUBBLE_UUID}]} return:
                fail(f"Bubble database is missing key {BUBBLE_UUID}")
            
            unless data storage coc:energy f'bubbles."{BUBBLE_UUID}"' return:
                fail(f"Bubble database is missing entry {BUBBLE_UUID}")

            return 1
        
        with test("create_sink"):
            as SINK_UUID at @s:
                with try_command("Failed to instantiate create sink"):
                    function ./api/sink/register

            unless data storage coc:energy f'bubbles."{BUBBLE_UUID}".sinks[{{ uuid: "{SINK_UUID}" }}]' return:
                fail(f"Bubble entry is missing sink {SINK_UUID}")

            unless data storage coc:energy f'sinks."{SINK_UUID}"' return:
                fail(f"Sink database is missing entry {SINK_UUID}")

            return 1

        with test("calculate_capacity"):
            with try_command("Failed to instantiate calculate capacity"):
                function ./api/bubble/calculate_capacity {
                    bubble_uuid: BUBBLE_UUID
                }
            
            unless data storage coc:energy f'bubbles."{BUBBLE_UUID}"{{max_capacity: 150}}' return:
                tellraw @a {"nbt": f'bubbles."{BUBBLE_UUID}".max_capacity', "storage": "coc:energy"}
                fail(f"Max capacity was not 150")

            return 1


        with test("get_bubble"):
            positioned 0 0 0 summon item_display:
                function ./api/sink/get_bubble
                kill @s

            unless data storage coc:temp bubble_uuid return:
                fail("Marker was not in network's bubble") 
            unless data storage coc:temp {bubble_uuid: NETWORK_UUID} return:
                fail("Marker was in the wrong bubble")  
            
            positioned 0 64 0 summon item_display:
                function ./api/sink/get_bubble
                kill @s

            unless data storage coc:temp bubble_uuid return:
                fail(f"Marker was not in any bubble, should have been {BUBBLE_UUID}")  
 
            unless data storage coc:temp {bubble_uuid: BUBBLE_UUID} return:
                fail(f"Marker was not in bubble {BUBBLE_UUID}")  

            positioned 0 128 0 summon item_display:
                function ./api/sink/get_bubble
                kill @s

            if data storage coc:temp bubble_uuid return:
                fail(f"Marker was in any bubble, should have been in none")  
 



        with test("destroy_sink"):

            as SINK_UUID:
                with try_command("Failed to instantiate destroy sink"):
                    function ./api/sink/unregister

            if data storage coc:energy f'sinks."{SINK_UUID}"' return:
                fail(f"Sink database still contains {SINK_UUID}")

            if data storage coc:energy f'bubbles."{BUBBLE_UUID}".sinks[{{uuid: "{SINK_UUID}"}}]' return:
                fail(f"Bubble entry still has sink {SINK_UUID}")

            return 1

        with test("destroy_bubble"):

            as SINK_UUID at @s:
                with try_command("Failed to instantiate create sink"):
                    function ./api/sink/register

            as BUBBLE_UUID:
                with try_command("Failed to instantiate destroy bubble"):
                    function ./api/bubble/unregister 

            if data storage coc:energy f'bubbles."{BUBBLE_UUID}"' return:
                fail(f"Bubble database still contains {BUBBLE_UUID}")

            if data storage coc:energy f'bubbles.keys[{{uuid: "{BUBBLE_UUID}"}}]' return:
                fail(f"Bubble database still has key {BUBBLE_UUID}")
                
            if data storage coc:energy f'networks."{NETWORK_UUID}".bubbles[{{uuid: "{BUBBLE_UUID}"}}]' return:
                fail(f"Network entry still has bubble {BUBBLE_UUID}")

            if data storage coc:energy f'sinks."{SINK_UUID}".bubbles[{{uuid: "{BUBBLE_UUID}"}}]' return:
                fail(f"Sink entry still has bubble {BUBBLE_UUID}")
                
            return 1

        with test("destroy_network"):
            
            as BUBBLE_UUID at @s:
                with try_command("Failed to instantiate create bubble"):
                    function ./api/bubble/register

            as SINK_UUID at @s:
                with try_command("Failed to instantiate create sink"):
                    function ./api/sink/register

            as NETWORK_UUID:
                with try_command("Failed to instantiate destroy network"):
                    function ./api/network/unregister

            if data storage coc:energy f'networks."{NETWORK_UUID}"' return:
                fail(f"Network database still contains {NETWORK_UUID}")

            if data storage coc:energy f'networks.keys[{{uuid: "{NETWORK_UUID}"}}]' return:
                fail(f"Network database still has key {NETWORK_UUID}")
                
            if data storage coc:energy f'bubbles."{BUBBLE_UUID}".networks[{{uuid: "{NETWORK_UUID}"}}]' return:
                fail(f"Bubble entry still has network {BUBBLE_UUID}")

            return 1

        kill NETWORK_UUID
        kill BUBBLE_UUID
        kill SINK_UUID