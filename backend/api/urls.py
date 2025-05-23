from rest_framework.routers import DefaultRouter
from .views import CreatedTaskViewSet

router = DefaultRouter()
router.register(r'tasks', CreatedTaskViewSet)

urlpatterns = router.urls
