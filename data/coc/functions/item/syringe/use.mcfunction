append function_tag coc:item/coas {"values": [
    "coc:item/syringe/use"
]}
append function_tag smithed.damage:event/player/on_death_message {"values": [
    "coc:item/syringe/death_message"
]}

append function ./death_message:
    if entity @s[tag=coc.using_syringe] tellraw @a [{"translate":"death.coc.syringe","with":[{"selector":"@s"}]}]


if data storage coc:temp Item.tag.smithed{id:"coc:syringe"} function ./check_bottles:
    store result score $bottles coc.dummy clear @s glass_bottle 0
    if score $bottles coc.dummy matches 1.. function ./take_own_blood:
        tag @s add coc.using_syringe
        
        if entity @s[gamemode=!creative] function ./if_survival:
            scoreboard players set @s smithed.damage 2
            function #smithed.damage:entity/apply
            clear @s glass_bottle 1

            if data storage coc:temp Item.Slot item replace entity @s weapon.offhand with air
            unless data storage coc:temp Item.Slot item replace entity @s weapon.mainhand with air

            playsound minecraft:entity.item.break master @a

        summon item ~ ~ ~ {
            Tags:["coc.new_vial"],
            PickupDelay:0s,
            Item:{
                id:"minecraft:potion",
                Count:1b,
                tag:{
                    CustomModelData:4260001,
                    HideFlags:32,
                    CustomPotionColor:16777215,
                    smithed:{id:"coc:blood_vial"},
                    display:{Name:'{"translate":"item.coc.blood_vial","italic": false}',Lore:[]},
                }
            }
        }

        data modify block -30000000 0 1603 Text1 set value '{"translate":"item.coc.blood_vial.owner","with":[{"selector":"@a[tag=coc.using_syringe,limit=1]"}],"color":"gray","italic":false}'
        data modify entity @e[type=item,tag=coc.new_vial,dx=0,limit=1] Item.tag.display.Lore prepend from block -30000000 0 1603 Text1
        store result entity @e[type=item,tag=coc.new_vial,dx=0,limit=1] Item.tag.coc.player int 1 scoreboard players get @s coc.player_id 

        tag @s remove coc.using_syringe
