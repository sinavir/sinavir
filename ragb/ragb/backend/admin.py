from django.contrib import admin
from solo.admin import SingletonModelAdmin

from .models import Fixture, Light, RateLimits, UserLastVote

# Register your models here.
admin.site.register(Light)
admin.site.register(Fixture)
admin.site.register(UserLastVote)
admin.site.register(RateLimits, SingletonModelAdmin)
