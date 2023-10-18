"""
Module holding classes for easy specification of fixtures attributes
"""

from typing import Any, Callable, Iterable, Optional

from .widget import from_bytes, to_bytes


class BaseReactiveValue:
    """
    Abstract class for defining the parsers between DMX values and object attributes
    """

    key: Optional[str] = None
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
        return [(self.address, self.length, from_bytes)]

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
        return [(self.address, self.length, lambda x: x == self.true_val)]

    def attr_to_dmx(self):
        return (
            self.address,
            self.length,
            lambda x: self.true_val if x else self.false_val,
        )


class ReactiveMixin:  # pylint: disable=too-few-public-methods
    """
    Mixin for data types that need to update
    """

    on_modified_hook: Callable[[Any], None] = lambda value: None


class L(ReactiveMixin):  # pylint: disable=invalid-name
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
        self.on_modified_hook(self)

    def __iter__(self):
        return self._val.__iter__()


class RList(BaseReactiveValue):
    """
    List light attribute
    """

    def __init__(  # pylint: disable=too-many-arguments
        self,
        value: L,
        address: int,
        unit_size: int = 1,
        from_byte: Callable[[bytes], Any] = from_bytes,
        to_byte: Callable[[Any], bytes] = to_bytes,
    ):
        self.value = value
        self.address: int = address
        self.unit_size = unit_size
        self.length = len(value) * unit_size
        self.from_byte = from_byte
        self.to_byte = to_byte

    def dmx_to_attr(self):
        def parser_factory(i):
            def parser(bytes_val):
                self.value[i] = self.from_byte(bytes_val)
                return self.value

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
            lambda x: b"".join([self.to_byte(i) for i in self.value]),
        )
