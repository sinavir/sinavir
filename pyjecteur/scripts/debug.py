"""
A script to debug dmx lines
"""
import logging

from pyjecteur.widget import MsgTypes, Widget

WINDOW_MIN = 130
WINDOW_MAX = 150

logging.basicConfig(level=logging.DEBUG)
logging.info("Starting")

w = Widget("/dev/ttyUSB0")

w.send_message(MsgTypes.RECEIVE_DMX_ON_CHANGE, b"\x00")

while True:
    m = w.read_message()
    if m[0] != MsgTypes.RECEIVED_DMX.value:
        logging.info("Not DMX")
        continue
    logging.info(f"DMX: {m[1][WINDOW_MIN:WINDOW_MAX]}")
