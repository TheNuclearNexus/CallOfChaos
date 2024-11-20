# Called by the item generator
setblock ~ ~ ~ barrel{
    CustomName: '{"translate": "block.coc.amalgam_forge"}',
    lock: {components:{custom_data:{impossible:"impossible"}}},
    components: {
        "minecraft:custom_data": {
            smithed: {
                id: "coc:amalgam_forge",
            },
            coc: {
                silent: 1
            }
        }
    }
}