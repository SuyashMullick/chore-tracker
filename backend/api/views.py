from rest_framework import viewsets
from .models import User, Group, GroupMembership, CreatedTask, PlannedTask
from .serializers import UserSerializer, GroupSerializer, GroupUserSerializer, CreatedTaskSerializer, PlannedTaskSerializer

class UserViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer

class GroupViewSet(viewsets.ModelViewSet):
    queryset = Group.objects.all()
    serializer_class = GroupSerializer

class GroupUserViewSet(viewsets.ModelViewSet):
    queryset = GroupMembership.objects.all()
    serializer_class = GroupUserSerializer

class CreatedTaskViewSet(viewsets.ModelViewSet):
    queryset = CreatedTask.objects.all()
    serializer_class = CreatedTaskSerializer

class PlannedTaskViewSet(viewsets.ModelViewSet):
    queryset = PlannedTask.objects.all()
    serializer_class = PlannedTaskSerializer
