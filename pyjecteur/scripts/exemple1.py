import colorsys
import logging

from pyjecteur.fixtures import Tradi
from pyjecteur.lights import Universe
from pyjecteur.widget import Widget

if False:  # True:
    logging.basicConfig(level=logging.DEBUG)
else:
    logging.basicConfig(level=logging.INFO)

w = Widget("/dev/ttyUSB0")


u = Universe(w)
a = Tradi()
b = Tradi()

u.register(a, 12)
u.register(b, 15)


a.red, a.green, a.blue = (180, 36, 0)
b.red, b.green, b.blue = (180, 36, 0)
