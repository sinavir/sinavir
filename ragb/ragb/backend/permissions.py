import logging
from datetime import timedelta

from django.utils import timezone
from rest_framework.permissions import DjangoModelPermissionsOrAnonReadOnly

from .models import RateLimits

logger = logging.getLogger(__name__)

now = timezone.now


class LightPermissions(DjangoModelPermissionsOrAnonReadOnly):
    perms_map = DjangoModelPermissionsOrAnonReadOnly.perms_map | {
        "PUT": ["%(app_label)s.restricted_change_%(model_name)s"],
        "PATCH": ["%(app_label)s.restricted_change_%(model_name)s"],
    }

    def has_permission(self, request, view):
        perm = True
        if (
            request.user
            and request.user.is_authenticated
            and request.method in ["PUT", "PATCH"]
        ):
            last_vote = request.user.userlastvote.last_vote
            rate_limit = RateLimits.get_solo().user_ratelimit
            new_vote_date = last_vote + timedelta(seconds=rate_limit)
            perm = new_vote_date < now()
            logger.info(
                f"Check permission for user {request.user}: {new_vote_date} <? now"
            )
            if not perm:
                self.message = "Your user is being rate limited"
        return perm and super().has_permission(request, view)

    def has_object_permission(self, request, view, obj):
        perm = True
        if (
            request.user
            and request.user.is_authenticated
            and request.method in ["PUT", "PATCH"]
        ):
            last_vote = obj.last_update
            rate_limit = RateLimits.get_solo().light_ratelimit
            new_vote_date = last_vote + timedelta(seconds=rate_limit)
            perm = new_vote_date < now()
            logger.info(f"Check permission for object {obj}: {new_vote_date} <? now")
            if not perm:
                self.message = "Your object has been updated too recently"
        return perm and super().has_object_permission(request, view, obj)
