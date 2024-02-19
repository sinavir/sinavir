from datetime import datetime, timedelta, timezone

import jwt
from django.core.exceptions import ViewDoesNotExist
from django.http import Http404
from django.views.generic.base import TemplateView
from ragb.settings import JWT_SECRET, LIGHTS, WEBSOCKET_ENDPOINT


def get_context_from_proj(kind, chans):
    print(kind, chans)
    match kind:
        case "blinder":
            return [
                {
                    "id": chans[i],
                    "position_x": (i // 4) * 25 + 15,
                    "position_y": (i % 4) * 25 + 15,
                }
                for i in range(len(chans))
            ]
        case "led_tub":
            return [
                {
                    "id": chans[i],
                    "position": i * 10,
                }
                for i in range(len(chans))
            ]
        case "tradi":
            return {
                "id": chans[0],
            }

        case _:
            raise ViewDoesNotExist()


class LightView(TemplateView):
    def get_template_names(self):
        lights = LIGHTS["lights"][self.kwargs["light"]]
        return [f"frontend/{lights['kind']}.html"]

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        if self.request.user.is_authenticated:
            context["jwt"] = jwt.encode(
                {
                    "exp": datetime.now(tz=timezone.utc) + timedelta(hours=9),
                    "sub": "ragb",
                    "user": self.request.user.username,
                    "scope": "modify",
                },
                JWT_SECRET,
            )
        context["websocket_endpoint"] = WEBSOCKET_ENDPOINT
        light = self.kwargs["light"]
        if light not in LIGHTS["lights"]:
            raise Http404("Light does not exist")
        lights = LIGHTS["lights"][light]
        context["lights"] = get_context_from_proj(lights["kind"], lights["channels"])
        context["light_name"] = lights["name"]

        return context


class HomeView(TemplateView):
    template_name = "frontend/home.html"

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context["websocket_endpoint"] = WEBSOCKET_ENDPOINT
        lights = LIGHTS["lights"]
        context["lights"] = lights

        return context
