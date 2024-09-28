# Called by the item generator
setblock ~ ~ ~ barrel{
    CustomName: '{"translate": "block.coc.amalgam_forge"}',
    lock: {components:{custom_data:{impossible:"impossible"}}},
    components: {
        "minecraft:custom_data": {
            coc: {
                id: "coc:amalgam_forge",
                silent: 1
            }
        }
    }
}