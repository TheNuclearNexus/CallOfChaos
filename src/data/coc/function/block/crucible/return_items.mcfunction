from ./recipes import CHECKED_TAG

summon item ~ ~ ~ {Item:{id:"minecraft:stone", count: 1}, Tags: [CHECKED_TAG]}
data modify entity @n[type=item,nbt={Age:0s}] Item set from block ~ ~ ~ Items[-1]
data remove block ~ ~ ~ Items[-1]

if items block ~ ~ ~ container.* * function ~/
 
