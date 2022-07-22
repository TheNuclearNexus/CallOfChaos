store result score @s smithed.data if entity @s[scores={smithed.data=0}] if data storage smithed.crafter:input recipe{
    0:[{Slot:0b,id:"minecraft:deepslate_tiles"},{Slot:1b,id:"minecraft:deepslate_tiles"},{Slot:2b,id:"minecraft:deepslate_tiles"}],
    1:[{Slot:0b,id:"minecraft:deepslate_tiles"},{Slot:1b,id:"minecraft:structure_block",id:"minecraft:structure_block",tag:{smithed:{id:"coc:chaos_crystal"}}},{Slot:2b,id:"minecraft:deepslate_tiles"}],
    2:[{Slot:0b,id:"minecraft:obsidian"},{Slot:1b,id:"minecraft:obsidian"},{Slot:2b,id:"minecraft:obsidian"}]}:
        loot replace block ~ ~ ~ container.16 loot coc:item/offering_altar

store result score @s smithed.data if entity @s[scores={smithed.data=0}] if data storage smithed.crafter:input recipe{
    0:[{Slot:0b,id:"minecraft:structure_block",tag:{smithed:{id:"coc:chaos_crystal_shard"}}},{Slot:1b,id:"minecraft:structure_block",tag:{smithed:{id:"coc:chaos_crystal_shard"}}},{Slot:2b,id:"minecraft:air"}],
    1:[{Slot:0b,id:"minecraft:structure_block",tag:{smithed:{id:"coc:chaos_crystal_shard"}}},{Slot:1b,id:"minecraft:structure_block",tag:{smithed:{id:"coc:chaos_crystal_shard"}}},{Slot:2b,id:"minecraft:air"}]} 
    if data storage smithed.crafter:input recipe{2:[]}:
        loot replace block ~ ~ ~ container.16 loot coc:item/chaos_crystal

store result score @s smithed.data if entity @s[scores={smithed.data=0}] if data storage smithed.crafter:input recipe{
    0:[{Slot:0b,id:"minecraft:deepslate_tiles"},{Slot:1b,id:"minecraft:deepslate_tiles"},{Slot:2b,id:"minecraft:structure_block",tag:{smithed:{id:"coc:chaos_alloy"}}}],
    1:[{Slot:0b,id:"minecraft:deepslate_tiles"},{Slot:1b,id:"minecraft:furnace",tag:{smithed:{id:"coc:gathering_crystal"}}},{Slot:2b,id:"minecraft:furnace",tag:{smithed:{id:"coc:focusing_crystal"}}}],
    2:[{Slot:0b,id:"minecraft:deepslate_tiles"},{Slot:1b,id:"minecraft:deepslate_tiles"},{Slot:2b,id:"minecraft:structure_block",tag:{smithed:{id:"coc:chaos_alloy"}}}]}:
        loot replace block ~ ~ ~ container.16 loot coc:item/chaos_focuser

store result score @s smithed.data if entity @s[scores={smithed.data=0}] if data storage smithed.crafter:input recipe{
    0:[{Slot:0b,id:"minecraft:air"},{Slot:1b,id:"minecraft:structure_block",tag:{smithed:{id:"coc:nebulous_crystal"}}},{Slot:2b,id:"minecraft:air"}],
    1:[{Slot:0b,id:"minecraft:structure_block",tag:{smithed:{id:"coc:chaos_alloy"}}},{Slot:1b,id:"minecraft:furnace",tag:{smithed:{id:"coc:offering_altar"}}},{Slot:2b,id:"minecraft:structure_block",tag:{smithed:{id:"coc:chaos_alloy"}}}],
    2:[{Slot:0b,id:"minecraft:structure_block",tag:{smithed:{id:"coc:chaos_alloy"}}},{Slot:1b,id:"minecraft:redstone"},{Slot:2b,id:"minecraft:structure_block",tag:{smithed:{id:"coc:chaos_alloy"}}}]}:
        loot replace block ~ ~ ~ container.16 loot coc:item/rift_stabilizer

