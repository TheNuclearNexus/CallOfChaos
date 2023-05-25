import xml.etree.ElementTree as ET

from beet import Font
from ./screen import Screen
from ./group import Group
from ./button import Button


class Builder():
    def add_image_to_font(self, name):
        path = "coc:gui/" + name
        image = ctx.assets.textures[path].image

        if path in self.font:
            return {"char": self.font[path].chars[0], "size": image.size}
        
        char = chr(61440 + len(self.font) + 1)

        self.font[path] = ({
            "type": "bitmap",
            "file": path + '.png',
            "ascent": image.size[1] - 2,
            "height": image.size[1],
            "chars": [
                char
            ]
        })

        return {"char": char, "size": image.size}

    def create_group(self, node):
        group = Group(**node.attrib)
        for child in node:
            group.children.append(self.get_element(child))

        if 'background' in node.attrib:
            background = self.add_image_to_font(node.attrib.background)
            group.w = background.size[0]
            group.h = background.size[1]
            group.background = background.char

        return group

    def create_button(self, node):
        textures = ctx.assets.textures

        default = self.add_image_to_font(node.attrib.default)
        hover = self.add_image_to_font(node.attrib.hover)

        node.attrib['default'] = default.char
        node.attrib['hover'] = hover.char

        return Button(**node.attrib, w=default.size[0], h=default.size[1])

    def get_element(self, node):
        if node.tag == 'group':
            return self.create_group(node)
        if node.tag == 'button':
            return self.create_button(node)

    def create_screen(self, node): 
        screen = Screen(**node.attrib)
        for child in node:
            screen.children.append(self.get_element(child))


        ctx.assets[f"coc:ui/{screen.name}"] = Font({
            "providers": list(self.font.values())
        })

        return screen

    def __init__(self, data):
        self.font = {}
        root = ET.fromstring(data)

        if root.tag != 'screen':
            raise SyntaxError("XML must have a screen root")
        
        self.create_screen(root).generate()

Builder("""
    <screen w="64" h="64" d="2" name="test">
        <group key="buttons" background="test_background">
            <button
                key="1" x="6" y="6"
                default="ok_button" hover="arrow_down_1"
            />
            <button
                key="2" x="42" y="6"
                default="ok_button" hover="ok_button_hover"
            />
        </group>
    </screen>
""")