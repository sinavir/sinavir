import asyncio
import json
import logging

import requests
import websockets
from colour import Color
from pyjecteur.fixtures import Blinder, LedBar48Ch, Tradi
from pyjecteur.lights import Universe
from pyjecteur.widget import Widget

if False:  # True:
    logging.basicConfig(level=logging.DEBUG)
else:
    logging.basicConfig(level=logging.INFO)

w = Widget("/dev/ttyUSB0")


u = Universe(w)
par_left_front = Tradi()
par_left_side = Tradi()
par_right_front = Tradi()
par_right_side = Tradi()

led = [LedBar48Ch() for _ in range(3)]

blinder = Blinder()

# u.register(par_left_front, 12)
# u.register(par_left_side, 15)
# u.register(par_right_front, 18)
# u.register(par_right_side, 21)
# u.register(led[0], 100)
# u.register(led[1], 200)
u.register(led[2], 398)

patch = {}


def update_led(led, index):
    def callback(color):
        led.colors[index] = Color(color)

    return callback


for i in range(113, 129):
    patch |= {i: update_led(led[2], i - 113)}

init = requests.get("https://agb.hackens.org/api/light").json()


def update(i):
    print(f"Updating {i['name']}/{i['id']}:i['html_color']")
    if i["id"] in patch:
        patch[i["id"]](i["html_color"])


def load_from_get():
    for i in init:
        update(i)


load_from_get()


async def run():
    async for w in websockets.connect("wss://agb.hackens.org/ws"):
        try:
            async for message in w:
                obj = json.loads(message)
                update(obj)

        except w.ConnectionClosed:
            load_from_get()


asyncio.run(run())
