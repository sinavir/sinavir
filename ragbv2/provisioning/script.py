#!/nix/store/z46wvcd15152qnsry80p8ricxya2n2lr-python3-3.11.7-env/bin/python
import sys
import json
import requests
import logging

from colour import Color
from pyjecteur.fixtures import Blinder, LedBar48Ch, Tradi
from pyjecteur.lights import Universe
from pyjecteur.widget import Widget

if False:  # True:
    logging.basicConfig(level=logging.DEBUG)
else:
    logging.basicConfig(level=logging.INFO)

w = Widget("/dev/ttyUSB0")

DIM = {
    "blinder": 0.10,
    "led_tub": 0.05,
    "spot": 0.3,
}

u = Universe(w)


def strToProj(s):
    match s:
        case "spot":
            return Tradi()
        case "led_tub":
            return LedBar48Ch()
        case "blinder":
            return Blinder()


r = requests.get("https://agb.hackens.org/api-docs/patch.json")
patch = r.json()

lights = {}

update = {}

current_addr = 0

for k, v in patch["lights"].items():
    lights[k] = strToProj(v["kind"])
    u.register(lights[k], current_addr)
    # update dmx since some params are set before
    lights[k].update_dmx()
    logging.info(
        f"Light {k} of kind {v['kind']} is at DMX{current_addr+1} (PLS convention)"
    )
    for i, chan in enumerate(v["channels"]):
        update[chan] = (k, i)  # put the light name
    current_addr += lights[k].address_size


def update_light(address, red, green, blue):
    light, chan = update[address]
    kind = patch["lights"][light]["kind"]
    r, g, b = red * DIM[kind]/255, (green * DIM[kind])/255, (blue * DIM[kind])/255
    match kind:
        case "blinder":
            lights[light].colors[chan] = Color(rgb=(r, g, b))
        case "led_tub":
            lights[light].colors[chan] = Color(rgb=(r, g, b))
        case "spot":
            lights[light].color = Color(rgb=(r, g, b))


def run():
    logging.info("Started")
    for line in sys.stdin:
        logging.debug(line)
        if line.startswith("data:"):
            dataStr = line[5:]
            logging.debug(f"Received: {dataStr}")
            data = json.loads(dataStr)
            if data["address"] in update:
                update_light(data["address"], **data["value"])

run()

