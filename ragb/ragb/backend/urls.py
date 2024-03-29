"""
backend URL Configuration
"""

from django.urls import path
from django.views.generic import TemplateView
from rest_framework import routers
from rest_framework.schemas import get_schema_view

from .views import LightViewSet, RateLimitsView

urlpatterns = [
    path("ratelimits/", RateLimitsView.as_view()),
    path(
        "documentation/",
        TemplateView.as_view(
            template_name="backend/swagger-ui.html",
            extra_context={"schema_url": "backend:openapi-schema"},
        ),
        name="swagger-ui",
    ),
]
router = routers.DefaultRouter()

router.register(
    r"light",
    LightViewSet,
    basename="light",
)

app_name = "backend"
urlpatterns += router.urls
