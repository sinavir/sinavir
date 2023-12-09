""""""
from colour import Color

from .lights import AbstractLight
from .reactive import L, RBool, RInt, RList


class Strob(AbstractLight):
    address_size = 2
    freq = RInt(0, 1)
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
    red = RInt(0, 3)
    green = RInt(0, 4)
    blue = RInt(0, 5)
    white = RInt(0, 6)
    dimmer = RInt(255, 9)
    shutter = RBool(True, 10, true_val=b"\x15")
    zoom = RInt(0, 11)


class Tradi(AbstractLight):
    """
    Tradi RGB
    """

    address_size = 3

    red = RInt(0, 0)
    green = RInt(0, 1)
    blue = RInt(0, 2)


class ParMiskin(AbstractLight):
    """
    Par 56 led
    """

    address_size = 8

    red = RInt(0, 0)
    green = RInt(0, 1)
    blue = RInt(0, 2)
    dimmer = RInt(255, 7)


class ParLed(AbstractLight):
    """
    Par Led Theatre
    """

    address_size = 7

    red = RInt(0, 0)
    green = RInt(0, 1)
    blue = RInt(0, 2)

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
        from_byte=lambda x: Color(f"#{x.hex()}"),
        to_byte=lambda x: bytes.fromhex(x.hex_l[1:]),
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
