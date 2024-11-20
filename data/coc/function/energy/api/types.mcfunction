from nbtlib import Compound

class Sink(Compound):
    def __init__(self):
        self["uuid"] = ""
        self["capacity"] = 50
        self["consumption"] = 2

class Bubble(Compound):
    def __init__(self):
        self["uuid"] = ""
        self["sinks"] = []
        self["radius"] = 16
        self["base_capacity"] = 100
        self["max_capacity"] = self["base_capacity"]
        self["capacity"] = 0

        self["x"] = 0
        self["y"] = 64
        self["z"] = 0

        self["transfer"] = 0

class Network(Compound):
    def __init__(self):
        self["id"] = 0
        self["bubbles"] = []
        self["uuid"] = ""