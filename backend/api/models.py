import uuid
from django.db import models
from django.contrib.auth.models import AbstractUser

class User(AbstractUser):
    class GenderChoices(models.TextChoices):
        MALE = "male", "Male"
        FEMALE = "female", "Female"
        OTHER =  "other", "Other"

    gender = models.CharField(
        max_length=10,
        choices=GenderChoices.choices,
        default=GenderChoices.OTHER
    )
    # user_id = models.CharField(max_length=50, primary_key=True)

    def __str__(self):
        return self.username

class Group(models.Model):
    # group_id = models.CharField(max_length=100, unique=True)
    # there is a default id provided by Django
    group_name = models.CharField(max_length=100)
    users = models.ManyToManyField(User, related_name='groups')

    def __str__(self):
        return self.group_name


class GroupMembership(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    group = models.ForeignKey('Group', on_delete=models.CASCADE)
    team_credits = models.IntegerField(default=0)
    individual_credits = models.IntegerField(default=0)
    
    class Meta:
        unique_together = ('user', 'group') 
    def __str__(self):
        return f"{self.user.username} in {self.group.group_name}"


class Task_created(models.Model):
    # task_id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    # there is a default id provided by Django
    name = models.CharField(max_length=255)
    description = models.TextField()
    points = models.IntegerField(default=10)

    def __str__(self):
        return self.name
