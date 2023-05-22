from bolt_expressions import Scoreboard

rift_id = Scoreboard("coc.rift_id")
dummy = Scoreboard("coc.dummy")

advancement coc:modules/rift/interact {
  "criteria": {
    "requirement": {
      "trigger": "minecraft:player_interacted_with_entity",
      "conditions": {
        "entity": {
          "type": "minecraft:interaction",
          "nbt": "{Tags:[\"coc.rift_interaction\"]}"
        }
      }
    }
  },
  "rewards": {
    "function": "coc:modules/rift/interact"
  }
}

# Take the advancement
advancement revoke @s only coc:modules/rift/interact
# Raycast to the interaction entity
anchored eyes positioned ^ ^ ^ function ./interact/_get_entity:
    # Run the function on the interaction's vehicle; the rift entity
    # particle happy_villager ~ ~ ~ 0 0 0 0 1
    scoreboard players set $suc coc.dummy 0
    positioned ~-.5 ~-.5 ~-.5 as @e[type=interaction,tag=coc.rift_interaction,dx=0] on vehicle function ./process_interaction
    if score $suc coc.dummy matches 0 positioned ^ ^ ^0.1 if entity @s[distance=..6] function ./interact/_get_entity

# Player is accessbile via 
#> on passengers on target
function ./process_interaction:
    # Set $suc to 1 to exit interact/_get_entity
    scoreboard players set $suc coc.dummy 1
    on passengers on target:
        data remove storage coc:temp Mainhand
        data modify storage coc:temp Mainhand set from entity @s SelectedItem 

    at @s function ./conversion/interact
    