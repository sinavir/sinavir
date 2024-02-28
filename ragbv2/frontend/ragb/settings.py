"""
Django settings for ragb project.

Generated by 'django-admin startproject' using Django 4.2.5.

For more information on this file, see
https://docs.djangoproject.com/en/4.2/topics/settings/

For the full list of settings and their values, see
https://docs.djangoproject.com/en/4.2/ref/settings/
"""

import json
import logging
import os
from pathlib import Path

from django.urls import reverse_lazy

# Build paths inside the project like this: BASE_DIR / 'subdir'.
BASE_DIR = Path(__file__).resolve().parent.parent


# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/4.2/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = "django-insecure-elz+_!5$ad6r%%_aia_8pdzdrd(i=d_krcd@gv1t11wolz@bv^"

SECRET_KEY_FILE = os.environ.get("SECRET_KEY_FILE", "")
if SECRET_KEY_FILE != "":
    try:
        with open(SECRET_KEY_FILE, encoding="utf-8") as f:
            SECRET_KEY = f.read().strip()
    except:
        logging.warning(f"Not able to open SECRET_KEY_FILE: {SECRET_KEY_FILE}")

JWT_SECRET = "secret"

JWT_SECRET_FILE = os.environ.get("JWT_SECRET_FILE", "")
if JWT_SECRET_FILE != "":
    try:
        with open(JWT_SECRET_FILE, encoding="utf-8") as f:
            JWT_SECRET = f.read().strip()
    except:
        logging.warning(f"Not able to open JWT_SECRET_FILE: {JWT_SECRET_FILE}")

DEV_KEY = "coucou"

DEV_KEY_FILE = os.environ.get("DEV_KEY_FILE", "")
if DEV_KEY_FILE != "":
    try:
        with open(DEV_KEY_FILE, encoding="utf-8") as f:
            DEV_KEY = f.read().strip()
    except:
        logging.warning(f"Not able to open DEV_KEY_FILE: {DEV_KEY_FILE}")

# Custom settings

WEBSOCKET_PORT = int(os.environ.get("WEBSOCKET_PORT", "9999"))
WEBSOCKET_HOST = os.environ.get("WEBSOCKET_HOST", "127.0.0.1")
WEBSOCKET_ENDPOINT = os.environ.get(
    "WEBSOCKET_ENDPOINT", f"http://{WEBSOCKET_HOST}:{WEBSOCKET_PORT}/api"
)

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = os.environ.get("DEBUG", "1") != "0"

ENABLE_DJDT = os.environ.get("ENABLE_DJDT", "1") != "0"


ALLOWED_HOSTS = os.environ.get("ALLOWED_HOSTS", "127.0.0.1,localhost").split(",")

INTERNAL_IPS = [
    "127.0.0.1",
]

# Application definition

INSTALLED_APPS = [
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    "django.contrib.staticfiles",
    "authens",
    "frontend",
    "shared",
]

MIDDLEWARE = [
    "django.middleware.security.SecurityMiddleware",
    "django.contrib.sessions.middleware.SessionMiddleware",
    "django.middleware.common.CommonMiddleware",
    "django.middleware.csrf.CsrfViewMiddleware",
    "django.contrib.auth.middleware.AuthenticationMiddleware",
    "django.contrib.messages.middleware.MessageMiddleware",
    "django.middleware.clickjacking.XFrameOptionsMiddleware",
]

if ENABLE_DJDT:
    INSTALLED_APPS += [
        "debug_toolbar",
    ]
    MIDDLEWARE = [
        "debug_toolbar.middleware.DebugToolbarMiddleware",
    ] + MIDDLEWARE

ROOT_URLCONF = "ragb.urls"

TEMPLATES = [
    {
        "BACKEND": "django.template.backends.django.DjangoTemplates",
        "DIRS": [],
        "APP_DIRS": True,
        "OPTIONS": {
            "context_processors": [
                "django.template.context_processors.debug",
                "django.template.context_processors.request",
                "django.contrib.auth.context_processors.auth",
                "django.contrib.messages.context_processors.messages",
            ],
        },
    },
]

WSGI_APPLICATION = "ragb.wsgi.application"

# AuthENS

AUTHENTICATION_BACKENDS = [
    "django.contrib.auth.backends.ModelBackend",
    "authens.backends.ENSCASBackend",
]

AUTHENS_ALLOW_STAFF = True
AUTHENS_USE_OLDCAS = False


LOGIN_URL = reverse_lazy("authens:login")

LOGIN_REDIRECT_URL = reverse_lazy("frontend:home")
LOGOUT_REDIRECT_URL = reverse_lazy("frontend:home")

# DJDT


DEBUG_TOOLBAR_CONFIG = {
    # Toolbar options
    "PROFILER_MAX_DEPTH": 20,
    "SHOW_TOOLBAR_CALLBACK": "ragb.utils.show_debug_toolbar",
}

# Database
# https://docs.djangoproject.com/en/4.2/ref/settings/#databases


DATABASES = {
    "default": {
        "ENGINE": os.environ.get("DB_ENGINE", "django.db.backends.sqlite3"),
        "NAME": os.environ.get("DB_NAME", BASE_DIR / "db.sqlite3"),
        "USER": os.environ.get("DB_USER", ""),
        "PASSWORD": os.environ.get("DB_PASS", ""),
        "HOST": os.environ.get("DB_HOST", ""),
        "PORT": os.environ.get("DB_PORT", ""),
    },
}

# Password validation
# https://docs.djangoproject.com/en/4.2/ref/settings/#auth-password-validators

AUTH_PASSWORD_VALIDATORS = (
    [
        {
            "NAME": "django.contrib.auth.password_validation.UserAttributeSimilarityValidator",
        },
        {
            "NAME": "django.contrib.auth.password_validation.MinimumLengthValidator",
        },
        {
            "NAME": "django.contrib.auth.password_validation.CommonPasswordValidator",
        },
        {
            "NAME": "django.contrib.auth.password_validation.NumericPasswordValidator",
        },
    ]
    if not DEBUG
    else []
)


# Internationalization
# https://docs.djangoproject.com/en/4.2/topics/i18n/

LANGUAGE_CODE = "en-us"

TIME_ZONE = "UTC"

USE_I18N = True

USE_TZ = True

# logging

LOGGING = {
    "version": 1,
    "disable_existing_loggers": False,
    "handlers": {
        "console": {
            "level": "INFO",
            "class": "logging.StreamHandler",
        },
    },
    "loggers": {
        "django": {
            "handlers": ["console"],
            "propagate": True,
        },
    },
}

# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/4.2/howto/static-files/

STATIC_URL = "static/"

STATIC_ROOT = os.environ.get("STATIC_ROOT", "static/")

# Default primary key field type
# https://docs.djangoproject.com/en/4.2/ref/settings/#default-auto-field

DEFAULT_AUTO_FIELD = "django.db.models.BigAutoField"

LIGHTS = json.load(open(BASE_DIR / "patch.json"))
