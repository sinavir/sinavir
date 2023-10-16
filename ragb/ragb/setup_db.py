import os

import django

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "ragb.settings")
django.setup()

from backend.models import Fixture, Light  # noqa: E402


def create_blinder(name):
    b = Fixture.objects.create(name=name, kind="blinder")
    for i in range(4):
        for j in range(4):
            Light.objects.create(
                name=f"{name}_{j}_{i}",
                fixture=b,
                offset=i + 4 * j,
            )


def create_led_tub(name):
    b = Fixture.objects.create(name=name, kind="led_tub")
    for i in range(48):
        Light.objects.create(
            name=f"{name}_{i}",
            fixture=b,
            offset=i,
        )


def create_par_led(name):
    b = Fixture.objects.create(name=name, kind="par_led")
    Light.objects.create(
        name=f"{name}",
        fixture=b,
        offset=0,
    )


create_blinder("Blinder")
create_led_tub("Tube LED 1")
create_led_tub("Tube LED 2")
create_led_tub("Tube LED 3")
create_par_led("Par LED scene-gauche")
create_par_led("Par LED scene-droit")
create_par_led("Par LED cote-gauche")
create_par_led("Par LED cote-droit")
