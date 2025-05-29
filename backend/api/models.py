from django.db import models
from django.contrib.auth.models import AbstractUser
from django.core.validators import MinValueValidator, MaxValueValidator
from django.utils import timezone
from django.contrib.auth.base_user import BaseUserManager

class CustomUserManager(BaseUserManager):
    use_in_migrations = True

    def create_user(self, email, password=None, **extra_fields):
        if not email:
            raise ValueError('The Email must be set')
        email = self.normalize_email(email)
        user = self.model(email=email, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, email, password=None, **extra_fields):
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)
        extra_fields.setdefault('is_active', True)

        if extra_fields.get('is_staff') is not True:
            raise ValueError('Superuser must have is_staff=True.')
        if extra_fields.get('is_superuser') is not True:
            raise ValueError('Superuser must have is_superuser=True.')

        return self.create_user(email, password, **extra_fields)


class User(AbstractUser):
    groups = None
    user_permissions = None

    email = models.EmailField(unique=True)
    username = models.CharField(max_length=150, unique=False, blank=True)
    gender = models.CharField(
        max_length=10,
        choices=[('male', 'Male'), ('female', 'Female'), ('other', 'Other')],
        default='other',
    )

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = []

    objects = CustomUserManager()

    def __str__(self):
        return f"{self.username} ({self.email})"
    
class Group(models.Model):
    group_name = models.CharField(max_length=100)
    creator = models.ForeignKey(User, related_name='groups_created', on_delete=models.CASCADE)
    users = models.ManyToManyField(User, through='GroupMembership', related_name='group_users')

    class Meta:
        constraints = [
            models.UniqueConstraint(fields=['group_name', 'creator'], name='unique_group_per_creator')
        ]

    def __str__(self):
        return f"{self.group_name} (by {self.creator})"


class GroupMembership(models.Model):
    user = models.ForeignKey(User, related_name='memberships', on_delete=models.CASCADE)
    group = models.ForeignKey(Group, on_delete=models.CASCADE)
    team_credits = models.IntegerField(default=0)
    individual_credits = models.IntegerField(default=0)
    
    class Meta:
        unique_together = ('user', 'group')
    def __str__(self):
        return f"{self.user.username} in {self.group.group_name}"


class CreatedTask(models.Model):   
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

class PlannedTask(models.Model):
    task_template = models.ForeignKey(CreatedTask, on_delete=models.CASCADE, related_name="tasks_planned_group")
    start_time = models.DateTimeField(default=timezone.now)
    assignee = models.ForeignKey(User, on_delete=models.CASCADE, related_name="tasks_planned_person")
    assigner = models.ForeignKey(User, on_delete=models.CASCADE, related_name='tasks_delivered_person')
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
        return self.task_template.description
    def get_points(self):
        return self.custom_points if self.custom_points is not None else self.task_template.points
    def formatted_start_time(self):
        return self.start_time.strftime('%Y-%m-%d %H:%M')
    def __str__(self):
        return f"Planned: {self.task_template.task_name} to {self.assignee} in Group '{self.task_template.group}'"
