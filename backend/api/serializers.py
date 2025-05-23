from rest_framework.serializers import ModelSerializer
from .models import User, Group, GroupMembership, CreatedTask, PlannedTask

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
        model = GroupMembership
        fields = '__all__'

class CreatedTaskSerializer(ModelSerializer):
    class Meta:
        model = CreatedTask
        fields = '__all__'

class PlannedTaskSerializer(ModelSerializer):
    class Meta:
        model = PlannedTask
        fields = '__all__'