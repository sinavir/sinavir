from django.urls import path

from .views import FixtureView, HomeView

app_name = "frontend"
urlpatterns = [
    path("", HomeView.as_view(), name="home"),
    path("fixture/<pk>/", FixtureView.as_view(), name="fixture"),
]
