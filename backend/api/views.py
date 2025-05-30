from rest_framework import viewsets
from .serializers import *
from .models import *
from .services import *
from rest_framework.response import Response
from rest_framework import status

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
    
    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        if serializer.is_valid():
            data = serializer.validated_data
            try:
                task_template = create_task_template(
                    group=data["group"],
                    task_name=data["task_name"],
                    description=data.get("description", ""),
                    points=data["points"]
                )
                output_serializer = TaskTemplateDisplaySerializer(task_template)
                return Response(output_serializer.data, status=status.HTTP_201_CREATED)
            except ValidationError as e:
                return Response({"error": str(e)}, status=status.HTTP_400_BAD_REQUEST)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
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
    
    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        if serializer.is_valid():
            data = serializer.validated_data
            try:
                planned_task=PlannedTask(
                    task_template=data["task_template"],
                    assignee=data.get("assignee"),
                    assigner=data["assigner"],
                    start_time=data["start_time"],
                    custom_points=data["custom_points"]
                )
                planned_task.save()
                output_serializer = PlannedTaskDisplaySerializer(planned_task)
                return Response(output_serializer.data, status=status.HTTP_201_CREATED)
            except ValidationError as e:
                return Response({"error": str(e)}, status=status.HTTP_400_BAD_REQUEST)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)



        
    # def partial_update(self, request, *args, **kwargs):
    #     instance = self.get_object()
    #     new_state = request.data.get("state")
        
    #     if not new_state:
    #         return Response({"error": "State field is required"}, status=status.HTTP_400_BAD_REQUEST)
    #     instance.state = new_state
    #     instance.save()
    #     serializer = self.get_serializer(instance)
    #     return Response(serializer.data)

