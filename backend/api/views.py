from rest_framework import viewsets
from .serializers import UserSerializer, GroupSerializer, GroupMembershipSerializer, CreatedTaskSerializer, PlannedTaskSerializer

from rest_framework import status
from rest_framework.response import Response
from .services import create_created_task
from .models import User, Group, GroupMembership, CreatedTask, PlannedTask
from .serializers import CreatedTaskCreateSerializer

class UserViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer

class GroupViewSet(viewsets.ModelViewSet):
    queryset = Group.objects.all()
    serializer_class = GroupSerializer

class GroupMembershipViewSet(viewsets.ModelViewSet):
    queryset = GroupMembership.objects.all()
    serializer_class = GroupMembershipSerializer

class CreatedTaskViewSet(viewsets.ModelViewSet):
    queryset = CreatedTask.objects.all()
    # serializer_class = CreatedTaskSerializer
    def get_serializer_class(self):
        if self.action == "create":
            return CreatedTaskCreateSerializer
        elif self.action == "get":
            return CreatedTaskCreateSerializer
        return CreatedTaskSerializer

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        if serializer.is_valid():
            task = serializer.save()
            return Response(
                {
                "id": task.id,
                "task_name": task.task_name,
                "points": task.points,
                "group": task.group.id
                }, status=status.HTTP_201_CREATED
            )
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class PlannedTaskViewSet(viewsets.ModelViewSet):
    queryset = PlannedTask.objects.all()
    serializer_class = PlannedTaskSerializer
    
    def partial_update(self, request, *args, **kwargs):
        instance = self.get_object()
        new_state = request.data.get("state")
        
        if not new_state:
            return Response({"error": "State field is required"}, status=status.HTTP_400_BAD_REQUEST)
        instance.state = new_state
        instance.save()
        serializer = self.get_serializer(instance)
        return Response(serializer.data)
