from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import UserViewSet, CreatedTaskViewSet, PlannedTaskViewSet

router = DefaultRouter()
router.register(r'users', UserViewSet)
router.register(r'created-tasks', CreatedTaskViewSet)
router.register(r'planned-tasks', PlannedTaskViewSet)


urlpatterns = [
    path('', include(router.urls)),
]