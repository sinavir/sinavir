"""
Module holding classes for easy specification of fixtures attributes
"""

from typing import Any, Callable, Iterable, Optional

from colour import Color

from .widget import from_bytes, to_bytes


class ReactiveMixin:
    """
    Mixin for data types that need to update
    """

    light = None
    key: Optional[str] = None

    def set_all(self, new_val):
        raise NotImplementedError("Can't assign value here")


class BaseReactiveValue:
    """
    Abstract class for defining the parsers between DMX values and object attributes
    """

    address: Optional[list[int]] = None
    value: Any = None

    def attr_to_dmx(self) -> tuple[int, int, Callable[[Any], bytes]]:
        """
        Fonction qui retourne les informations pour convertir une valeur
        d'attribut en DMX sous la forme:
        ```
        (addresse, longueur, fonction_de_conversion)
        ```
        """
        raise NotImplementedError()

    def dmx_to_attr(self) -> Iterable[tuple[int, int, Callable[[bytes], Any]]]:
        """
        Fonction qui retourne les informations pour mettre à jour les attributs
        si le DMX a changé sous la forme
        ```
        list((addresse, longueur, fonction_de_conversion))
        ```
        """
        raise NotImplementedError()


class RInt(BaseReactiveValue):
    """
    Int light attribute
    """

    def __init__(self, value: int, address: int, length: int = 1):
        self.value: int = value
        self.address: int = address
        self.length: int = length

    def dmx_to_attr(self):
        return [(self.address, self.length, lambda _, b: from_bytes(b))]

    def attr_to_dmx(self):
        return (self.address, self.length, lambda x: to_bytes(x, length=self.length))


class RBool(BaseReactiveValue):
    """
    Boolean light attribute
    """

    def __init__(  # pylint: disable=too-many-arguments
        self,
        value,
        address,
        true_val: bytes = b"\xff",
        false_val: bytes = b"\x00",
        length=1,
    ):
        self.value = value
        self.address = address
        self.length = length
        self.true_val = true_val
        self.false_val = false_val

    def dmx_to_attr(self):
        return [(self.address, self.length, lambda _, x: x == self.true_val)]

    def attr_to_dmx(self):
        return (
            self.address,
            self.length,
            lambda x: self.true_val if x else self.false_val,
        )


class RColor(BaseReactiveValue):
    """
    Boolean light attribute
    """

    def __init__(  # pylint: disable=too-many-arguments
        self,
        value,
        address,
    ):
        self.value = value
        self.address = address
        self.length = 3

    @staticmethod
    def from_bytes(x):
        return Color(f"#{x.hex()}")

    @staticmethod
    def to_bytes(x):
        return bytes.fromhex(x.hex_l[1:])

    def dmx_to_attr(self):
        return [(self.address, self.length, lambda _, x: self.from_bytes(x))]

    def attr_to_dmx(self):
        return (
            self.address,
            self.length,
            self.to_bytes,
        )


class L(ReactiveMixin):  # ruff: disable=invalid-name
    """
    Thin wrapper around lists to handle reactivity inside lists
    """

    def __init__(
        self,
        val: list[Any],
    ):
        self._val = val

    def __len__(self):
        return len(self._val)

    def __getitem__(self, key):
        return self._val[key]

    def __setitem__(self, key, value):
        self._val[key] = value
        if self.light:
            self.light.attr_set_hook(self.key, self)

    def set_all(self, new_value):
        self._val = new_value
        if self.light:
            self.light.attr_set_hook(self.key, self)

    def __iter__(self):
        return self._val.__iter__()


class RList(BaseReactiveValue):
    """
    List light attribute
    """

    def __init__(  # pylint: disable=too-many-arguments
        self,
        value: list[Any],
        address: int,
        unit_size: int = 1,
        from_byte: Callable[[bytes], Any] = from_bytes,
        to_byte: Callable[[Any], bytes] = to_bytes,
    ):
        """
        value: L([]) object
        address: DMX address
        unit_size: size of one value in the list (number of DMX slots it takes)
        from_bytes, to_byte: convert function from list value to dmx bytes
                             (and reciprocally)
        """
        self.value = L(value)
        self.address: int = address
        self.unit_size = unit_size
        self.length = len(value) * unit_size
        self.from_byte = from_byte
        self.to_byte = to_byte

    def dmx_to_attr(self):
        def parser_factory(i):
            """
            Factory to create functions that updates i-th value of list
            """

            def parser(value, bytes_val):
                value._val[i] = self.from_byte(bytes_val)
                return value

            return parser

        return [
            (
                self.address + i * self.unit_size,
                self.unit_size,
                parser_factory(i),
            )
            for i in range(len(self.value))
        ]

    def attr_to_dmx(self):
        return (
            self.address,
            self.length,
            lambda x: b"".join([self.to_byte(i) for i in x]),
        )
