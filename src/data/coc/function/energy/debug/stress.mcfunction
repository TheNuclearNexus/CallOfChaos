
size = [5, 5]


for x in range(size[0]):
    for z in range(size[1]):
        dx = x * 3
        dz = z * 3
        positioned ~dx ~ ~dz:
            function ./create_bubble {radius: 2}

            for i in range(10):
                function ./create_sink

        say f"{x} {z}"