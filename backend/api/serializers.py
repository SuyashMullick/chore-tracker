from rest_framework.serializers import ModelSerializer
from .models import User, Group, GroupMembership, CreatedTask, PlannedTask

from rest_framework import serializers
from .models import CreatedTask, Group
from .services import create_created_task

class UserSerializer(ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'first_name', 'last_name', 'gender']

class GroupSerializer(ModelSerializer):
    users = serializers.SerializerMethodField()
    class Meta:
        model = Group
        fields = '__all__'
    
    def get_users(self, obj):
        members = GroupMembership.objects.filter(group=obj).select_related('user')
        return UserSerializer([m.user for m in members], many=True).data

class GroupMembershipSerializer(ModelSerializer):
    class Meta:
        model = GroupMembership
        fields = '__all__'

class TaskTemplateSerializer(ModelSerializer): # To present the tasks from back to front
    group = GroupSerializer(read_only=True)
    class Meta:
        model = CreatedTask
        fields = '__all__'

class TaskTemplateCreateSerializer(serializers.Serializer): # To store the tasks from front to back
    group = serializers.PrimaryKeyRelatedField(
        queryset=Group.objects.all(),
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

class PlannedTaskSerializer(ModelSerializer):
    task_template = TaskTemplateSerializer(read_only=True)
    assignee = UserSerializer(read_only=True)
    assigner = UserSerializer(read_only=True)
    class Meta:
        model = PlannedTask
        fields = '__all__'
