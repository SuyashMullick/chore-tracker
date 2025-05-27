from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import CreatedTaskViewSet

router = DefaultRouter()
router.register(r'created-tasks', CreatedTaskViewSet)


urlpatterns = [
    path('', include(router.urls)),
]