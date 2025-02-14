from contextlib import contextmanager

@contextmanager
def test(path: str):
    store result score #experimental coc.dummy function path:
        yield

    if score #experimental coc.dummy matches 1 return 1
    return 0

if is_debug():
    with test(~/create_network):
        UUID = "0-0-0-0-1"

        data modify storage coc:temp network_id set value 1
        data modify storage coc:temp network_uuid set value UUID

        function ./api/create_network with storage coc:temp {}

        unless data storage coc:energy networks{keys: [UUID]} return 0
        unless data storage coc:energy f'networks."{UUID}"' return 0
        unless data storage coc:energy f'networks."{UUID}"' return 0

    