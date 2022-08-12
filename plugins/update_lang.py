from beet import Context, Language


def beet_default(ctx: Context):
    yield
    rp = ctx.assets
    langFile = rp.languages['coc:en_us']
    if langFile == None:
        return
    
    langFile.data['advancements.coc.main.root.description'] = f'Version {ctx.project_version}'