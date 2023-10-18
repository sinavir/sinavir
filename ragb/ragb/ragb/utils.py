from . import settings


def show_debug_toolbar(request):
    if "HTTP_APPKEY" in request.META:
        return (
            settings.ENABLE_DJDT
            and request.META["HTTP_APPKEY"].strip() == settings.DEV_KEY.strip()
        )
    return settings.ENABLE_DJDT and settings.DEBUG
