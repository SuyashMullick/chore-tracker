from rest_framework import viewsets
from .models import User, Group, GroupMembership, GroupMembership, TaskAssigned
from .serializers import UserSerializer, GroupSerializer, GroupUserSerializer, TaskSerializer, TaskAssignedSerializer

class UserViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer

class GroupViewSet(viewsets.ModelViewSet):
    queryset = Group.objects.all()
    serializer_class = GroupSerializer

class GroupUserViewSet(viewsets.ModelViewSet):
    queryset = GroupMembership.objects.all()
    serializer_class = GroupUserSerializer

class TaskViewSet(viewsets.ModelViewSet):
    queryset = GroupMembership.objects.all()
    serializer_class = TaskSerializer

class TaskAssignedViewSet(viewsets.ModelViewSet):
    queryset = TaskAssigned.objects.all()
    serializer_class = TaskAssignedSerializer
