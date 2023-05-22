from contextlib import contextmanager

@contextmanager
def use(id):

    append function_tag coc:player/coas {
        "values": [
            f"coc:item/{id}/use"
        ] 
    }
    function f"coc:item/{id}/use":
        if data storage coc:temp Used.tag.smithed{id: f"coc:{id}"} function f"coc:item/{id}/_use":
            yield