from ../entity/natural_rift/contract/process import mobs
from bolt_expressions import Data, Scoreboard

rift = Data.storage("coc:rift")

scoreboard objectives add coc.dummy dummy
scoreboard players set $dependencies coc.dummy 0

def checkVersion(dependency):
    scoreboard players set $temp coc.dummy 0
    if score f"#{dependency['name']}.major" load.status matches f'{dependency.version.split('.')[0]}..': 
        if score f"#{dependency['name']}.minor" load.status matches f'{dependency.version.split('.')[1]}..': 
            if score f"#{dependency['name']}.patch" load.status matches f'{dependency.version.split('.')[2]}..' function f'coc:technical/load/pass/{dependency.name}':
                scoreboard players add $dependencies coc.dummy 1
                scoreboard players set $temp coc.dummy 1
    if score $temp coc.dummy matches 0 function f'coc:technical/load/fail/{dependency.name}':
        tellraw @a [{"text":f"[Call of Chaos]","color":"dark_red"},{"text":f" {dependency.name} is not present or is not version {dependency.version}","color":"red"}]
        
dependencies = [
    {"name": 'smithed.item',"version": "0.0.1"},
    {"name": 'smithed.damage',"version": "0.0.4"},
    {"name": 'smithed.crafter',"version": "0.0.3"}
]

for i in range(len(dependencies)):
    checkVersion(dependencies[i])

unless score $dependencies coc.dummy matches len(dependencies) function ./fail_load:
    tellraw @a [{"text":"------------\nCall of Chaos failed to load because some dependencies are missing or are incorrect versions!","color":"red"}]
    
if score $dependencies coc.dummy matches len(dependencies) function ./post_load:
    scoreboard players set #coc.major load.status 0
    scoreboard players set #coc.minor load.status 0
    scoreboard players set #coc.patch load.status 1

    scoreboard objectives add coc.coas minecraft.used:minecraft.carrot_on_a_stick
    scoreboard objectives add coc.rift_id dummy
    scoreboard objectives add coc.player_id dummy
    scoreboard objectives add coc.pact_id dummy
    scoreboard objectives add coc.pact_members dummy 
    scoreboard objectives add coc.rift_energy dummy
    scoreboard objectives add coc.rift_energy_pool dummy
    scoreboard objectives add coc.rift.flow dummy


    scoreboard objectives add coc.lifetime dummy
    scoreboard objectives add coc.cost dummy

    scoreboard objectives add coc.relation.lvl dummy
    scoreboard objectives add coc.relation.pts dummy

    scoreboard objectives add coc.goggles.id dummy
    scoreboard objectives add coc.goggles.energy dummy

    scoreboard objectives add coc.refresh_knowledge trigger

    execute function ./generate_bossbars:
        for i in range(0,21):
            bossbar add f'coc:contract.{i*5}' {"text": ""}
            bossbar set f'coc:contract.{i*5}' name {"translate":"text.coc.natural_rift.contract.bossbar","color":"light_purple","with":[{"text":f'{i*5}',"color":"gold"}]}
            bossbar set f'coc:contract.{i*5}' color purple 
            bossbar set f'coc:contract.{i*5}' style notched_20 
            bossbar set f'coc:contract.{i*5}' max 20
            bossbar set f'coc:contract.{i*5}' value i 



    setblock -30000000 3 1600 barrel

    storageMobs = []
    for i in range(len(mobs)):
        storageMobs.append({index: i, weight: mobs[i]["weight"]})
    rift.Mobs = storageMobs

    function coc:technical/tick
    function coc:technical/5tick
    function coc:technical/1second

    if data storage coc:rift Contracts[] schedule function coc:entity/natural_rift/contract/process 1t replace


