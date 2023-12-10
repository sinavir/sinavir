import logging

from pyjecteur.fixtures import Strob
from pyjecteur.lights import Universe
from pyjecteur.widget import Widget

if False:  # True:
    logging.basicConfig(level=logging.DEBUG)
else:
    logging.basicConfig(level=logging.INFO)

w = Widget("/dev/ttyUSB0")


u = Universe(w)
s = Strob()
u.register(s, 55)

s.freq = 0x55
s.dim = 0xFF
