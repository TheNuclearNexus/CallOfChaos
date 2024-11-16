

import math
import time


class Bubble():
    name = "Bubble"
    radius = 10

    # max U
    max_capacity = 1000
    # current U
    current_capacity = 0

    # rate of transfer U/t
    transfer = 10
    # rate of consumption U/t
    consumption = 0

    def __init__(self, name: str, radius: int, max_capacity: int, consumption: int):
        self.name = name
        self.radius = radius
        self.max_capacity = max_capacity
        self.current_capacity = 0
        self.consumption = consumption

BUBBLES = [
    Bubble(
        "Bubble A",
        radius=10, 
        max_capacity=100,
        consumption=0
    ),
    Bubble(
        "Bubble B",
        radius=5,
        max_capacity=150,
        consumption=3
    )
]

TOTAL_PRODUCTION = 30

while True:
    production = TOTAL_PRODUCTION / len(BUBBLES)
    total_max_capacity = 0
    total_cur_capacity = 0

    for bubble in BUBBLES:
        total_max_capacity += bubble.max_capacity
        total_cur_capacity += bubble.current_capacity
    
    print(f"System Capacity: {total_cur_capacity} U / {total_max_capacity} U")

    for bubble in BUBBLES:
        area = math.pi * (bubble.radius ** 2)

        max_concentration = bubble.max_capacity / area
        cur_concentration = bubble.current_capacity / area

       
        print("-" * 10)
        print(bubble.name)
        print(f"growth rate: {production - bubble.consumption}")
        print(f"capacity: {bubble.current_capacity} U / {bubble.max_capacity} U")
        print(f"total area: {area:.3f} block")
        print(f"concentration: {cur_concentration:.3f} U/block / {max_concentration:.3f} U/block")

        bubble.current_capacity += production - bubble.consumption

        if bubble.current_capacity < 0:
            bubble.current_capacity = 0

        if bubble.current_capacity > bubble.max_capacity:
            bubble.current_capacity = bubble.max_capacity
    print("\n\n")
    time.sleep(1)