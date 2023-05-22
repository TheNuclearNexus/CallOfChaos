from contextlib import contextmanager
from bolt_expressions import Scoreboard, Data

dummyObj = Scoreboard("coc.dummy")
uuidScore = dummyObj["$uuid"]
selfData = Data.entity("@s")

@contextmanager
def create():
    execute positioned -30000000 320 3200 summon text_display function ./relation_stack/_initialize:
        tag @s add coc.relation_stack
        yield


def remove(uuid=None):
    if uuid is not None:
        uuidScore = uuid

    on passengers function ./relation_stack/_remove:
        dummyObj["$entryUUID"] = selfData.UUID[0]
        if score $entryUUID coc.dummy = $uuid coc.dummy kill @s

def add(selector):
    tag @s add coc.target_stack
    execute summon snowball:
        tag @s add coc.relation_entry
        ride @s mount @e[type=text_display,tag=coc.target_stack,limit=1]
        selfData.Owner = Data.entity(selector).UUID
        uuidScore = selfData.UUID[0]
    tag @s remove coc.target_stack
    return uuidScore
