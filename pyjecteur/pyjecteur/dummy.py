import logging
from enum import Enum
from typing import Optional


class MsgTypes(Enum):
    """
    Gadget message types
    """

    REPROGRAM_FIRMWARE = b"\x01"
    FLASH_FIRMWARE_PAGE = b"\x02"
    GET_WIDGET_PARAMS = b"\x03"
    SET_WIDGET_PARAMS = b"\x04"
    RECEIVED_DMX = b"\x05"
    SEND_DMX = b"\x06"
    RECEIVE_DMX_ON_CHANGE = b"\x08"
    RECEIVE_DMX_CHANGE_OF_STATE = b"\x09"
    GET_SERIAL_NUMBER = b"\x0a"


def from_bytes(b: bytes) -> int:
    """
    Convert bytes to int (endianness compatible with the Gadget)
    """
    return int.from_bytes(b, "little")


def to_bytes(b: int, length: int = 1) -> bytes:
    """
    Convert int to bytes (endianness compatible with the Gadget)
    """
    return b.to_bytes(length, "little")


class Widget:
    """
    Class managing the communication with the gadget
    """

    def __init__(self, serial_device_path: Optional[str] = None) -> None:
        self._dmx = bytes(512)
        self.break_time: Optional[int] = None
        self.mab_time: Optional[int] = None
        self.rate: Optional[int] = None
        self.firmware: tuple[Optional[int], Optional[int]] = (None, None)
        self._auto_commit = True

        self.dmx_staging = bytearray(512)
        self.serial_device_path = serial_device_path

    @property
    def auto_commit(self) -> bool:
        """
        Get `auto_commit` value, `True` if auto commit is enabled
        """
        return self._auto_commit

    @auto_commit.setter
    def auto_commit(self, value: bool):
        """
        Set `auto_commit` value
        """
        self._auto_commit = value
        if self._auto_commit:
            self.commit()

    @property
    def is_open(self) -> bool:
        return True

    def __enter__(self):
        return self

    def _init_widget(self):
        # Retrieve widget parameters
        self.send_message(MsgTypes.GET_WIDGET_PARAMS, b"\x00\x00")
        msg_type, data, _ = None, None, None
        while msg_type != MsgTypes.GET_WIDGET_PARAMS.value:
            msg_type, data, _ = self.read_message()
        assert msg_type is not None and data is not None

        self.break_time = data[2]
        self.mab_time = data[3]
        self.rate = data[4]
        self.firmware = (data[1], data[0])
        self.send_message(MsgTypes.SEND_DMX, b"\x00" + self._dmx)
        logging.info("[WIDGET] Initialized widget.")
        logging.info(f"[WIDGET]     Break time: {self.break_time * 10.67}µs")
        logging.info(f"[WIDGET]     MAB time: {self.mab_time * 10.67}µs")
        logging.info(f"[WIDGET]     DMX rate: {self.rate}Hz")
        logging.info(f"[WIDGET]     Firmware v{self.firmware[0]}.{self.firmware[1]}")

    def __exit__(self, exc_type, exc_value, traceback):
        pass

    def set_params(
        self,
        break_time: Optional[int] = None,
        mab_time: Optional[int] = None,
        rate: Optional[int] = None,
    ) -> None:
        """
        Set widget params
        """
        if break_time is not None:
            if break_time >= 128 or break_time < 9:
                raise ValueError(
                    f"Break time must be in [9,128) range, provided {break_time}"
                )
            self.break_time = break_time
        if mab_time is not None:
            if mab_time >= 128 or mab_time < 1:
                raise ValueError(
                    f"MAB time must be in [1,128) range, provided {mab_time}"
                )
            self.mab_time = mab_time
        if rate is not None:
            if rate >= 41 or rate < 0:
                raise ValueError(f"DMX rate must be in [0,41) range, provided {rate}")
            self.rate = rate
        assert (
            self.break_time is not None
            and self.mab_time is not None
            and self.rate is not None
        )
        data = (
            b"\x00\x00"
            + to_bytes(self.break_time)
            + to_bytes(self.mab_time)
            + to_bytes(self.rate)
        )
        self.send_message(MsgTypes.SET_WIDGET_PARAMS, data)

    def set_dmx(
        self,
        addr: int,
        data: bytes,
        addr_starting: int = 0,
    ) -> None:
        """
        Set dmx values that will be sent.

        If `auto_commit` is set to false, to provided configuration won't be
        sent but memorized until the next call to `Widget.commit()` (or a call
        to this function with `auto_commit = True`).
        """
        true_addr = addr - addr_starting
        if len(data) + true_addr > 512:
            raise ValueError("Can't send more than 512 value over dmx")
        self.dmx_staging[true_addr : true_addr + len(data)] = data
        if self.auto_commit:
            self.commit()

    def commit(self) -> None:
        """Commit the staging DMX data and send it"""
        self._dmx = bytes(self.dmx_staging)
        self.send_message(MsgTypes.SEND_DMX, b"\x00" + self._dmx)

    def send_message(self, msg_type: MsgTypes, data: bytes) -> None:
        """
        Lower level API for sending instruction to widget.
        Prefer the use of `Widget.set_dmx` or `Widget.set_params`.
        """
        if msg_type not in MsgTypes:
            raise KeyError("Message type not known")
        datalen = to_bytes(len(data), 2)
        message = b"\x7E" + msg_type.value + datalen + data + b"\xE7"
        logging.debug(f"[SERIAL] Sending {message}")
        # self._serial.flush()

    def read_message(self) -> tuple[bytes, bytes, bool]:
        """
        Low level API for reading message sent by the widget.
        """
        raise NotImplementedError()
