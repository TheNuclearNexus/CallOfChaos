from ./creatures import ACTIVE_TAG, LIQUID_TAG, change_model

unless entity @a[limit=1, distance=..32] return 0

if score @s coc.powered matches 1 return:
    change_model("powered", 1)

change_model("", 1)