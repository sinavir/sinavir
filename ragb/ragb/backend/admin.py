from django.contrib import admin
from solo.admin import SingletonModelAdmin

from .models import Fixture, Light, RateLimits, UserLastVote


class LightAdmin(admin.ModelAdmin):
    list_display = ["name", "id", "fixture"]


# Register your models here.
admin.site.register(Light, LightAdmin)
admin.site.register(Fixture)
admin.site.register(UserLastVote)
admin.site.register(RateLimits, SingletonModelAdmin)
