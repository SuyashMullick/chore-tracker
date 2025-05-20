from rest_framework.serializers import ModelSerializer
from .models import User, Group, GroupUser, Task, TaskAssigned

class UserSerializer(ModelSerializer):
    class Meta:
        model = User
        fields = '__all__'

class GroupSerializer(ModelSerializer):
    class Meta:
        model = Group
        fields = '__all__'

class GroupUserSerializer(ModelSerializer):
    class Meta:
        model = GroupUser
        fields = '__all__'

class TaskSerializer(ModelSerializer):
    class Meta:
        model = Task
        fields = '__all__'

class TaskAssignedSerializer(ModelSerializer):
    class Meta:
        model = TaskAssigned
        fields = '__all__'