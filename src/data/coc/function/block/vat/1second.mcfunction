from ./creatures import ACTIVE_TAG, change_model

unless entity @a[limit=1, distance=..32] return 0


if score @s coc.powered matches 0 return:
    change_model("off")

if score @s[tag=!ACTIVE_TAG] coc.powered matches 1 return:
    change_model("powered")

if score @s[tag=ACTIVE_TAG] coc.powered matches 1 return:
    change_model("on")