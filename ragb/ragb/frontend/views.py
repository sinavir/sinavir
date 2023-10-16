from backend.models import Fixture
from django.core.exceptions import ViewDoesNotExist
from django.views.generic.base import TemplateView
from django.views.generic.detail import DetailView
from ragb.settings import WEBSOCKET_ENDPOINT


class HomeView(TemplateView):
    template_name = "frontend/home.html"

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context["websocket_endpoint"] = WEBSOCKET_ENDPOINT
        blinder = (
            Fixture.objects.filter(kind="blinder").prefetch_related("light_set").first()
        )
        par_led = list(
            Fixture.objects.filter(kind="par_led").prefetch_related("light_set"),
        )
        led_tub = list(
            Fixture.objects.filter(kind="led_tub").prefetch_related("light_set"),
        )
        fixtures = {
            "blinder": {
                "id": blinder.id,
                "lights": blinder.light_set.all(),
            },
            "par_led_front_left": {
                "id": par_led[0].id,
                "lights": par_led[0].light_set.all(),
            },
            "par_led_front_right": {
                "id": par_led[1].id,
                "lights": par_led[1].light_set.all(),
            },
            "par_led_side_left": {
                "id": par_led[2].id,
                "lights": par_led[2].light_set.all(),
            },
            "par_led_side_right": {
                "id": par_led[3].id,
                "lights": par_led[3].light_set.all(),
            },
        }
        for i in range(3):
            fixtures |= {
                f"led_tub_{i}": {
                    "id": led_tub[i].id,
                    "lights": led_tub[i].light_set.all(),
                },
            }
        lights = [l for k in fixtures for l in fixtures[k]["lights"]]
        return context | fixtures | {"lights": lights}


class FixtureView(DetailView):
    model = Fixture

    def get_template_names(self):
        return [f"frontend/{self.get_object().kind}.html"]

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context["websocket_endpoint"] = WEBSOCKET_ENDPOINT
        lights = context["object"].light_set.all()
        match context["object"].kind:
            case "led_tub":
                context["lights"] = [
                    {
                        "position": light.offset * 10,
                        "id": light,
                        "obj": light,
                    }
                    for light in lights
                ]
            case "blinder":
                context["lights"] = [
                    {
                        "position_y": (i.offset // 4) * 25 + 15,
                        "position_x": (i.offset % 4) * 25 + 15,
                        "id": f"{i.offset // 4}-{i.offset % 4}",
                        "obj": i,
                    }
                    for i in lights
                ]
            case "par_led":
                context["light"] = {
                    "obj": lights.get(),
                }

            case _:
                raise ViewDoesNotExist()
        return context
