from rest_framework.serializers import ModelSerializer
from .models import User, Group, GroupMembership, CreatedTask, PlannedTask

from rest_framework import serializers
from .models import CreatedTask, Group
from .services import create_created_task

class UserSerializer(ModelSerializer):
    class Meta:
        model = User
        fields = '__all__'

class GroupSerializer(ModelSerializer):
    class Meta:
        model = Group
        fields = '__all__'

class GroupMembershipSerializer(ModelSerializer):
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



class CreatedTaskCreateSerializer(serializers.Serializer):
    id = serializers.PrimaryKeyRelatedField( # it means Group ID
        queryset=Group.objects.all(),
        source="group"
        )
    task_name = serializers.CharField(max_length=100)
    description = serializers.CharField()
    points = serializers.IntegerField(min_value=1, max_value=10)

    def create(self, validated_data):
        return create_created_task(
            group=validated_data["group"],
            task_name=validated_data["task_name"],
            description=validated_data["description"],
            points=validated_data["points"],
        )