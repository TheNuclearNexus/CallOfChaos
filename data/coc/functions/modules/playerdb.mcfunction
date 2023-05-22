from bolt_expressions import Scoreboard, Data

database = Data.storage("coc:player").db
dummy = Scoreboard("coc.dummy")
player_id = Scoreboard("coc.player_id")

NUMBER_OF_BITS = 4

DEFAULT_DATA = {
    "armory": {
        "class": "none",
        "branch": "none"
    }
}
    

append function ./playerdb/to_bits:
    for i in range(NUMBER_OF_BITS):
        dummy[f"$bit{i}"] = dummy["$temp"] % 2
        dummy["$temp"] /= 2

append function ./playerdb/filter:
    dummy["$temp"] = player_id["@s"]
    function ./playerdb/to_bits

    data modify storage coc:player db[].matches set value true

    for i in range(NUMBER_OF_BITS):
        bit = f"$bit{i}"
        if score bit coc.dummy matches 0:
            raw ("data modify storage coc:player db[{" + bit[1:] + ":true}].matches set value false")
        if score bit coc.dummy matches 1:
            raw ("data modify storage coc:player db[{" + bit[1:] + ":false}].matches set value false")


append function ./playerdb/get:
    function ./playerdb/filter

    data remove storage coc:player selected
    data modify storage coc:player selected set from storage coc:player db[{matches: true}]

append function ./playerdb/setup:
    dummy["$temp"] = player_id["@s"]
    function ./playerdb/to_bits

    selected_player = Data.storage("coc:player").selected
    selected_player = {data: DEFAULT_DATA}
    
    for i in range(NUMBER_OF_BITS):
        bit = f"$bit{i}"
        if score bit coc.dummy matches 0:
            raw (f"data modify storage coc:player selected.bit{i} set value false")
        if score bit coc.dummy matches 1:
            raw (f"data modify storage coc:player selected.bit{i} set value true")

    database.append(selected_player)

append function ./playerdb/set:
    function ./playerdb/filter
    data modify storage coc:player db[{matches: true}].data set from storage coc:player selected.data


append function ./playerdb/reset:
    data modify storage coc:player selected.data set value DEFAULT_DATA
    function ./playerdb/set

class PlayerDB:
    selected = Data.storage("coc:player").selected
    @classmethod
    def get(self):
        function ./playerdb/get
        return self.selected
    @classmethod
    def set(self):
        function ./playerdb/set
    @classmethod
    def setup(self):
        function ./playerdb/setup
