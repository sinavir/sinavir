from django.urls import path

from .views import HomeView, LightView

app_name = "frontend"
urlpatterns = [
    path("", HomeView.as_view(), name="home"),
    path("light/<str:light>/", LightView.as_view()),
]
