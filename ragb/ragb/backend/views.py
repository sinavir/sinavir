from rest_framework import viewsets
from rest_framework.generics import RetrieveAPIView

from .models import Light, RateLimits
from .permissions import LightPermissions
from .serializers import (LightRestrictedSerializer, LightSerializer,
                          RateLimitsSerializer)


class LightViewSet(viewsets.ModelViewSet):
    queryset = Light.objects.all()
    serializer_class = LightRestrictedSerializer
    serializer_class_create = LightSerializer
    permission_classes = [LightPermissions]

    def get_serializer_class(self):
        if self.request and self.request.method == "POST":
            return self.serializer_class_create
        return super().get_serializer_class()


class RateLimitsView(RetrieveAPIView):
    serializer_class = RateLimitsSerializer
    queryset = RateLimits.objects.all()

    def get_object(self):
        return RateLimits.get_solo()
