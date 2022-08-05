leveledMobs = [
    [
        {
            id: "minecraft:zombie", 
            nbt: {Tags:["coc.level.1"], ActiveEffects:[{Id:1,Amplifier:2b,Duration:999999}]},
            cost: 6, weight:15, lifetime: 30
        },
        {
            id: "minecraft:skeleton", 
            nbt: {Tags:["coc.level.1"],HandItems:[{id:"minecraft:bow",Count:1b},{}]},
            cost: 8, weight:7, lifetime: 60
        },
        {
            id: "minecraft:creeper", 
            nbt: {Tags:["coc.level.1"],ActiveEffects:[{Id:14,Amplifier:0b,Duration:60}]},
            cost: 12, weight:5, lifetime: 60
        }
    ],
    [
        {
            id: "minecraft:zombie", 
            nbt: {Tags:["coc.level.2"], ActiveEffects:[{Id:1,Amplifier:3b,Duration:999999}]},
            cost: 17, weight:12, lifetime: 30
        },
        {
            id: "minecraft:skeleton", 
            nbt: {Tags:["coc.level.2"],HandItems:[{id:"minecraft:bow",Count:1b},{id:"minecraft:tipped_arrow",Count:1b,tag:{CustomPotionEffects:[{Id:18,Amplifier:0b,Duration:20}],CustomPotionColor:1644825}}]},
            cost: 12, weight:7, lifetime: 60
        },
        {
            id: "minecraft:creeper", 
            nbt: {Tags:["coc.level.2"],ActiveEffects:[{Id:14,Amplifier:0b,Duration:90}]},
            cost: 10, weight:5, lifetime: 60
        }
    ],
    [
        {
            id: "minecraft:zombie", 
            nbt: {Tags:["coc.level.3"], IsBaby:1b},
            cost: 20, weight:5, lifetime: 30
        },
        {
            id: "minecraft:husk", 
            nbt: {Tags:["coc.level.3"], ActiveEffects:[{Id:1,Amplifier:3b,Duration:999999}]},
            cost: 16, weight:12, lifetime: 30
        },
        {
            id: "minecraft:skeleton", 
            nbt: {Tags:["coc.level.3"],HandItems:[{id:"minecraft:bow",Count:1b,tag:{Enchantments:[{id:"minecraft:power",lvl:1s}]}},{id:"minecraft:tipped_arrow",Count:1b,tag:{CustomPotionEffects:[{Id:18,Amplifier:0b,Duration:40}],CustomPotionColor:1644825}}]},
            cost: 13, weight:7, lifetime: 60
        },
        {
            id: "minecraft:creeper", 
            nbt: {Tags:["coc.level.3"],ActiveEffects:[{Id:14,Amplifier:0b,Duration:90}]},
            cost: 26, weight:5, lifetime: 60
        }
    ],
    [
        {
            id: "minecraft:husk", 
            nbt: {Tags:["coc.level.4"], ActiveEffects:[{Id:1,Amplifier:3b,Duration:999999}],Attributes:[{Name:"generic.attack_damage",Base:4}]},
            cost: 27, weight:12, lifetime: 30
        },
        {
            id: "minecraft:skeleton", 
            nbt: {Tags:["coc.level.4"],HandItems:[{id:"minecraft:bow",Count:1b,tag:{Enchantments:[{id:"minecraft:power",lvl:1s}]}},{id:"minecraft:tipped_arrow",Count:1b,tag:{CustomPotionEffects:[{Id:15,Amplifier:0b,Duration:60}],CustomPotionColor:1644825}}]},
            cost: 20, weight:7, lifetime: 60
        },
        {
            id: "minecraft:creeper", 
            nbt: {Tags:["coc.level.4"],ActiveEffects:[{Id:14,Amplifier:0b,Duration:90}]},
            cost: 28, weight:9, lifetime: 60
        }
    ]
]