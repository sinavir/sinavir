import colorsys
import logging

from pyjecteur.fixtures import Blinder
from pyjecteur.lights import Universe
from pyjecteur.widget import Widget

if True:  # True:
    logging.basicConfig(level=logging.DEBUG)
else:
    logging.basicConfig(level=logging.INFO)

w = Widget("/dev/ttyUSB0")

u = Universe(w)
c = Blinder()

u.register(c, 299)
