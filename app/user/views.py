"""Views for the user API"""
from rest_framework import generics, authentication, permissions
from rest_framework.authtoken.views import ObtainAuthToken
from rest_framework.settings import api_settings

from user.serializers import (
    UserSerializer,
    AuthTokenSerializer,
    )


class CreateUserView(generics.CreateAPIView):
    """Create a new user in the system"""
    serializer_class = UserSerializer


class CreateTokenView(ObtainAuthToken):
    """Create a new auth token for user."""
    serializer_class = AuthTokenSerializer  # We want our email and password instead of a default username and password, thats why we created a custom one # noqa
    renderer_classes = api_settings.DEFAULT_RENDERER_CLASSES  # this to get a browsable API on the browser, this is an optional one but good to add so that user can view it on a browser # noqa


# https://www.udemy.com/course/django-python-advanced/learn/lecture/32237176#content
class ManagerUserView(generics.RetrieveUpdateAPIView):
    """Manage the authenticated user"""
    serializer_class = UserSerializer
    authentication_classes = [authentication.TokenAuthentication]  # READMORE
    permission_classes = [permissions.IsAuthenticated]  # READMORE

    def get_object(self):
        return self.request.user  # READMORE
