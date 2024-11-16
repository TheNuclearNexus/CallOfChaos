from ../default import create_rift

# Create a rift with the coc.rift.wild tag
create_rift(["coc.rift.wild"])

schedule function ./item_tick 1t replace

as @n[tag=coc.rift.wild] function ./directors/wave/init