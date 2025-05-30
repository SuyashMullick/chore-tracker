from datetime import timezone
from rest_framework.exceptions import ValidationError
from rest_framework import serializers
from rest_framework.serializers import ModelSerializer
from .models import User, Group, GroupMembership, CreatedTask, PlannedTask, User

# from .services import create_created_task

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

class TaskTemplateDisplaySerializer(ModelSerializer):
    group = GroupSerializer(read_only=True)
    class Meta:
        model = CreatedTask
        fields = '__all__'

class TaskTemplateCreateSerializer(serializers.Serializer):
    group = serializers.PrimaryKeyRelatedField(
        queryset=Group.objects.all(),
        )
    task_name = serializers.CharField(max_length=100)
    description = serializers.CharField(required=False, allow_blank=True)
    points = serializers.IntegerField(min_value=1, max_value=10)

    # def create(self, validated_data):
    #     return create_created_task(
    #         group=validated_data["group"],
    #         task_name=validated_data["task_name"],
    #         description=validated_data.get("description", ""),
    #         points=validated_data["points"],
    #     )
    def validate(self, attrs):
        group = attrs['group']
        task_name = attrs['task_name']
        if CreatedTask.objects.filter(group=group, task_name=task_name).exists():
            raise ValidationError("Task with this name already exists in this group")
        return attrs

    def create(self, validated_data):
        return CreatedTask.objects.create(**validated_data)

    def validate(self, attrs):
        group = attrs['group']
        task_name = attrs['task_name']
        if CreatedTask.objects.filter(group=group, task_name=task_name).exists():
            raise ValidationError("Task with this name already exists in this group")
        return attrs
    

class PlannedTaskDisplaySerializer(ModelSerializer):
    task_template = TaskTemplateDisplaySerializer(read_only=True)
    assignee = UserSerializer(read_only=True)
    assigner = UserSerializer(read_only=True)
    class Meta:
        model = PlannedTask
        fields = '__all__'

class PlannedTaskCreateSerializer(serializers.Serializer):
    task_template = serializers.PrimaryKeyRelatedField(queryset=CreatedTask.objects.all())
    assignee = serializers.PrimaryKeyRelatedField(queryset=User.objects.all())
    assigner = serializers.PrimaryKeyRelatedField(queryset=User.objects.all())
    state = serializers.ChoiceField(choices=PlannedTask.StateChoices)
    custom_points = serializers.IntegerField(required=False, min_value=1, max_value=10)
    start_time = serializers.DateTimeField()
    def validate(self, attrs):
        if attrs['assignee'] == attrs['assigner']:
            raise ValidationError("Assignee and assigner cannot be the same user.")
        return attrs

    def create(self, validated_data):
        return PlannedTask.objects.create(**validated_data)
    
class PlannedTaskUpdateSerializer(serializers.ModelSerializer):
    class Meta:
        model = PlannedTask
        fields = ['state']