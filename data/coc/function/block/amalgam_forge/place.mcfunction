# Called by the item generator
setblock ~ ~ ~ barrel{
    CustomName: '{"translate": "block.coc.amalgam_forge"}',
    Lock: "\\uf001",
    components: {
        "minecraft:custom_data": {
            coc: {
                id: "coc:amalgam_forge",
                silent: 1
            }
        }
    }
}