from datetime import datetime

from rest_framework import serializers

from .models import Light, RateLimits, UserLastVote


class LightRestrictedSerializer(serializers.ModelSerializer):
    html_color = serializers.SerializerMethodField()

    def get_html_color(self, obj):
        return obj.get_html_color()

    def get_user(self):
        context = self.context
        if "user" in context:
            return context["user"]
        if "request" in context and hasattr(context["request"], "user"):
            return context["request"].user
        return None

    def validate(self, data):
        user = self.get_user()
        if user is None:
            raise serializers.ValidationError(
                "You must provide a User in LightSerializer context"
            )
        if not user.is_authenticated:
            raise serializers.ValidationError(
                "The user acting on light must be authenticated"
            )
        return data

    def save(self, *args, **kwargs):
        super().save(*args, **kwargs)
        user = self.get_user()
        UserLastVote.objects.update_or_create(
            user=user, defaults={"last_vote": datetime.now}
        )

    class Meta:
        model = Light
        fields = ["id", "name", "last_update", "red", "green", "blue", "html_color"]
        read_only_fields = ["name", "last_update", "html_color"]


class LightSerializer(serializers.ModelSerializer):
    class Meta:
        model = Light
        fields = ["name", "red", "green", "blue", "offset", "fixture"]


class RateLimitsSerializer(serializers.ModelSerializer):
    class Meta:
        model = RateLimits
        fields = "__all__"
