from rest_framework import viewsets
from .serializers import UserSerializer, GroupSerializer, GroupMembershipSerializer
from .serializers import TaskTemplateCreateSerializer, TaskTemplateDisplaySerializer, PlannedTaskDisplaySerializer, PlannedTaskCreateSerializer,PlannedTaskUpdateSerializer

from rest_framework import status
from rest_framework.response import Response
from .models import User, Group, GroupMembership, CreatedTask, PlannedTask


class UserViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer

class GroupViewSet(viewsets.ModelViewSet):
    queryset = Group.objects.all()
    serializer_class = GroupSerializer

class GroupMembershipViewSet(viewsets.ModelViewSet):
    queryset = GroupMembership.objects.all()
    serializer_class = GroupMembershipSerializer

class TaskTemplateViewSet(viewsets.ModelViewSet):
    queryset = CreatedTask.objects.all()
    def get_serializer_class(self):
        if self.action == "create":
            return TaskTemplateCreateSerializer
        elif self.action in ["list", "retrieve"]:
            return TaskTemplateDisplaySerializer
        return TaskTemplateDisplaySerializer

class PlannedTaskViewSet(viewsets.ModelViewSet):
    queryset = PlannedTask.objects.all()
    
    def get_serializer_class(self):
        if self.action in ['list', 'retrieve']:
            return PlannedTaskDisplaySerializer
        elif self.action == 'create':
            return PlannedTaskCreateSerializer
        elif self.action in ['update', 'partial_update']:
            return PlannedTaskUpdateSerializer
        return PlannedTaskDisplaySerializer

        

    # def partial_update(self, request, *args, **kwargs):
    #     instance = self.get_object()
    #     new_state = request.data.get("state")
        
    #     if not new_state:
    #         return Response({"error": "State field is required"}, status=status.HTTP_400_BAD_REQUEST)
    #     instance.state = new_state
    #     instance.save()
    #     serializer = self.get_serializer(instance)
    #     return Response(serializer.data)

