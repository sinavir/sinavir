""""""
from colour import Color

from .lights import AbstractLight
from .reactive import RBool, RColor, RInt, RList


class Strob(AbstractLight):
    address_size = 2
    freq = RInt(0, 1)
    dim = RInt(0, 0)


class UVBar(AbstractLight):
    address_size = 3
    strob = RInt(0, 1)
    dim = RInt(0, 0)


class StrobInv(AbstractLight):
    address_size = 2
    freq = RInt(0, 0)
    dim = RInt(0, 1)


class Wash(AbstractLight):
    """
    Wash
    """

    address_size = 14

    pan = RInt(0, 0)
    tilt = RInt(0, 1)
    speed = RInt(0, 2)
    color = RColor(Color("black"), 3)
    white = RInt(0, 6)
    dimmer = RInt(255, 9)
    shutter = RBool(True, 10, true_val=b"\x15")
    zoom = RInt(0, 11)


class Tradi(AbstractLight):
    """
    Tradi RGB
    """

    address_size = 3

    color = RColor(Color("black"), 0)


class ParMKII(AbstractLight):
    """
    Par 56 led
    """

    address_size = 8

    color = RColor(Color("black"), 0)
    amber = RInt(0, 3)
    dimmer = RInt(255, 7)


class ParLed(AbstractLight):
    """
    Par Led Theatre
    """

    address_size = 7
    color = RColor(Color("black"), 0)

    dimmer = RInt(255, 6)


class Blinder(AbstractLight):
    """
    Blinder
    """

    address_size = 51

    dimmer = RInt(255, 1)
    flash = RInt(0, 2)
    colors = RList(
        [Color(rgb=(0, 0, 0)) for i in range(16)],
        3,
        3,
        from_byte=RColor.from_bytes,
        to_byte=RColor.to_bytes,
    )


class LedBar48Ch(AbstractLight):
    """
    Led Bar addressed on 48 channels
    """

    address_size = 48

    colors = RList(
        [Color(rgb=(0, 0, 0)) for i in range(16)],
        0,
        3,
        from_byte=lambda x: Color(f"#{x.hex()}"),
        to_byte=lambda x: bytes.fromhex(x.hex_l[1:]),
    )
