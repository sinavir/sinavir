"""
Module providing class for handling fixtures and generating the appropriate DMX.
"""
from copy import deepcopy
from typing import Any, Callable, Optional, Union

from .reactive import BaseReactiveValue, ReactiveMixin
from .widget import Widget


class Universe:
    """Represents a DMX universe.

    Manages the adress space and responsibles for sending DMX to widget when
    `Universe.update_dmx()` is called.
    """

    lights = {}

    def __init__(self, widget):
        """
        Initializes the Universe

        widget must be a class providing `widget.set_dmx(data, address)`
        """
        self.widget: Widget = widget

    def register(self, light: "AbstractLight", address: int) -> None:
        """
        Register a light at the specified address
        """
        # TODO: add checks for address overlapping
        self.lights[light] = address
        light.register_universe(self)
        light.update_dmx()

    def update_dmx(self, light: "AbstractLight", data: Union[bytearray, bytes]) -> None:
        """
        Update the dmx data of the specified light
        """
        # TODO: add checks for length
        self.widget.set_dmx(self.lights[light], data)


class AbstractLight:
    """
    Abstract class for lights
    """

    address_size: int = 0

    def __init__(self):
        self._universe: Optional[Universe] = None
        # The dmx values
        self._dmx: bytes = bytearray(self.address_size)
        # dmx memory_view to change in O(1) the values
        self._dmx_mv = memoryview(self._dmx)

        # Dict holdin conversion functions for attr values to dmx:
        #  { attr_name => (address, length, converter function) }
        self._attrs_to_dmx: dict[str, tuple[int, int, Callable[[Any], bytes]]] = {}

        # List holding conversion functions from dmx bytes to attrs.
        #  [ ( "attr_name", dmx_addr, length, converter function ) ]
        self._dmx_to_attrs: list[
            Optional[tuple[str, int, int, Callable[[bytes], Any]]]
        ] = [None for _ in range(self.address_size)]

        self._enable_auto_update: bool = False

        # Initialize reactivity
        def on_modified_factory(key):
            return lambda value: self.attr_set_hook(key, value)

        for key, rValueObject in self.__class__.__dict__.items():
            if isinstance(rValueObject, BaseReactiveValue):
                val = deepcopy(rValueObject.value)
                if isinstance(val, ReactiveMixin):
                    val.on_modified_hook = on_modified_factory(key)
                self._attrs_to_dmx[key] = rValueObject.attr_to_dmx()

                for i, length, callback in rValueObject.dmx_to_attr():
                    for k in range(i, i + length):
                        self._dmx_to_attrs[k] = (key, i, length, callback)
        self._enable_auto_update: bool = True
        # Finally set the attributes to their value
        for key, rValueObject in self.__class__.__dict__.items():
            if isinstance(rValueObject, BaseReactiveValue):
                val = rValueObject.value
                setattr(self, key, val)

    def register_universe(self, universe: "Universe") -> None:
        """Assign a universe to this light"""
        if self._universe is not None:
            raise ValueError("Can't assign light to more than one universe")
        self._universe = universe

    def update_dmx(self) -> None:
        """
        Method to be called when the DMX values may have changed.

        This method sends DMX velues to the Universe. It is automatically
        triggered by property assignments.
        """
        if self._universe is not None and self._enable_auto_update:
            self._universe.update_dmx(self, self._dmx)

    def __setattr__(self, name: str, value: Any) -> None:
        """
        Automatically update dmx when a fixture param is set
        """
        self.__dict__[name] = value
        if not name.startswith("_"):
            self.attr_set_hook(name, value)

    def attr_set_hook(self, name, value):
        """
        Hook to be called when an attribute is set in order to update DMX
        values
        """
        if name in self._attrs_to_dmx:
            # if the attr is linked to dmx, update self._dmx
            position, length, converter = self._attrs_to_dmx[name]
            self._dmx_mv[position : position + length] = converter(value)
        self.update_dmx()

    def __getitem__(self, key) -> bytes:
        return self._dmx[key]

    def __setitem__(self, key: int, value: bytes) -> None:
        self._dmx_mv[key : key + 1] = value

        if self._dmx_to_attrs[key] is not None:
            attr, position, length, converter = self._dmx_to_attrs[
                key
            ]  # pyright: ignore
            self._enable_auto_update = False
            setattr(self, attr, converter(self._dmx[position : position + length]))
            self._enable_auto_update = True
        self.update_dmx()
