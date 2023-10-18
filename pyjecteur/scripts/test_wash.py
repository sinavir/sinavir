import colorsys
import logging

from pyjecteur.fixtures import Wash
from pyjecteur.lights import Universe
from pyjecteur.widget import Widget

if False:  # True:
    logging.basicConfig(level=logging.DEBUG)
else:
    logging.basicConfig(level=logging.INFO)

w = Widget("/dev/ttyUSB0")


u = Universe(w)
a = Wash()
b = Wash()
c = Wash()
d = Wash()

u.register(a, 0)
u.register(b, 42)
u.register(c, 98)
u.register(d, 28)


def go_to(x, y, z, t):
    a.pan = x
    a.tilt = y
    b.pan = z
    b.tilt = t


w.auto_commit = False
go_to(127, 15, 127, 15)
c.pan, c.tilt = (167, 26)
a.red, a.green, a.blue = (180, 36, 0)
b.red, b.green, b.blue = (180, 36, 100)
a.zoom, b.zoom, c.zoom = (255, 255, 255)
w.commit()
w.auto_commit = True
