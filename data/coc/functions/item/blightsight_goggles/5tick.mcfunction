import math
from beet import Predicate
from bolt_expressions import Scoreboard
from coc:entity/natural_rift/relation/check_level_up import levelRequirements

dummy = Scoreboard("coc.dummy")

append function coc:entity/player/5tick:
    if predicate coc:entity/player/wearing_goggles if predicate coc:player/sneaking function ./5tick

ctx.data['coc:entity/player/wearing_goggles'] = Predicate({
  "condition": "minecraft:entity_properties",
  "entity": "this",
  "predicate": {
    "equipment": {
      "head": {
        "nbt": "{smithed:{id:\"coc:blightsight_goggles\"}}"
      }
    }
  }
})

sizes = [
    ['coc.natural_rift', 2, 12],
    ['coc.gathering_lantern', 0.25, 16]
]


colors = [
    [7/255,    115/255,     83/255],
    [171/255,  217/255,    109/255],
    [238/255,  108/255,     59/255],
    [38/255,    41/255,     74/255],
    [160/255,   44/255,     93/255],
]


append function ./draw/particle_circle:
    for i in range(len(colors)):
        c = colors[i]
        if score $color coc.dummy matches i particle minecraft:dust c[0] c[1] c[2] 1 ~ ~ ~ 0 0 0 0 1 force @s
append function ./draw/particle_marker:
    for i in range(len(colors)):
        c = colors[i]
        if score $color coc.dummy matches i particle minecraft:dust c[0] c[1] c[2] 2 ~ ~ ~ 0 0 0 0 1 force @s

scoreboard players set $iter coc.dummy 0

store result score $time coc.dummy time query gametime

cycles = 8
dummy["$time"] %= cycles

for cycle in range(cycles):
    if score $time coc.dummy matches cycle function f'coc:item/blightsight_goggles/draw/{cycle}':
        for size in sizes:
            at @e[type=armor_stand,tag=size[0],distance=..64,limit=6] function f'coc:item/blightsight_goggles/draw/{cycle}/{size[0]}':
                dummy["$color"] = dummy["$iter"] % 3
                scoreboard players add $iter coc.dummy 1

                positioned ~ f'~{size[1] - 0.5}' ~ function ./draw/particle_marker
                positioned ~ f'~{size[1]}'       ~ function ./draw/particle_marker
                positioned ~ f'~{size[1] + 0.5}' ~ function ./draw/particle_marker

                for angle in range(cycle,360,cycles):
                    angle = math.radians(angle)
                    x = math.sin(angle) * size[2]
                    z = math.cos(angle) * size[2]


                    positioned ~x ~f'{size[1]}'     ~z function ./draw/particle_circle
                    positioned ~x ~f'{size[1] + z}' ~0 function ./draw/particle_circle
                    positioned ~0 ~f'{size[1] + z}' ~x function ./draw/particle_circle


scoreboard players set $suc coc.dummy 0
scoreboard players operation $lastId coc.dummy = @s coc.goggles.id
scoreboard players operation $lastEnergy coc.dummy = @s coc.goggles.energy

dashCount = 20

tag @s add coc.player
unless data entity @s SelectedItem.id anchored eyes positioned ^ ^ ^   anchored feet function ./show_info:
    positioned ~-0.5 ~-0.5 ~-0.5 as @e[type=armor_stand,tag=coc.energy.receiver,dx=0,dy=0,dz=0,sort=nearest,limit=1] function ./show_info/receiver:
        store result score $id coc.dummy data get entity @s UUID[0]
        scoreboard players set $suc coc.dummy 1
        
        at @s align xyz function ./show_info/box:
            particle wax_off ~0 ~0 ~0 0 0 0 0 1 force @p[tag=coc.player]
            particle wax_off ~1 ~0 ~0 0 0 0 0 1 force @p[tag=coc.player]
            particle wax_off ~0 ~0 ~1 0 0 0 0 1 force @p[tag=coc.player]
            particle wax_off ~1 ~0 ~1 0 0 0 0 1 force @p[tag=coc.player]
            particle wax_off ~0 ~1 ~0 0 0 0 0 1 force @p[tag=coc.player]
            particle wax_off ~1 ~1 ~0 0 0 0 0 1 force @p[tag=coc.player]
            particle wax_off ~0 ~1 ~1 0 0 0 0 1 force @p[tag=coc.player]
            particle wax_off ~1 ~1 ~1 0 0 0 0 1 force @p[tag=coc.player]

        unless score $lastId coc.dummy = $id coc.dummy function ./show_info/receiver/success
        if score $lastId coc.dummy = $id coc.dummy unless score $lastEnergy coc.dummy = @s coc.rift_energy function ./show_info/receiver/success:
            tellraw @a[tag=coc.player] [
                ("-"*dashCount + "\n"),
                {"translate":"text.coc.goggles.energy","color":"gray","with": [
                    {"score":{"objective":"coc.rift_energy","name":"@s"},"color":"green"}
                ]}
            ]
            scoreboard players operation @p coc.goggles.id = $id coc.dummy 
            scoreboard players operation @p coc.goggles.energy = @s coc.rift_energy
    as @e[type=armor_stand,tag=coc.natural_rift,distance=..1.5,sort=nearest,limit=1] if score @s coc.pact_id = @p coc.pact_id function ./show_info/natural_rift:
        scoreboard players set $suc coc.dummy 1
        
        for lvl in range(len(levelRequirements)):
            if score @s coc.relation.lvl matches (lvl+1) scoreboard players set $pts coc.dummy levelRequirements[lvl]  

        at @s function coc:entity/natural_rift/energy/get_energy_stats


        tellraw @a[tag=coc.player] [
            ("-"*dashCount + "\n"),
            {"translate":"text.coc.goggles.relation","color":"gray","with": [
                {"score":{"objective":"coc.relation.lvl","name":"@s"},"color":"green"}, 
                {"score":{"objective":"coc.relation.lvl","name":"@s"},"color":"white"},
                {"score":{"objective":"coc.dummy","name":"$pts"},"color":"white"}
            ]},
            "\n",
            {"translate":"text.coc.goggles.energy_output","color":"gray","with":[
                {"color":"white","score":{"objective":"coc.rift_energy","name":"$naturalRift"}},
                {"color":"white","score":{"objective":"coc.rift_energy","name":"$max"}}
            ]}
        ]
        if score @s coc.rift.flow matches 1.. tellraw @a[tag=coc.player] [
            {"translate":"text.coc.goggles.flow","color":"gray","with":[
                {"color":"white","score":{"objective":"coc.rift.flow","name":"@s"}}
            ]}
        ]


    unless score $suc coc.dummy matches 1 if entity @s[distance=..5] positioned ^ ^ ^1 function ./show_info
tag @s remove coc.player

