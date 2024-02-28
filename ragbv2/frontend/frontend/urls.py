from django.urls import path

from .views import HomeView, LightView, TokenView

app_name = "frontend"
urlpatterns = [
    path("", HomeView.as_view(), name="home"),
    path("light/<str:light>/", LightView.as_view()),
    path("token", TokenView.as_view()),
]
