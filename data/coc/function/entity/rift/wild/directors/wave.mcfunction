import math
# The initial number of credits the director starts with
# multiplied by the number of players around the director 
# when it is first initialized
CREDIT_INITIAL = 200
# Used as the base amount of credits per second
CREDIT_BASE = 4
# Maximum amount of entities to spawn
MAX_ENTITIES = 20

# This is used so that I don't need to type a long ass path for data modify commands
# i.e. laziness
WAVE_CREDITS_LOCATION = 'item.components."minecraft:custom_data".coc.wave_credits' 
WAVE_DURATION_LOCATION = 'item.components."minecraft:custom_data".coc.wave_duration'

# pool of mobs to pull from,
# id:     type of mob
# cost:   number of credits that are required
# weight: how likely it is to spawn
POOL = [
    {
        "id": "minecraft:zombie",
        "cost": 20,
        "weight": 100
    },
    {
        "id": "minecraft:skeleton",
        "cost": 20,
        "weight": 50
    }
]

# Total weight of the pool
TOTAL_WEIGHT = 0
for card in POOL:
    TOTAL_WEIGHT += card["weight"]

# Setup any constants that we may need
set_const(2)
set_const(10)
set_const(60)

def load_credits():
    store result score #credits coc.dummy data get entity @s WAVE_CREDITS_LOCATION

def save_credits():
    store result entity @s WAVE_CREDITS_LOCATION int 1 scoreboard players get #credits coc.dummy

# Setups up the base amount of credits to be used
function ~/init:
    store result score #players coc.dummy if entity @a[distance=..48]
    scoreboard players set #credits coc.dummy CREDIT_INITIAL
    scoreboard players operation #credits coc.dummy *= #players coc.dummy
    save_credits()

# Chooses a mob to be spawned
function ~/roll:
    if score #credits coc.dummy matches ..0 return 0

    store result score #rand coc.dummy random value (0, TOTAL_WEIGHT - 1)

    weight = 0

    # Basically generate a bunch of score checks to decide which mob to spawn
    # example:
    # if random is between 0..99 summon zombie
    # if random is between 100..149 summon skeleton
    for card in POOL:
        if score #rand coc.dummy matches (weight, weight + card["weight"] - 1):
            if score #credits coc.dummy matches f'{card["cost"]}..' function ~/{card["id"].split(":")[-1]}:
                scoreboard players remove #credits coc.dummy card["cost"]
                data modify storage coc:temp mob set value card["id"]
                function ./../spawner
                
        weight += card["weight"]

# Teleport the marker to a random location,
# roll for a mob,
# kill the marker
function ~/spread_marker:
    spreadplayers ~ ~ 0 16 false @s
    at @s function ~/../roll
    kill @s

# Tries to spawn a mob
function ~/spawn:
    # Make sure that we don't spawn too many mobs at a time
    # You're welcome server
    store result score #mobs coc.dummy if entity @e[tag=coc.rift.spawned,distance=..48]
    if score #mobs coc.dummy matches f"{MAX_ENTITIES}.." return 0

    load_credits()
    # This uses a marker because I'm lazy, its all good
    execute summon marker function ~/../spread_marker
    save_credits()   

function ~/calculate_coeff:
    # load seconds since start from data
    store result score #duration coc.dummy data get entity @s WAVE_DURATION_LOCATION
    scoreboard players add #duration coc.dummy 1
    store result entity @s WAVE_DURATION_LOCATION int 1 scoreboard players get #duration coc.dummy 

    scoreboard players operation #minute coc.dummy = #duration coc.dummy
    scoreboard players operation #minute coc.dummy /= #60 coc.const

    def coeff(i):
        return int((1 + (0.4 * (math.sqrt(i)))) * 10)

    for i in range(0,10):
        if score #minute coc.dummy matches i:
            # math is just: 1 + 0.4 × sqrt(minutes)
            # needs to be scaled by 10 because integer math
            execute return coeff(i) 
    execute return coeff(10)

# Give the director more credits every tick
function ~/income:
    load_credits()

    # creditsPerSecond = creditBase × creditCoeff × (playerCount + 1) / 2
    # ty ror2 wiki
    scoreboard players set #new coc.dummy (CREDIT_BASE)

    store result score #coeff coc.dummy function ~/../calculate_coeff
    scoreboard players operation #new coc.dummy *= #coeff coc.dummy
    scoreboard players operation #new coc.dummy /= #10 coc.const

    store result score #players coc.dummy if entity @a[distance=..48]
    scoreboard players add #players coc.dummy 1
    scoreboard players operation #players coc.dummy /= #2 coc.const

    scoreboard players operation #new coc.dummy *= #players coc.dummy
    
    # log_score("#new", "coc.dummy")
    
    scoreboard players operation #credits coc.dummy += #players coc.dummy

    save_credits()