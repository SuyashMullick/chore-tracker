from django.db import models
from django.contrib.auth.models import AbstractUser
from django.core.validators import MinValueValidator, MaxValueValidator
from django.utils import timezone
from django.core.exceptions import ValidationError

class User(AbstractUser):
    # there is a default id provided by Django
    class GenderChoices(models.TextChoices):
        MALE = "male", "Male"
        FEMALE = "female", "Female"
        OTHER =  "other", "Other"

    email = models.EmailField(unique=True) # unique 
    username = models.CharField(max_length=150, unique=False, blank=True) 
    gender = models.CharField(
        max_length=10,
        choices=GenderChoices.choices,
        default=GenderChoices.OTHER
    )
    USERNAME_FIELD = 'email' # log in using email
    REQUIRED_FIELDS = [] # username is not compulsory

    def __str__(self):
        return f"{self.username} ({self.email})"

class Group(models.Model):
    group_name = models.CharField(max_length=100,unique=False)
    creator = models.ForeignKey(User, related_name='groups_created', on_delete=models.CASCADE)
    users = models.ManyToManyField(User, through='GroupMembership', related_name='groups')

    def __str__(self):
        return self.group_name


class GroupMembership(models.Model):
    user = models.ForeignKey(User, related_name='memberships', on_delete=models.CASCADE)
    group = models.ForeignKey(Group, on_delete=models.CASCADE)
    team_credits = models.IntegerField(default=0)
    individual_credits = models.IntegerField(default=0)
    
    class Meta:
        unique_together = ('user', 'group')
    def __str__(self):
        return f"{self.user.username} in {self.group.group_name}"


class TaskCreated(models.Model):   
    group = models.ForeignKey(Group, related_name="tasks_created", on_delete=models.CASCADE)
    task_name = models.CharField(max_length=100)
    description = models.TextField()
    points = models.IntegerField(
        default=1,
        validators=[MinValueValidator(1), MaxValueValidator(10)]
    )

    class Meta:
        constraints = [
            models.UniqueConstraint(fields=['group', 'task_name'], name='unique_task_per_group')
        ]
    def __str__(self):
        return self.task_name

class TaskAssigned(models.Model):
    task_template = models.ForeignKey(TaskCreated, on_delete=models.CASCADE, related_name="assigned_tasks")
    start_time = models.DateTimeField(default=timezone.now)
    assignee = models.ForeignKey(User, on_delete=models.CASCADE, related_name="tasks_assigned")
    assigner = models.ForeignKey(User, on_delete=models.CASCADE, related_name='tasks_delivered')
    custom_description = models.TextField(blank=True)
    custom_points = models.IntegerField(
        blank=True, null=True,
        validators=[MinValueValidator(1), MaxValueValidator(10)]
    )
    class StateChoices(models.TextChoices):
        OPEN = 'open', 'Open'
        DONE = 'done', 'Done'
        FINISHED = 'finished', 'Finished'

    state = models.CharField(
        max_length=10,
        choices=StateChoices.choices,
        default=StateChoices.OPEN
    )

    class Meta:
        constraints = [
            models.UniqueConstraint(fields=['task_template', 'start_time'], name='unique_task_assignment_per_time')
        ]
        ordering = ['-start_time']


    def get_task_name(self):
        return self.task_template.task_name
    def get_description(self):
        return self.custom_description if self.custom_description else self.task_template.description
    def get_points(self):
        return self.custom_points if self.custom_points is not None else self.task_template.points
    def formatted_start_time(self):
        return self.start_time.strftime('%Y-%m-%d %H:%M')
    def __str__(self):
        return f"Assigned: {self.task_template.task_name} to {self.assignee} in Group '{self.task_template.group}'"
