import uuid
from django.db import models
from django.contrib.auth.models import AbstractUser

class User(AbstractUser):
    class GenderChoices(models.TextChoices):
        MALE = "male", "Male"
        FEMALE = "female", "Female"
        OTHER = "other", "Other"

    gender = models.CharField(
        max_length=10,
        choices=GenderChoices.choices,
        default=GenderChoices.OTHER
    )
    # points = models.IntegerField(default=0)
    userId = models.models.CharField(max_length=50)
    password = models.models.CharField(max_length=50)
    email = models.models.CharField(max_length=50)


    def __str__(self):
        return self.username

class Group(AbstractUser):
    group_id = models.models.CharField(max_length=50)
    user_id = models.models.CharField(max_length=50)
    team_credits = models.IntegerField()
    individual_credits = models.IntegerField()


class Task(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    name = models.CharField(max_length=255)
    description = models.TextField()
    points = models.IntegerField(default=10)

    def __str__(self):
        return self.name
