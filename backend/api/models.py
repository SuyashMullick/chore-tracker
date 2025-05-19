from django.db import models
from django.contrib.auth.models import AbstractUser


class User(AbstractUser):
    class GenderChoices(models.TextChoices):
        MALE = "male", "Male"
        FEMALE = "female", "Female"
        OTHER = "other", "Other"
    gender = models.CharField(max_length=10)
    points = models.IntegerField(default=0)
    
    def __str__(self):
        return self.username

class Task(models.Model):
    id = models.UUIDField()
    name = models.CharField(max_length=255)
    description = models.TextField()
    points = models.IntegerField(10)

    def __str__(self):
        return self.name
