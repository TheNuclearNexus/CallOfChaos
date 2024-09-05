from bolt_expressions import Scoreboard
from contextlib import contextmanager


append function coc:global/load:
    scoreboard objectives add coc.astrology dummy

append function coc:global/tick:
    function ./astrology/tick

dummy = Scoreboard("coc.dummy")
astrology = Scoreboard("coc.astrology")

append function ~/tick:
    store result score $day coc.astrology time query day
    astrology["$day"] %= 128
    function ./astrology/track

tracked_cycles = []
tracked_frequencies = []

append function ~/track:
    store result score var dummy["$time"] time query daytime

@contextmanager
def astrology_event(time, days, location, time_frequency=0):
    if days not in tracked_cycles:
        tracked_cycles.append(days)
        append function ./astrology/track:
            dummy[f"$day_{days}"] = astrology["$day"] % days 

    if time_frequency != 0 and time_frequency not in tracked_frequencies:
        tracked_frequencies.append(time_frequency)
        append function ./astrology/track:
            dummy[f"$frequency_{time_frequency}"] = dummy["$time"] % time_frequency

    if score var dummy[f"$day_{days}"] matches 1 if score var dummy["$time"] matches time:
        if time_frequency != 0:
            if score var dummy[f"$frequency_{time_frequency}"] matches 0 function location:
                yield 
        else:
            execute function location:
                yield

