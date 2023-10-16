import json

from django.contrib.auth import get_user_model
from django.contrib.auth.models import Permission
from django.contrib.contenttypes.models import ContentType
from django.db.models.signals import post_save
from django.dispatch import receiver
from django_redis import get_redis_connection

from .models import Light, UserLastVote
from .serializers import LightRestrictedSerializer


@receiver(post_save, sender=get_user_model())
def add_user_perms(instance, **kwargs):
    if not hasattr(instance, "userlastvote"):
        UserLastVote.objects.create(user=instance)
    content_type = ContentType.objects.get(app_label="backend", model="light")
    perm = Permission.objects.get(
        content_type=content_type, codename="restricted_change_light"
    )
    instance.user_permissions.add(perm)


@receiver(post_save, sender=Light)
def publish_event(instance, **kwargs):
    event = LightRestrictedSerializer(instance).data
    connection = get_redis_connection("default")
    payload = json.dumps(event)
    connection.publish("light_changes", payload)
