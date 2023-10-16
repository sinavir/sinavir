from django.contrib.auth.models import User
from django.core.validators import MaxValueValidator
from django.db import models
from solo.models import SingletonModel


# Create your models here.
class Light(models.Model):
    name = models.CharField(max_length=256)
    red = models.PositiveSmallIntegerField(
        default=0,
        validators=[MaxValueValidator(0xFF)],
    )
    green = models.PositiveSmallIntegerField(
        default=0,
        validators=[MaxValueValidator(0xFF)],
    )
    blue = models.PositiveSmallIntegerField(
        default=0,
        validators=[MaxValueValidator(0xFF)],
    )
    fixture = models.ForeignKey("Fixture", on_delete=models.CASCADE)
    offset = models.PositiveSmallIntegerField()
    last_update = models.DateTimeField(auto_now=True)

    def get_html_color(self):
        return f"#{self.red:02x}{self.green:02x}{self.blue:02x}"

    def __str__(self):
        return self.name

    class Meta:
        permissions = [("restricted_change_light", "Change light value")]


class Fixture(models.Model):
    FIXTURE_KINDS = [
        ("blinder", "Blinder"),  # 48 couleurs
        ("led_tub", "LED pixel tube"),  # 16 couleurs
        ("par_led", "LED Par"),  # 1 couleur
    ]
    name = models.CharField(max_length=256)
    kind = models.CharField(max_length=7, choices=FIXTURE_KINDS)

    def __str__(self):
        return self.name


class UserLastVote(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    last_vote = models.DateTimeField(auto_now=True)

    def __str__(self):
        return str(self.user)


class RateLimits(SingletonModel):
    user_ratelimit = models.PositiveIntegerField(default=0)
    light_ratelimit = models.PositiveIntegerField(default=0)