store result score @s smithed.data if entity @s[scores={smithed.data=0}] if data storage smithed.crafter:input recipe{
    0:[{Slot:0b,id:"minecraft:structure_block",tag:{smithed:{id:"coc:nebulous_powder"}}},{Slot:1b,id:"minecraft:structure_block",tag:{smithed:{id:"coc:nebulous_powder"}}},{Slot:2b,id:"minecraft:structure_block",tag:{smithed:{id:"coc:nebulous_powder"}}}],
    1:[{Slot:0b,id:"minecraft:structure_block",tag:{smithed:{id:"coc:chaos_alloy"}}},{Slot:1b,id:"minecraft:furnace",tag:{smithed:{id:"coc:offering_altar"}}},{Slot:2b,id:"minecraft:structure_block",tag:{smithed:{id:"coc:chaos_alloy"}}}],
    2:[{Slot:0b,id:"minecraft:structure_block",tag:{smithed:{id:"coc:chaos_alloy"}}},{Slot:1b,id:"minecraft:structure_block",tag:{smithed:{id:"coc:chaos_alloy"}}},{Slot:2b,id:"minecraft:structure_block",tag:{smithed:{id:"coc:chaos_alloy"}}}]}:
        loot replace block ~ ~ ~ container.16 loot coc:item/imbuement_altar

store result score @s smithed.data if entity @s[scores={smithed.data=0}] if data storage smithed.crafter:input recipe{
    0:[{Slot:0b,id:"minecraft:structure_block",tag:{smithed:{id:"coc:chaos_alloy"}}},{Slot:1b,id:"minecraft:clock"},{Slot:2b,id:"minecraft:structure_block",tag:{smithed:{id:"coc:chaos_alloy"}}}],
    1:[{Slot:0b,id:"minecraft:structure_block",tag:{smithed:{id:"coc:chaos_crystal"}}},{Slot:1b,id:"minecraft:furnace",tag:{smithed:{id:"coc:offering_altar"}}},{Slot:2b,id:"minecraft:structure_block",tag:{smithed:{id:"coc:chaos_crystal"}}}],
    2:[{Slot:0b,id:"minecraft:structure_block",tag:{smithed:{id:"coc:chaos_alloy"}}},{Slot:1b,id:"minecraft:redstone"},{Slot:2b,id:"minecraft:structure_block",tag:{smithed:{id:"coc:chaos_alloy"}}}]}:
        loot replace block ~ ~ ~ container.16 loot coc:item/synchronizer

store result score @s smithed.data if entity @s[scores={smithed.data=0}] if data storage smithed.crafter:input recipe{
    0:[{Slot:0b,id:"minecraft:deepslate_tiles"},{Slot:1b,id:"minecraft:furnace",tag:{smithed:{id:"coc:offering_altar"}}},{Slot:2b,id:"minecraft:deepslate_tiles"}],
    1:[{Slot:0b,id:"minecraft:structure_block",tag:{smithed:{id:"coc:chaos_alloy"}}},{Slot:1b,id:"minecraft:furnace",tag:{smithed:{id:"coc:eternal_burner"}}},{Slot:2b,id:"minecraft:structure_block",tag:{smithed:{id:"coc:chaos_alloy"}}}],
    2:[{Slot:0b,id:"minecraft:structure_block",tag:{smithed:{id:"coc:chaos_alloy"}}},{Slot:1b,id:"minecraft:structure_block",tag:{smithed:{id:"coc:entropic_lens"}}},{Slot:2b,id:"minecraft:structure_block",tag:{smithed:{id:"coc:chaos_alloy"}}}]}:
        loot replace block ~ ~ ~ container.16 loot coc:item/excluder

store result score @s smithed.data if entity @s[scores={smithed.data=0}] if data storage smithed.crafter:input recipe{
    0:[{Slot:0b,id:"minecraft:obsidian"},{Slot:1b,id:"minecraft:obsidian"},{Slot:2b,id:"minecraft:obsidian"}],
    1:[{Slot:0b,id:"minecraft:structure_block",tag:{smithed:{id:"coc:chaos_crystal"}}},{Slot:1b,id:"minecraft:blast_furnace"},{Slot:2b,id:"minecraft:structure_block",tag:{smithed:{id:"coc:chaos_crystal"}}}],
    2:[{Slot:0b,id:"minecraft:obsidian"},{Slot:1b,id:"minecraft:obsidian"},{Slot:2b,id:"minecraft:obsidian"}]}:
        loot replace block ~ ~ ~ container.16 loot coc:item/amalgam_forge

store result score @s smithed.data if entity @s[scores={smithed.data=0}] if data storage smithed.crafter:input recipe{
    0:[{Slot:0b,id:"minecraft:air"},{Slot:1b,id:"minecraft:air"},{Slot:2b,id:"minecraft:iron_nugger"}],
    1:[{Slot:0b,id:"minecraft:air"},{Slot:1b,id:"minecraft:glass_block"},{Slot:2b,id:"minecraft:air"}],
    2:[{Slot:0b,id:"minecraft:iron_ingot"},{Slot:1b,id:"minecraft:air"},{Slot:2b,id:"minecraft:air"}]}:
        loot replace block ~ ~ ~ container.16 loot coc:item/syringe