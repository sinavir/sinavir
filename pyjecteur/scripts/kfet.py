import logging

from colour import Color
from pyjecteur.fixtures import Blinder, LedBar48Ch, ParLed, ParMKII, UVBar
from pyjecteur.lights import Universe
from pyjecteur.widget import Widget

if False:
    logging.basicConfig(level=logging.DEBUG)
else:
    logging.basicConfig(level=logging.INFO)

w = Widget("/dev/ttyUSB0")

u = Universe(w)

barreled_regie_g = LedBar48Ch()
barreled_bar = LedBar48Ch()
barreled_poteau = LedBar48Ch()
barreled_regie_d = LedBar48Ch()
blinder = Blinder()
uv_poteau = UVBar()
uv_pont_g = UVBar()
uv_pont_d = UVBar()
uv_regie = UVBar()

parled_regie_g = ParLed()
parled_regie_d = ParLed()
parled_pont = ParLed()

parmisc_poteau_g = ParMKII()
parmisc_poteau_d = ParMKII()
parmisc_bar = ParMKII()
parmisc_vip = ParMKII()
parmisc_regie = ParMKII()


u.register(blinder, 299)
u.register(barreled_regie_g, 398)
u.register(barreled_regie_d, 446)
u.register(barreled_poteau, 350)
u.register(barreled_bar, 117)
u.register(parled_pont, 173)
u.register(parled_regie_g, 180)
u.register(parled_regie_d, 187)
u.register(uv_poteau, 499)
u.register(uv_pont_g, 502)
u.register(uv_pont_d, 505)
u.register(uv_regie, 508)
u.register(parmisc_poteau_d, 243)
u.register(parmisc_poteau_g, 251)
u.register(parmisc_bar, 283)
u.register(parmisc_vip, 291)
u.register(parmisc_regie, 259)


def rainbow():
    for i in range(16):
        blinder.colors[i] = Color(hue=i * 255 / 16, saturation=1, luminance=0.5)
    for i in range(16):
        barreled_bar.colors[i] = Color(hue=i * 255 / 16, saturation=1, luminance=0.5)
    for i in range(16):
        barreled_regie_g.colors[i] = Color(
            hue=(255 - i * 255 / 16), saturation=1, luminance=0.5
        )
    for i in range(16):
        barreled_regie_d.colors[i] = Color(
            hue=(i * 255 / 16), saturation=1, luminance=0.5
        )
    for i in range(16):
        barreled_poteau.colors[i] = Color(hue=i * 255 / 16, saturation=1, luminance=0.5)
    parled_pont.color = Color("red")
    parled_regie_g.color = Color("green")
    parled_regie_d.color = Color("blue")
