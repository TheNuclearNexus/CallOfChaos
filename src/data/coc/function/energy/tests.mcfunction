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
        NETWORK_UUID = "0-0-0-0-1"
        BUBBLE_UUID = "0-0-0-0-2"
        SINK_UUID = "0-0-0-0-3"
        
        with test("create_network"):
            with try_command("Failed to instantiate create network"):
                function ./api/create_network {
                    network_id: 1,
                    network_uuid: NETWORK_UUID
                }

            unless data storage coc:energy networks{keys: [{uuid: NETWORK_UUID}]} return:
                fail(f"Network database is missing key {NETWORK_UUID}")

            unless data storage coc:energy f'networks."{NETWORK_UUID}"' return:
                fail(f"Network database is missing entry {NETWORK_UUID}")

            unless data storage coc:energy f'networks."{NETWORK_UUID}".bubbles[{{uuid: "{NETWORK_UUID}"}}]' return:
                fail(f"Network entry is missing the bubble")

            return 1

        with test("create_bubble"):

            with try_command("Failed to instantiate create bubble"):
                function ./api/create_bubble {
                    network_uuid: NETWORK_UUID,
                    bubble_uuid: BUBBLE_UUID,
                    transfer: 16,
                    x: 0,
                    y: 64,
                    z: 0
                }

            unless data storage coc:energy f'networks."{NETWORK_UUID}".bubbles[{{ uuid: "{BUBBLE_UUID}" }}]' return:
                fail(f"Network entry is missing bubble {BUBBLE_UUID}")

            unless data storage coc:energy bubbles{keys: [{uuid: BUBBLE_UUID}]} return:
                fail(f"Bubble database is missing key {BUBBLE_UUID}")
            
            unless data storage coc:energy f'bubbles."{BUBBLE_UUID}"' return:
                fail(f"Bubble database is missing entry {BUBBLE_UUID}")

            return 1
        
        with test("create_sink"):
            with try_command("Failed to instantiate create sink"):
                function ./api/create_sink {
                    bubble_uuid: BUBBLE_UUID,
                    sink_uuid: SINK_UUID
                }

            unless data storage coc:energy f'bubbles."{BUBBLE_UUID}".sinks[{{ uuid: "{SINK_UUID}" }}]' return:
                fail(f"Bubble entry is missing sink {SINK_UUID}")

            unless data storage coc:energy f'sinks."{SINK_UUID}"' return:
                fail(f"Sink database is missing entry {SINK_UUID}")

            return 1

        with test("calculate_capacity"):
            with try_command("Failed to instantiate calculate capacity"):
                function ./api/calculate_capacity {
                    bubble_uuid: BUBBLE_UUID
                }
            
            unless data storage coc:energy f'bubbles."{BUBBLE_UUID}"{{max_capacity: 150}}' return:
                tellraw @a {"nbt": f'bubbles."{BUBBLE_UUID}".max_capacity', "storage": "coc:energy"}
                fail(f"Max capacity was not 150")

            return 1


        with test("get_bubble"):
            positioned 0 0 0 summon item_display:
                function ./api/get_bubble
                kill @s

            unless data storage coc:temp bubble_uuid return:
                fail("Marker was not in network's bubble") 
            unless data storage coc:temp {bubble_uuid: NETWORK_UUID} return:
                fail("Marker was in the wrong bubble")  
            
            positioned 0 64 0 summon item_display:
                function ./api/get_bubble
                kill @s

            unless data storage coc:temp bubble_uuid return:
                fail(f"Marker was not in any bubble, should have been {BUBBLE_UUID}")  
 
            unless data storage coc:temp {bubble_uuid: BUBBLE_UUID} return:
                fail(f"Marker was not in bubble {BUBBLE_UUID}")  

            positioned 0 128 0 summon item_display:
                function ./api/get_bubble
                kill @s

            if data storage coc:temp bubble_uuid return:
                fail(f"Marker was in any bubble, should have been in none")  
 



        with test("destroy_sink"):

            with try_command("Failed to instantiate destroy sink"):
                function ./api/destroy_sink {
                    sink_uuid: SINK_UUID
                }

            if data storage coc:energy f'sinks."{SINK_UUID}"' return:
                fail(f"Sink database still contains {SINK_UUID}")

            if data storage coc:energy f'bubbles."{BUBBLE_UUID}".sinks[{{uuid: "{SINK_UUID}"}}]' return:
                fail(f"Bubble entry still has sink {SINK_UUID}")

            return 1

        with test("destroy_bubble"):
            with try_command("Failed to instantiate create sink"):
                function ./api/create_sink {
                    bubble_uuid: BUBBLE_UUID,
                    sink_uuid: SINK_UUID
                }


            with try_command("Failed to instantiate destroy bubble"):
                function ./api/destroy_bubble {
                    bubble_uuid: BUBBLE_UUID
                }

            if data storage coc:energy f'bubbles."{BUBBLE_UUID}"' return:
                fail(f"Bubble database still contains {BUBBLE_UUID}")

            if data storage coc:energy f'bubbles.keys[{{uuid: "{BUBBLE_UUID}"}}]' return:
                fail(f"Bubble database still has key {BUBBLE_UUID}")
                
            if data storage coc:energy f'networks."{NETWORK_UUID}".bubbles[{{uuid: "{BUBBLE_UUID}"}}]' return:
                fail(f"Network entry still has bubble {BUBBLE_UUID}")

            if data storage coc:energy f'sinks."{SINK_UUID}".bubbles[{{uuid: "{BUBBLE_UUID}"}}]' return:
                fail(f"Sink entry still has bubble {BUBBLE_UUID}")

            with try_command("Failed to instantiate destroy sink"):
                function ./api/destroy_sink {
                    sink_uuid: SINK_UUID
                }

            return 1

        with test("destroy_network"):
            

            with try_command("Failed to instantiate create bubble"):
                function ./api/create_bubble {
                    bubble_uuid: BUBBLE_UUID,
                    network_uuid: NETWORK_UUID,
                    transfer: 16,
                    x: 0,
                    y: 64,
                    z: 0
                }

            with try_command("Failed to instantiate create sink"):
                function ./api/create_sink {
                    bubble_uuid: BUBBLE_UUID,
                    sink_uuid: SINK_UUID
                }

            with try_command("Failed to instantiate destroy network"):
                function ./api/destroy_network {
                    network_uuid: NETWORK_UUID
                }

            if data storage coc:energy f'networks."{NETWORK_UUID}"' return:
                fail(f"Network database still contains {NETWORK_UUID}")

            if data storage coc:energy f'networks.keys[{{uuid: "{NETWORK_UUID}"}}]' return:
                fail(f"Network database still has key {NETWORK_UUID}")
                
            if data storage coc:energy f'bubbles."{BUBBLE_UUID}".networks[{{uuid: "{NETWORK_UUID}"}}]' return:
                fail(f"Bubble entry still has network {BUBBLE_UUID}")

            return 1

